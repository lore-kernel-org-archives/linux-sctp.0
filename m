From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 25 Apr 2018 11:49:20 +0000
Subject: Re: [PATCH net-next] sctp: remove the unused sctp_assoc_is_match function
Message-Id: <20180425114920.GC17646@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0acb8eaec9a5be9959d39bb5017d49bb31d0d5e5.1524649607.git.lucien.xin@gmail.com>
In-Reply-To: <0acb8eaec9a5be9959d39bb5017d49bb31d0d5e5.1524649607.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Wed, Apr 25, 2018 at 05:46:47PM +0800, Xin Long wrote:
> After Commit 4f0087812648 ("sctp: apply rhashtable api to send/recv
> path"), there's no place using sctp_assoc_is_match, so remove it.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/structs.h |  4 ----
>  net/sctp/associola.c       | 25 -------------------------
>  2 files changed, 29 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index a0ec462..05594b2 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -2091,10 +2091,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  				  enum sctp_transport_cmd command,
>  				  sctp_sn_error_t error);
>  struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *, __u32);
> -struct sctp_transport *sctp_assoc_is_match(struct sctp_association *,
> -					   struct net *,
> -					   const union sctp_addr *,
> -					   const union sctp_addr *);
>  void sctp_assoc_migrate(struct sctp_association *, struct sock *);
>  int sctp_assoc_update(struct sctp_association *old,
>  		      struct sctp_association *new);
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 837806d..a8f3b08 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -988,31 +988,6 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
>  	return match;
>  }
>  
> -/* Is this the association we are looking for? */
> -struct sctp_transport *sctp_assoc_is_match(struct sctp_association *asoc,
> -					   struct net *net,
> -					   const union sctp_addr *laddr,
> -					   const union sctp_addr *paddr)
> -{
> -	struct sctp_transport *transport;
> -
> -	if ((htons(asoc->base.bind_addr.port) = laddr->v4.sin_port) &&
> -	    (htons(asoc->peer.port) = paddr->v4.sin_port) &&
> -	    net_eq(sock_net(asoc->base.sk), net)) {
> -		transport = sctp_assoc_lookup_paddr(asoc, paddr);
> -		if (!transport)
> -			goto out;
> -
> -		if (sctp_bind_addr_match(&asoc->base.bind_addr, laddr,
> -					 sctp_sk(asoc->base.sk)))
> -			goto out;
> -	}
> -	transport = NULL;
> -
> -out:
> -	return transport;
> -}
> -
>  /* Do delayed input processing.  This is scheduled by sctp_rcv(). */
>  static void sctp_assoc_bh_rcv(struct work_struct *work)
>  {
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

