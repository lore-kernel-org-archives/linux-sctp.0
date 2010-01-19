From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 19 Jan 2010 15:37:40 +0000
Subject: Re: [PATCH] sctp: assure at least one T3-rtx timer is running if
Message-Id: <4B55D1C4.4030508@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B53F207.3090903@cn.fujitsu.com>
In-Reply-To: <4B53F207.3090903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Wei Yongjun wrote:
> PR-SCTP extension section 3.5 Sender Side Implementation of PR-SCTP:
>   C5) If a FORWARD TSN is sent, the sender MUST assure that at
>       least one T3-rtx timer is running.
> 
> So this patch fix to assure at least one T3-rtx timer is running
> if a FORWARD TSN is or will to sent.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/outqueue.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index d36aea4..67ec3ba 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -939,6 +939,13 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  				goto sctp_flush_out;
>  		}
>  
> +		/* PR-SCTP C5) If a FORWARD TSN is sent, the sender MUST assure
> +		 * that at least one T3-rtx timer is running.
> +		 */
> +		if (!list_empty(&q->abandoned) &&
> +		    list_empty(&q->out_chunk_list))
> +			sctp_transport_reset_timers(transport, 0);
> +
>  		/* Apply Max.Burst limitation to the current transport in
>  		 * case it will be used for new data.  We are going to
>  		 * rest it before we return, but we want to apply the limit

'transport' may be NULL or may point at a retransmit path, not the path
FWD-TSN was sent on.

It might be better to do this when we queue the FWD-TSN chunk.

-vlad

