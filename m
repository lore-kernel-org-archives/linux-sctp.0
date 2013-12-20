From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 20 Dec 2013 18:44:55 +0000
Subject: Re: undetected closed apps
Message-Id: <52B49027.9030508@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/19/13 13:16, Vlad Yasevich wrote:


I can confirm this fixes the issue. Thanks!

Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index b6b09f3..31c8124 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -721,6 +721,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int
> rtx_timeout)
>   	int error = 0;
>   	int start_timer = 0;
>   	int one_packet = 0;
> +	int empty = 1;
>
>   	/* These transports have chunks to send. */
>   	struct list_head transport_list;
> @@ -1064,8 +1065,6 @@ static int sctp_outq_flush(struct sctp_outq *q,
> int rtx_timeout)
>
>   			sctp_transport_reset_timers(transport);
>
> -			q->empty = 0;
> -
>   			/* Only let one DATA chunk get bundled with a
>   			 * COOKIE-ECHO chunk.
>   			 */
> @@ -1081,12 +1080,13 @@ static int sctp_outq_flush(struct sctp_outq *q,
> int rtx_timeout)
>
>   sctp_flush_out:
>
> +	empty = (list_empty(&q->out_chunk_list) &&
> +		 list_empty(&q->retransmit));
> +
>   	/* Before returning, examine all the transports touched in
> -	 * this call.  Right now, we bluntly force clear all the
> -	 * transports.  Things might change after we implement Nagle.
> -	 * But such an examination is still required.
> -	 *
> -	 * --xguo
> +	 * this call.  If anything is still in the packet of the transport,
> +	 * flush it now.  Also, make sure that if we sent any DATA, we
> +	 * correctly track the queue empty state.
>   	 */
>   	while ((ltransport = sctp_list_dequeue(&transport_list)) != NULL ) {
>   		struct sctp_transport *t = list_entry(ltransport,
> @@ -1098,7 +1098,11 @@ sctp_flush_out:
>
>   		/* Clear the burst limited state, if any */
>   		sctp_transport_burst_reset(t);
> +
> +		if (empty)
> +			empty = empty && list_empty(&t->transmitted);
>   	}
> +	q->empty = empty;
>
>   	return error;
>   }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

