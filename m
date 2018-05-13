From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 13 May 2018 21:40:47 +0000
Subject: Re: [PATCH net-next v2 2/3] sctp: add asoc and packet to sctp_flush_ctx
Message-Id: <20180513214047.GY5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142994.git.marcelo.leitner@gmail.com>
 <8de39e2ff04a8a96440c8b5f66cbc5cbc6303067.1526142994.git.marcelo.leitner@gmail.com>
In-Reply-To: <8de39e2ff04a8a96440c8b5f66cbc5cbc6303067.1526142994.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

On Sat, May 12, 2018 at 07:21:51PM -0300, Marcelo Ricardo Leitner wrote:
> @@ -1043,20 +1038,17 @@ static bool sctp_outq_flush_rtx(struct sctp_flush_ctx *ctx,
>  static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
>  				 int rtx_timeout)
>  {
> -	struct sctp_packet *packet = ctx->transport ? &ctx->transport->packet :
> -				     NULL;
> -	struct sctp_association *asoc = ctx->q->asoc;
>  	struct sctp_chunk *chunk;
>  	enum sctp_xmit status;
>
>  	/* Is it OK to send data chunks?  */
> -	switch (asoc->state) {
> +	switch (ctx->asoc->state) {
>  	case SCTP_STATE_COOKIE_ECHOED:
>  		/* Only allow bundling when this packet has a COOKIE-ECHO
>  		 * chunk.
>  		 */
> -		if (!packet || !packet->has_cookie_echo)
> -			return;
> +		if (!ctx->packet || !ctx->packet->has_cookie_echo)
> +			break;

This return/break change was by mistake. Will post v3 tomorrow.
