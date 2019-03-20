From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 20 Mar 2019 11:24:06 +0000
Subject: Re: [PATCH net] sctp: use memdup_user instead of vmemdup_user
Message-Id: <20190320112406.GA15855@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <94e635135533b7469c84b0aa4df59ea7818a486a.1553064578.git.lucien.xin@gmail.com>
In-Reply-To: <94e635135533b7469c84b0aa4df59ea7818a486a.1553064578.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller@googlegroups.com

On Wed, Mar 20, 2019 at 02:49:38PM +0800, Xin Long wrote:
> In sctp_setsockopt_bindx()/__sctp_setsockopt_connectx(), it allocates
> memory with addrs_size which is passed from userspace. We used flag
> GFP_USER to put some more restrictions on it in Commit cacc06215271
> ("sctp: use GFP_USER for user-controlled kmalloc").
> 
> However, since Commit c981f254cc82 ("sctp: use vmemdup_user() rather
> than badly open-coding memdup_user()"), vmemdup_user() has been used,
> which doesn't check GFP_USER flag when goes to vmalloc_*(). So when
> addrs_size is a huge value, it could exhaust memory and even trigger
> oom killer.
> 
> This patch is to use memdup_user() instead, in which GFP_USER would
> work to limit the memory allocation with a huge addrs_size.
> 
> Note we can't fix it by limiting 'addrs_size', as there's no demand
> for it from RFC.
> 
> Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
> Fixes: c981f254cc82 ("sctp: use vmemdup_user() rather than badly open-coding memdup_user()")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 6140471..09ad5b2 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -999,7 +999,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	if (unlikely(addrs_size <= 0))
>  		return -EINVAL;
>  
> -	kaddrs = vmemdup_user(addrs, addrs_size);
> +	kaddrs = memdup_user(addrs, addrs_size);
>  	if (unlikely(IS_ERR(kaddrs)))
>  		return PTR_ERR(kaddrs);
>  
> @@ -1007,7 +1007,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	addr_buf = kaddrs;
>  	while (walk_size < addrs_size) {
>  		if (walk_size + sizeof(sa_family_t) > addrs_size) {
> -			kvfree(kaddrs);
> +			kfree(kaddrs);
>  			return -EINVAL;
>  		}
>  
> @@ -1018,7 +1018,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		 * causes the address buffer to overflow return EINVAL.
>  		 */
>  		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
> -			kvfree(kaddrs);
> +			kfree(kaddrs);
>  			return -EINVAL;
>  		}
>  		addrcnt++;
> @@ -1054,7 +1054,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	}
>  
>  out:
> -	kvfree(kaddrs);
> +	kfree(kaddrs);
>  
>  	return err;
>  }
> @@ -1329,7 +1329,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	if (unlikely(addrs_size <= 0))
>  		return -EINVAL;
>  
> -	kaddrs = vmemdup_user(addrs, addrs_size);
> +	kaddrs = memdup_user(addrs, addrs_size);
>  	if (unlikely(IS_ERR(kaddrs)))
>  		return PTR_ERR(kaddrs);
>  
> @@ -1349,7 +1349,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
>  
>  out_free:
> -	kvfree(kaddrs);
> +	kfree(kaddrs);
>  
>  	return err;
>  }
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
