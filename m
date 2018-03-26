From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Mar 2018 19:20:28 +0000
Subject: Re: [PATCH net] sctp: remove unnecessary asoc in sctp_has_association
Message-Id: <20180326192028.GA1290@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <955d9f51fafeb670cb4468e6253f4e54cd3c90f0.1522054500.git.lucien.xin@gmail.com>
In-Reply-To: <955d9f51fafeb670cb4468e6253f4e54cd3c90f0.1522054500.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Mar 26, 2018 at 04:55:00PM +0800, Xin Long wrote:
> After Commit dae399d7fdee ("sctp: hold transport instead of assoc
> when lookup assoc in rx path"), it put transport instead of asoc
> in sctp_has_association. Variable 'asoc' is not used any more.
> 
> So this patch is to remove it, while at it,  it also changes the
> return type of sctp_has_association to bool, and does the same
> for it's caller sctp_endpoint_is_peeled_off.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/structs.h |  8 ++++----
>  net/sctp/endpointola.c     |  8 ++++----
>  net/sctp/input.c           | 13 ++++++-------
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 03e92dd..13e644d 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1337,12 +1337,12 @@ struct sctp_association *sctp_endpoint_lookup_assoc(
>  	const struct sctp_endpoint *ep,
>  	const union sctp_addr *paddr,
>  	struct sctp_transport **);
> -int sctp_endpoint_is_peeled_off(struct sctp_endpoint *,
> -				const union sctp_addr *);
> +bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
> +				 const union sctp_addr *paddr);
>  struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *,
>  					struct net *, const union sctp_addr *);
> -int sctp_has_association(struct net *net, const union sctp_addr *laddr,
> -			 const union sctp_addr *paddr);
> +bool sctp_has_association(struct net *net, const union sctp_addr *laddr,
> +			  const union sctp_addr *paddr);
>  
>  int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
>  		     const struct sctp_association *asoc,
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index 8b31468..e2f5a3e 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -349,8 +349,8 @@ struct sctp_association *sctp_endpoint_lookup_assoc(
>  /* Look for any peeled off association from the endpoint that matches the
>   * given peer address.
>   */
> -int sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
> -				const union sctp_addr *paddr)
> +bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
> +				 const union sctp_addr *paddr)
>  {
>  	struct sctp_sockaddr_entry *addr;
>  	struct sctp_bind_addr *bp;
> @@ -362,10 +362,10 @@ int sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
>  	 */
>  	list_for_each_entry(addr, &bp->address_list, list) {
>  		if (sctp_has_association(net, &addr->a, paddr))
> -			return 1;
> +			return true;
>  	}
>  
> -	return 0;
> +	return false;
>  }
>  
>  /* Do delayed input processing.  This is scheduled by sctp_rcv().
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index b381d78..ba8a6e6 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -1010,19 +1010,18 @@ struct sctp_association *sctp_lookup_association(struct net *net,
>  }
>  
>  /* Is there an association matching the given local and peer addresses? */
> -int sctp_has_association(struct net *net,
> -			 const union sctp_addr *laddr,
> -			 const union sctp_addr *paddr)
> +bool sctp_has_association(struct net *net,
> +			  const union sctp_addr *laddr,
> +			  const union sctp_addr *paddr)
>  {
> -	struct sctp_association *asoc;
>  	struct sctp_transport *transport;
>  
> -	if ((asoc = sctp_lookup_association(net, laddr, paddr, &transport))) {
> +	if (sctp_lookup_association(net, laddr, paddr, &transport)) {
>  		sctp_transport_put(transport);
> -		return 1;
> +		return true;
>  	}
>  
> -	return 0;
> +	return false;
>  }
>  
>  /*
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

