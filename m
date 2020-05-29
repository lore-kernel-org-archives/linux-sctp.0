From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 May 2020 16:05:44 +0000
Subject: Re: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Message-Id: <20200529160544.GI2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-3-hch@lst.de>
In-Reply-To: <20200529120943.101454-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Laight <David.Laight@aculab.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:41PM +0200, Christoph Hellwig wrote:
> Split out a sctp_setsockopt_bindx_kernel that takes a kernel pointer
> to the sockaddr and make sctp_setsockopt_bindx a small wrapper around
> it.  This prepares for adding a new bind_add proto op.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 61 ++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 33 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 827a9903ee288..6e745ac3c4a59 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -972,23 +972,22 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
>   * it.
>   *
>   * sk        The sk of the socket
> - * addrs     The pointer to the addresses in user land
> + * addrs     The pointer to the addresses
>   * addrssize Size of the addrs buffer
>   * op        Operation to perform (add or remove, see the flags of
>   *           sctp_bindx)
>   *
>   * Returns 0 if ok, <0 errno code on error.
>   */
> -static int sctp_setsockopt_bindx(struct sock *sk,
> -				 struct sockaddr __user *addrs,
> -				 int addrs_size, int op)
> +static int sctp_setsockopt_bindx_kernel(struct sock *sk,
> +					struct sockaddr *addrs, int addrs_size,
> +					int op)
>  {
> -	struct sockaddr *kaddrs;
>  	int err;
>  	int addrcnt = 0;
>  	int walk_size = 0;
>  	struct sockaddr *sa_addr;
> -	void *addr_buf;
> +	void *addr_buf = addrs;
>  	struct sctp_af *af;
>  
>  	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
> @@ -997,17 +996,10 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	if (unlikely(addrs_size <= 0))
>  		return -EINVAL;
>  
> -	kaddrs = memdup_user(addrs, addrs_size);
> -	if (IS_ERR(kaddrs))
> -		return PTR_ERR(kaddrs);
> -
>  	/* Walk through the addrs buffer and count the number of addresses. */
> -	addr_buf = kaddrs;
>  	while (walk_size < addrs_size) {
> -		if (walk_size + sizeof(sa_family_t) > addrs_size) {
> -			kfree(kaddrs);
> +		if (walk_size + sizeof(sa_family_t) > addrs_size)
>  			return -EINVAL;
> -		}
>  
>  		sa_addr = addr_buf;
>  		af = sctp_get_af_specific(sa_addr->sa_family);
> @@ -1015,10 +1007,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		/* If the address family is not supported or if this address
>  		 * causes the address buffer to overflow return EINVAL.
>  		 */
> -		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
> -			kfree(kaddrs);
> +		if (!af || (walk_size + af->sockaddr_len) > addrs_size)
>  			return -EINVAL;
> -		}
>  		addrcnt++;
>  		addr_buf += af->sockaddr_len;
>  		walk_size += af->sockaddr_len;
> @@ -1029,31 +1019,36 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	case SCTP_BINDX_ADD_ADDR:
>  		/* Allow security module to validate bindx addresses. */
>  		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
> -						 (struct sockaddr *)kaddrs,
> -						 addrs_size);
> +						 addrs, addrs_size);
>  		if (err)
> -			goto out;
> -		err = sctp_bindx_add(sk, kaddrs, addrcnt);
> +			return err;
> +		err = sctp_bindx_add(sk, addrs, addrcnt);
>  		if (err)
> -			goto out;
> -		err = sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
> -		break;
> -
> +			return err;
> +		return sctp_send_asconf_add_ip(sk, addrs, addrcnt);
>  	case SCTP_BINDX_REM_ADDR:
> -		err = sctp_bindx_rem(sk, kaddrs, addrcnt);
> +		err = sctp_bindx_rem(sk, addrs, addrcnt);
>  		if (err)
> -			goto out;
> -		err = sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
> -		break;
> +			return err;
> +		return sctp_send_asconf_del_ip(sk, addrs, addrcnt);
>  
>  	default:
> -		err = -EINVAL;
> -		break;
> +		return -EINVAL;
>  	}
> +}
>  
> -out:
> -	kfree(kaddrs);
> +static int sctp_setsockopt_bindx(struct sock *sk,
> +				 struct sockaddr __user *addrs,
> +				 int addrs_size, int op)
> +{
> +	struct sockaddr *kaddrs;
> +	int err;
>  
> +	kaddrs = memdup_user(addrs, addrs_size);
> +	if (IS_ERR(kaddrs))
> +		return PTR_ERR(kaddrs);
> +	err = sctp_setsockopt_bindx_kernel(sk, kaddrs, addrs_size, op);
> +	kfree(kaddrs);
>  	return err;
>  }
>  
> -- 
> 2.26.2
> 
