From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 30 Mar 2016 11:45:57 +0000
Subject: Re: [PATCH] sctp: really allow using GFP_KERNEL on sctp_packet_transmit
Message-Id: <20160330114556.GA15549@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1459258863-21351-1-git-send-email-marcelo.leitner@gmail.com>
In-Reply-To: <1459258863-21351-1-git-send-email-marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Mar 29, 2016 at 10:41:03AM -0300, Marcelo Ricardo Leitner wrote:
> Somehow my patch for commit cea8768f333e ("sctp: allow
> sctp_transmit_packet and others to use gfp") missed two important
> chunks, which are now added.
> 
> Fixes: cea8768f333e ("sctp: allow sctp_transmit_packet and others to use gfp")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/output.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 736c004abfbc2787a3c50fa85168ebdf3b112787..97745351d58c2fb32b9f9b57d61831d7724d83b2 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -401,7 +401,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
>  	sk = chunk->skb->sk;
>  
>  	/* Allocate the new skb.  */
> -	nskb = alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
> +	nskb = alloc_skb(packet->size + MAX_HEADER, gfp);
>  	if (!nskb)
>  		goto nomem;
>  
> @@ -523,8 +523,8 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
>  	 */
>  	if (auth)
>  		sctp_auth_calculate_hmac(asoc, nskb,
> -					(struct sctp_auth_chunk *)auth,
> -					GFP_ATOMIC);
> +					 (struct sctp_auth_chunk *)auth,
> +					 gfp);
>  
>  	/* 2) Calculate the Adler-32 checksum of the whole packet,
>  	 *    including the SCTP common header and all the
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-By: Neil Horman <nhorman@tuxdriver.com>

