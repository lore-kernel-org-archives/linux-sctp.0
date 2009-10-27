From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 27 Oct 2009 15:07:57 +0000
Subject: Re: [tsvwg] SCTP Socket API modification proposal - update
Message-Id: <4AE70CCD.8090702@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------090306000107040407050305"
List-Id: <linux-sctp.vger.kernel.org>
References: <4AE70C97.6050507@hp.com>
In-Reply-To: <4AE70C97.6050507@hp.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------090306000107040407050305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



Vlad Yasevich wrote:
> 
> Florian Niederbacher wrote:
>> Hi,
>> thank you very much for the patch. Now it works like a charm! I need now
>> only to change
>> the MAX_BURST value otherwise after the connection goes into idle state
>> the cwnd will be reduced to fast.
>> (Default MAX_BURST  = 4 and MTU = 1500 ->  cwnd = 6000)
>> I guess this is intended by the rule from RFC 4960 in section
>>
>>
>>      6.1. Transmission of DATA Chunks
>>
>>
>>      D) When the time comes for the sender to transmit new DATA chunks,
>>      the protocol parameter Max.Burst SHOULD be used to limit the
>>      number of packets sent.  The limit MAY be applied by adjusting
>>      cwnd as follows:
>>
>>      if((flightsize + Max.Burst*MTU) < cwnd) cwnd = flightsize +
>>      Max.Burst*MTU
>>
>>
>> I am right?
>>
> 
> I think this rule gets mis-applied in this situation.  The idea behind max burst
> is to not burst out a lot of data in response to a SACK.
> 
> Can you try this patch and let me know what you see.

And now actually with a patch... :)

--------------090306000107040407050305
Content-Type: text/plain;
 name="max_burst"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="max_burst"

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0230dcc..1367ae8 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -942,6 +942,8 @@ struct sctp_transport {
 	/* Data that has been sent, but not acknowledged. */
 	__u32 flight_size;
 
+	__u32 burst_limited;	/* Holds old cwnd when max.burst is applied */
+
 	/* TSN marking the fast recovery exit point */
 	__u32 fast_recovery_exit;
 
@@ -1070,6 +1072,8 @@ void sctp_transport_put(struct sctp_transport *);
 void sctp_transport_update_rto(struct sctp_transport *, __u32);
 void sctp_transport_raise_cwnd(struct sctp_transport *, __u32, __u32);
 void sctp_transport_lower_cwnd(struct sctp_transport *, sctp_lower_cwnd_t);
+void sctp_transport_burst_limited(struct sctp_transport *);
+void sctp_transport_burst_reset(struct sctp_transport *);
 unsigned long sctp_transport_timeout(struct sctp_transport *);
 void sctp_transport_reset(struct sctp_transport *);
 void sctp_transport_update_pmtu(struct sctp_transport *, u32);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a7e26a4..188aa15 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -738,6 +738,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 
 	peer->partial_bytes_acked = 0;
 	peer->flight_size = 0;
+	peer->burst_limited = 0;
 
 	/* Set the transport's RTO.initial value */
 	peer->rto = asoc->rto_initial;
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 9e8e0ea..b210d20 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -615,7 +615,6 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
 	sctp_xmit_t retval = SCTP_XMIT_OK;
 	size_t datasize, rwnd, inflight, flight_size;
 	struct sctp_transport *transport = packet->transport;
-	__u32 max_burst_bytes;
 	struct sctp_association *asoc = transport->asoc;
 	struct sctp_outq *q = &asoc->outqueue;
 
@@ -648,28 +647,6 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
 		}
 	}
 
