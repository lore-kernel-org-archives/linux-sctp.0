From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 15 Jan 2010 15:31:04 +0000
Subject: Re: sctp: move chunk from retransmit queue to abandoned list
Message-Id: <4B508A38.2010703@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B4FE548.9070705@cn.fujitsu.com>
In-Reply-To: <4B4FE548.9070705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Wei Yongjun wrote:
> If there is still data waiting to retransmit and remain in
> retransmit queue, while doing the next retransmit, if the
> chunk is abandoned, we should move it to abandoned list.

I think it might be better to move this to sctp_outq_flush_rtx().
Then we can reduce this to just the sctp_chunk_abandoned() check.

Remember, retransmit_mark is not executed that often.  Also, if
we have move then one chunk on the retransmit queue, some part of
the queue may expire without us ever running retransmit_mark() again.
However, when we flush the queue, we should check for timed out chunks
just like when we flush the outqueue.

-vlad

> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/outqueue.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 229690f..8092032 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -390,6 +390,18 @@ void sctp_retransmit_mark(struct sctp_outq *q,
>  	struct list_head *lchunk, *ltemp;
>  	struct sctp_chunk *chunk;
>  
> +	/* Walk through the retransmit queue */
> +	list_for_each_safe(lchunk, ltemp, &q->retransmit) {
> +		chunk = list_entry(lchunk, struct sctp_chunk,
> +				   transmitted_list);
> +
> +		/* If the chunk is abandoned, move it to abandoned list. */
> +		if (sctp_chunk_abandoned(chunk)) {
> +			list_del_init(lchunk);
> +			sctp_insert_list(&q->abandoned, lchunk);
> +		}
> +	}
> +
>  	/* Walk through the specified transmitted queue.  */
>  	list_for_each_safe(lchunk, ltemp, &transport->transmitted) {
>  		chunk = list_entry(lchunk, struct sctp_chunk,
