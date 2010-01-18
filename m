From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 18 Jan 2010 04:51:18 +0000
Subject: Re: sctp: move chunk from retransmit queue to abandoned list
Message-Id: <4B53E8C6.2070000@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B4FE548.9070705@cn.fujitsu.com>
In-Reply-To: <4B4FE548.9070705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> If there is still data waiting to retransmit and remain in
>> retransmit queue, while doing the next retransmit, if the
>> chunk is abandoned, we should move it to abandoned list.
>>     
>
> I think it might be better to move this to sctp_outq_flush_rtx().
> Then we can reduce this to just the sctp_chunk_abandoned() check.
>   
Maybe both place need this check?

Check in sctp_retransmit_mark() can early indicating the retransmit chunk
is abandoned when we do retransmit and send the FORWARD TSN chunk.
And check in sctp_retransmit_mark() only miss the process when new DATA
send is coming and still have retransmit chunk.

If we received SACK, this expired chunks can also be remove to
abandoned list when we do sctp_outq_sack().

Check in sctp_outq_flush_rtx() aim to check only when new DATA is coming
and we send the retransmit chunk before the new DATA.

Just move this code to sctp_outq_flush_rtx() may have other issue. The
FORWARD TSN chunk is sent before we do sctp_outq_flush_rtx(), so the
retransmit chunk will remain in abandoned list until next rtx timeout or
received SACK. If all of the DATA chunks are abandoned, nothing will be
sent in this timeout.


> Remember, retransmit_mark is not executed that often.  Also, if
> we have move then one chunk on the retransmit queue, some part of
> the queue may expire without us ever running retransmit_mark() again.
>
>   
> However, when we flush the queue, we should check for timed out chunks
> just like when we flush the outqueue.
>   

The outqueue does not need to send the FORWARD TSN chunk
because it does not hold an TSN. But retransmit queue need to
send the FORWARD TSN chunk.


[PATCH v2] sctp: move chunk from retransmit queue to abandoned list

If there is still data waiting to retransmit and remain in
retransmit queue, while doing the next retransmit, if the
chunk is abandoned, we should move it to abandoned list.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 229690f..d36aea4 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -390,6 +390,18 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 	struct list_head *lchunk, *ltemp;
 	struct sctp_chunk *chunk;
 
+	/* Walk through the retransmit queue */
+	list_for_each_safe(lchunk, ltemp, &q->retransmit) {
+		chunk = list_entry(lchunk, struct sctp_chunk,
+				   transmitted_list);
+
+		/* If the chunk is abandoned, move it to abandoned list. */
+		if (sctp_chunk_abandoned(chunk)) {
+			list_del_init(lchunk);
+			sctp_insert_list(&q->abandoned, lchunk);
+		}
+	}
+
 	/* Walk through the specified transmitted queue.  */
 	list_for_each_safe(lchunk, ltemp, &transport->transmitted) {
 		chunk = list_entry(lchunk, struct sctp_chunk,
@@ -578,6 +590,12 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 	 * try to send as much as possible.
 	 */
 	list_for_each_entry_safe(chunk, chunk1, lqueue, transmitted_list) {
+		/* If the chunk is abandoned, move it to abandoned list. */
+		if (!rtx_timeout && sctp_chunk_abandoned(chunk)) {
+			list_del_init(&chunk->transmitted_list);
+			sctp_insert_list(&q->abandoned,
+					 &chunk->transmitted_list);
+		}
 
 		/* Make sure that Gap Acked TSNs are not retransmitted.  A
 		 * simple approach is just to move such TSNs out of the
-- 
1.6.2.2