-	/* sctpimpguide-05 2.14.2
-	 * D) When the time comes for the sender to
-	 * transmit new DATA chunks, the protocol parameter Max.Burst MUST
-	 * first be applied to limit how many new DATA chunks may be sent.
-	 * The limit is applied by adjusting cwnd as follows:
-	 * 	if ((flightsize + Max.Burst * MTU) < cwnd)
-	 *		cwnd = flightsize + Max.Burst * MTU
-	 */
-	max_burst_bytes = asoc->max_burst * asoc->pathmtu;
-	if ((flight_size + max_burst_bytes) < transport->cwnd) {
-		transport->cwnd = flight_size + max_burst_bytes;
-		SCTP_DEBUG_PRINTK("%s: cwnd limited by max_burst: "
-				  "transport: %p, cwnd: %d, "
-				  "ssthresh: %d, flight_size: %d, "
-				  "pba: %d\n",
-				  __func__, transport,
-				  transport->cwnd,
-				  transport->ssthresh,
-				  transport->flight_size,
-				  transport->partial_bytes_acked);
-	}
-
 	/* RFC 2960 6.1  Transmission of DATA Chunks
 	 *
 	 * B) At any given time, the sender MUST NOT transmit new data
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 5732661..2f23773 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -931,6 +931,14 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				goto sctp_flush_out;
 		}
 
+		/* Apply Max.Burst limitation to the current transport in
+		 * case it will be used for new data.  We are going to
+		 * rest it before we return, but we want to apply the limit
+		 * to the currently queued data.
+		 */
+		if (transport)
+			sctp_transport_burst_limited(transport);
+
 		/* Finally, transmit new packets.  */
 		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
 			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
@@ -976,6 +984,10 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				packet = &transport->packet;
 				sctp_packet_config(packet, vtag,
 						   asoc->peer.ecn_capable);
+				/* We've switched transports, so apply the
+				 * Burst limit to the new transport.
+				 */
+				sctp_transport_burst_limited(transport);
 			}
 
 			SCTP_DEBUG_PRINTK("sctp_outq_flush(%p, %p[%s]), ",
@@ -1070,6 +1082,9 @@ sctp_flush_out:
 		packet = &t->packet;
 		if (!sctp_packet_empty(packet))
 			error = sctp_packet_transmit(packet);
+
+		/* Clear the burst limited state, if any */
+		sctp_transport_burst_reset(t);
 	}
 
 	return error;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index a16df87..fab36b8 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -575,6 +575,43 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
 			  transport->cwnd, transport->ssthresh);
 }
 
+/* Apply Max.Burst limit to the congestion window:
+ * sctpimpguide-05 2.14.2
+ * D) When the time comes for the sender to
+ * transmit new DATA chunks, the protocol parameter Max.Burst MUST
+ * first be applied to limit how many new DATA chunks may be sent.
+ * The limit is applied by adjusting cwnd as follows:
+ * 	if ((flightsize+ Max.Burst * MTU) < cwnd)
+ * 		cwnd = flightsize + Max.Burst * MTU
+ */
+
+void sctp_transport_burst_limited(struct sctp_transport *t)
+{
+	struct sctp_association *asoc = t->asoc;
+	u32 old_cwnd = t->cwnd;
+	u32 max_burst_bytes;
+
+	if (t->burst_limited)
+		return;
+
+	max_burst_bytes = t->flight_size + (asoc->max_burst * asoc->pathmtu);
+	if (max_burst_bytes < old_cwnd) {
+		t->cwnd = max_burst_bytes;
+		t->burst_limited = old_cwnd;
+	}
+}
+
+/* Restore the old cwnd congestion window, after the burst had it's
+ * desired effect.
+ */
+void sctp_transport_burst_reset(struct sctp_transport *t)
+{
+	if (t->burst_limited) {
+		t->cwnd = t->burst_limited;
+		t->burst_limited = 0;
+	}
+}
+
 /* What is the next timeout value for this transport? */
 unsigned long sctp_transport_timeout(struct sctp_transport *t)
 {
@@ -597,6 +634,7 @@ void sctp_transport_reset(struct sctp_transport *t)
 	 * (see Section 6.2.1)
 	 */
 	t->cwnd = min(4*asoc->pathmtu, max_t(__u32, 2*asoc->pathmtu, 4380));
+	t->burst_limited = 0;
 	t->ssthresh = asoc->peer.i.a_rwnd;
 	t->last_rto = t->rto = asoc->rto_initial;
 	t->rtt = 0;

--------------090306000107040407050305--
