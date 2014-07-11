From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 11 Jul 2014 20:03:11 +0000
Subject: Re: [PATCH net-next v2 2/3] net: sctp: Rename SCTP_XMIT_NAGLE_DELAY to SCTP_XMIT_DELAY
Message-Id: <53C042FF.3040109@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1726EEB8@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726EEB8@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Cc: "'davem@davemloft.net'" <davem@davemloft.net>

On 07/09/2014 04:29 AM, David Laight wrote:
> MSG_MORE and 'corking' a socket would require that the transmit of
> a data chunk be delayed.
> Rename the return value to be less specific.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>  include/net/sctp/constants.h | 2 +-
>  net/sctp/output.c            | 4 ++--
>  net/sctp/outqueue.c          | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> index 307728f..8c337cd 100644
> --- a/include/net/sctp/constants.h
> +++ b/include/net/sctp/constants.h
> @@ -311,7 +311,7 @@ typedef enum {
>  	SCTP_XMIT_OK,
>  	SCTP_XMIT_PMTU_FULL,
>  	SCTP_XMIT_RWND_FULL,
> -	SCTP_XMIT_NAGLE_DELAY,
> +	SCTP_XMIT_DELAY,
>  } sctp_xmit_t;
>  
>  /* These are the commands for manipulating transports.  */
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 553ba1d..7f28a8e 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -178,7 +178,7 @@ sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
>  
>  	case SCTP_XMIT_RWND_FULL:
>  	case SCTP_XMIT_OK:
> -	case SCTP_XMIT_NAGLE_DELAY:
> +	case SCTP_XMIT_DELAY:
>  		break;
>  	}
>  
> @@ -712,7 +712,7 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
>  		return SCTP_XMIT_OK;
>  
>  	/* Defer until all data acked or packet full */
> -	return SCTP_XMIT_NAGLE_DELAY;
> +	return SCTP_XMIT_DELAY;
>  }
>  
>  /* This private function does management things when adding DATA chunk */
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 9c77947..9ce0f3d 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -629,7 +629,7 @@ redo:
>  			done = 1;
>  			break;
>  
> -		case SCTP_XMIT_NAGLE_DELAY:
> +		case SCTP_XMIT_DELAY:
>  			/* Send this packet. */
>  			error = sctp_packet_transmit(pkt);
>  
> @@ -1015,7 +1015,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  			switch (status) {
>  			case SCTP_XMIT_PMTU_FULL:
>  			case SCTP_XMIT_RWND_FULL:
> -			case SCTP_XMIT_NAGLE_DELAY:
> +			case SCTP_XMIT_DELAY:
>  				/* We could not append this chunk, so put
>  				 * the chunk back on the output queue.
>  				 */
> 

