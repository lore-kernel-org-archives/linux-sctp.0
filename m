From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 19 Dec 2013 18:16:27 +0000
Subject: Re: undetected closed apps
Message-Id: <52B337FB.6090104@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/19/2013 12:24 PM, Vlad Yasevich wrote:
> On 12/19/2013 09:26 AM, Jamal Hadi Salim wrote:
>> On 12/18/13 12:58, Vlad Yasevich wrote:
>>> On 12/18/2013 07:30 AM, Jamal Hadi Salim wrote:
>>
>>> could you post an output for /proc/net/sctp/assocs for the association
>>> in this bad state?
>>
>> It's not eye candy (lines wrap around). But here's one i just
>> reproduced with client/server on same machine via lo. It requires
>> a few tries to make sure we have send failed for this to happen.
>>
>> ----
>> SSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
>> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC wmema
>> wmemq sndbuf rcvbuf
>>        0        0 2   7   4  29808   11        0        0       0     0
>
> So, on this line socket state (SST) is 7 which is SCTP_SS_CLOSED.  This
> means that you performed a close() call.  The association state (ST) is
> 4 which is SHUTDOWN_PENDING.  This means that when you tried to close
> the socket, the association thought that there was some pending data.
>
> I seem to remember you and I discussing this situation before, but I
> can't find that thread.
>
> I'll take another look at how PR interacts with queue state to see if
> we can detect the proper empty state to send a SHUTDOWN.
>

So, I took another look and it looks like there is an issue when the
chunks are being abandoned in sctp_outq_flush().  We simply delete
the chunks and it is possible that we can drain our queue without
ever setting the empty state.  Since we didn't sent anything, we
wouldn't get any SACKs, thus the queue would never be set as empty
and we would be stuck in the SHUTDOWN_PENDING state, just like you
observe.

Can you try this patch to see if it resolves things.  Can play with
netem values on lo to trigger PR faster.

Thanks
-vlad


diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index b6b09f3..31c8124 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -721,6 +721,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int
rtx_timeout)
 	int error = 0;
 	int start_timer = 0;
 	int one_packet = 0;
+	int empty = 1;

 	/* These transports have chunks to send. */
 	struct list_head transport_list;
@@ -1064,8 +1065,6 @@ static int sctp_outq_flush(struct sctp_outq *q,
int rtx_timeout)

 			sctp_transport_reset_timers(transport);

-			q->empty = 0;
-
 			/* Only let one DATA chunk get bundled with a
 			 * COOKIE-ECHO chunk.
 			 */
@@ -1081,12 +1080,13 @@ static int sctp_outq_flush(struct sctp_outq *q,
int rtx_timeout)

 sctp_flush_out:

+	empty = (list_empty(&q->out_chunk_list) &&
+		 list_empty(&q->retransmit));
+
 	/* Before returning, examine all the transports touched in
-	 * this call.  Right now, we bluntly force clear all the
-	 * transports.  Things might change after we implement Nagle.
-	 * But such an examination is still required.
-	 *
-	 * --xguo
+	 * this call.  If anything is still in the packet of the transport,
+	 * flush it now.  Also, make sure that if we sent any DATA, we
+	 * correctly track the queue empty state.
 	 */
 	while ((ltransport = sctp_list_dequeue(&transport_list)) != NULL ) {
 		struct sctp_transport *t = list_entry(ltransport,
@@ -1098,7 +1098,11 @@ sctp_flush_out:

 		/* Clear the burst limited state, if any */
 		sctp_transport_burst_reset(t);
+
+		if (empty)
+			empty = empty && list_empty(&t->transmitted);
 	}
+	q->empty = empty;

 	return error;
 }
