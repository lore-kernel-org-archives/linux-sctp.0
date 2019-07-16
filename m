From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 16 Jul 2019 02:51:00 +0000
Subject: Re: [PATCH] net: sctp: fix warning "NULL check before some freeing functions is not needed"
Message-Id: <20190716025100.GM3390@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190716022002.GA19592@hari-Inspiron-1545>
In-Reply-To: <20190716022002.GA19592@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 16, 2019 at 07:50:02AM +0530, Hariprasad Kelam wrote:
> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_make_chunk.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ed39396..36bd8a6e 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2582,8 +2582,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len >  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> -		if (asoc->peer.cookie)
> -			kfree(asoc->peer.cookie);
> +		kfree(asoc->peer.cookie);
>  		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			retval = 0;
> @@ -2648,8 +2647,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's random parameter */
> -		if (asoc->peer.peer_random)
> -			kfree(asoc->peer.peer_random);
> +		kfree(asoc->peer.peer_random);
>  		asoc->peer.peer_random = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_random) {
> @@ -2663,8 +2661,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's HMAC list */
> -		if (asoc->peer.peer_hmacs)
> -			kfree(asoc->peer.peer_hmacs);
> +		kfree(asoc->peer.peer_hmacs);
>  		asoc->peer.peer_hmacs = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_hmacs) {
> @@ -2680,8 +2677,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  		if (!ep->auth_enable)
>  			goto fall_through;
>  
> -		if (asoc->peer.peer_chunks)
> -			kfree(asoc->peer.peer_chunks);
> +		kfree(asoc->peer.peer_chunks);
>  		asoc->peer.peer_chunks = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_chunks)
> -- 
> 2.7.4
> 
