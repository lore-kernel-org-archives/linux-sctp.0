From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 12 Jan 2018 20:14:49 +0000
Subject: Re: [PATCH net] sctp: avoid compiler warning on implicit fallthru
Message-Id: <20180112201449.GF20015@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <723287f9069c30675dbde82b5e45f3a076901a6b.1515687695.git.marcelo.leitner@gmail.com>
In-Reply-To: <723287f9069c30675dbde82b5e45f3a076901a6b.1515687695.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Jan 11, 2018 at 02:22:06PM -0200, Marcelo Ricardo Leitner wrote:
> These fall-through are expected.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/ipv6.c     | 1 +
>  net/sctp/outqueue.c | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 3b18085e3b10253f3f81be7a6747b50ef9357db2..5d4c15bf66d26219415596598a1f72d29b63a798 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -826,6 +826,7 @@ static int sctp_inet6_af_supported(sa_family_t family, struct sctp_sock *sp)
>  	case AF_INET:
>  		if (!__ipv6_only_sock(sctp_opt2sk(sp)))
>  			return 1;
> +		/* fallthru */
>  	default:
>  		return 0;
>  	}
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 7d67feeeffc1e758ae4be4ef1ddaea23276d1f5e..c4ec99b2015002b273071e6fb1ec3c59c9f61154 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -918,9 +918,9 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
>  			break;
>  
>  		case SCTP_CID_ABORT:
> -			if (sctp_test_T_bit(chunk)) {
> +			if (sctp_test_T_bit(chunk))
>  				packet->vtag = asoc->c.my_vtag;
> -			}
> +			/* fallthru */
>  		/* The following chunks are "response" chunks, i.e.
>  		 * they are generated in response to something we
>  		 * received.  If we are sending these, then we can
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
