From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 30 Mar 2016 12:03:57 +0000
Subject: Re: [PATCH] sctp: flush if we can't fit another DATA chunk
Message-Id: <20160330120357.GB15549@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1459258885-21502-1-git-send-email-marcelo.leitner@gmail.com>
In-Reply-To: <1459258885-21502-1-git-send-email-marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Mar 29, 2016 at 10:41:25AM -0300, Marcelo Ricardo Leitner wrote:
> There is no point in delaying the packet if we can't fit a single byte
> of data on it anymore. So lets just reduce the threshold by the amount
> that a data chunk with 4 bytes (rounding) would use.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/output.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 97745351d58c2fb32b9f9b57d61831d7724d83b2..c518569123ce42a8f21f80754756306c39875013 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -705,7 +705,8 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
>  	/* Check whether this chunk and all the rest of pending data will fit
>  	 * or delay in hopes of bundling a full sized packet.
>  	 */
> -	if (chunk->skb->len + q->out_qlen >= transport->pathmtu - packet->overhead)
> +	if (chunk->skb->len + q->out_qlen >
> +		maxsize - packet->overhead - sizeof(sctp_data_chunk_t) - 4)
>  		/* Enough data queued to fill a packet */
>  		return SCTP_XMIT_OK;
>  
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Acked-By: Neil Horman <nhorman@tuxdriver.com>
