From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 15 Dec 2008 17:42:01 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <494696E9.7040200@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------030303070308040503050601"
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------030303070308040503050601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Oh, forgot the actuall patch. ;)

-vlad

--------------030303070308040503050601
Content-Type: text/x-patch;
 name="testing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="testing.patch"

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9661d7b..4ba2210 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -790,6 +790,7 @@ struct sctp_packet {
 	__u32 vtag;
 
 	/* This contains the payload chunks.  */
+	spinlock_t	lock;
 	struct list_head chunk_list;
 
 	/* This is the overhead of the sctp and ip headers. */
@@ -797,6 +798,7 @@ struct sctp_packet {
 	/* This is the total size of all chunks INCLUDING padding.  */
 	size_t size;
 
+	size_t num_chunks;
 	/* The packet is destined for this transport address.
 	 * The function we finally use to pass down to the next lower
 	 * layer lives in the transport structure.
diff --git a/net/sctp/output.c b/net/sctp/output.c
index c3f417f..529281f 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -79,12 +79,6 @@ struct sctp_packet *sctp_packet_config(struct sctp_packet *packet,
 			  packet, vtag);
 
 	packet->vtag = vtag;
-	packet->has_cookie_echo = 0;
-	packet->has_sack = 0;
-	packet->has_auth = 0;
-	packet->has_data = 0;
-	packet->ipfragok = 0;
-	packet->auth = NULL;
 
 	if (ecn_capable && sctp_packet_empty(packet)) {
 		chunk = sctp_get_ecne_prepend(packet->transport->asoc);
@@ -113,7 +107,9 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
 	packet->transport = transport;
 	packet->source_port = sport;
 	packet->destination_port = dport;
+	spin_lock_init(&packet->lock);
 	INIT_LIST_HEAD(&packet->chunk_list);
+	packet->num_chunks = 0;
 	if (asoc) {
 		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
 		overhead = sp->pf->af->net_header_len;
@@ -134,6 +130,43 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
 	return packet;
 }
 
+static void sctp_packet_reset(struct sctp_packet *packet)
+{
+	struct sctp_chunk *chunk, *tmp;
+
+	SCTP_DEBUG_PRINTK("%s: packet:%p vtag:0x%x\n", __func__,
+			  packet, vtag);
+
+	packet->has_cookie_echo = 0;
+	packet->has_sack = 0;
+	packet->has_auth = 0;
+	packet->has_data = 0;
+	packet->ipfragok = 0;
+	packet->auth = NULL;
+	packet->size = packet->overhead;
+/*
+	spin_lock_bh(&packet->lock);
+*/
+	list_for_each_entry_safe(chunk, tmp, &packet->chunk_list, list) {
+		list_del_init(&chunk->list);
+		packet->num_chunks--;
+		if (!sctp_chunk_is_data(chunk))
+			sctp_chunk_free(chunk);
+	}
+/*
+	if (packet->num_chunks ||
+	    !list_empty(&packet->chunk_list) {
+		printk(KERN_CRIT "packet %p, (%p,%p), num %d\n",
+			packet, packet->chunk_list.next,
+			packet->chunk_list.prev,
+			packet->num_chunks);
+		BUG();
+	}
+	spin_unlock_bh(&packet->lock);
+*/
+}
+
+
 /* Free a packet.  */
 void sctp_packet_free(struct sctp_packet *packet)
 {
@@ -141,6 +174,8 @@ void sctp_packet_free(struct sctp_packet *packet)
 
 	SCTP_DEBUG_PRINTK("%s: packet:%p\n", __func__, packet);
 
+	BUG_ON(spin_is_locked(&packet->lock));
+
 	list_for_each_entry_safe(chunk, tmp, &packet->chunk_list, list) {
 		list_del_init(&chunk->list);
 		sctp_chunk_free(chunk);
@@ -324,14 +359,15 @@ append:
 	switch (chunk->chunk_hdr->type) {
 	    case SCTP_CID_DATA:
 		retval = sctp_packet_append_data(packet, chunk);
+		if (SCTP_XMIT_OK != retval)
+			goto finish;
 		/* Disallow SACK bundling after DATA. */
 		packet->has_sack = 1;
 		/* Disallow AUTH bundling after DATA */
 		packet->has_auth = 1;
 		/* Let it be knows that packet has DATA in it */
 		packet->has_data = 1;
-		if (SCTP_XMIT_OK != retval)
-			goto finish;
+		chunk->sent_at = jiffies;
 		break;
 	    case SCTP_CID_COOKIE_ECHO:
 		packet->has_cookie_echo = 1;
@@ -348,7 +384,10 @@ append:
 	}
 
 	/* It is OK to send this chunk.  */
+	//spin_lock_bh(&packet->lock);
+	packet->num_chunks++;
 	list_add_tail(&chunk->list, &packet->chunk_list);
+	//spin_unlock_bh(&packet->lock);
 	packet->size += chunk_len;
 	chunk->transport = packet->transport;
 finish:
@@ -367,7 +406,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	struct sctphdr *sh;
 	__be32 crc32 = __constant_cpu_to_be32(0);
 	struct sk_buff *nskb;
-	struct sctp_chunk *chunk, *tmp;
+	struct sctp_chunk *chunk;
 	struct sock *sk;
 	int err = 0;
 	int padding;		/* How much padding do we need?  */
@@ -382,6 +421,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	if (list_empty(&packet->chunk_list))
 		return err;
 
+	BUG_ON(packet->num_chunks == 0);
+
 	/* Set up convenience variables... */
 	chunk = list_entry(packet->chunk_list.next, struct sctp_chunk, list);
 	sk = chunk->skb->sk;
@@ -448,8 +489,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * [This whole comment explains WORD_ROUND() below.]
 	 */
 	SCTP_DEBUG_PRINTK("***sctp_transmit_packet***\n");
-	list_for_each_entry_safe(chunk, tmp, &packet->chunk_list, list) {
-		list_del_init(&chunk->list);
+	list_for_each_entry(chunk, &packet->chunk_list, list) {
 		if (sctp_chunk_is_data(chunk)) {
 
 			if (!chunk->has_tsn) {
@@ -470,7 +510,6 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 			} else
 				chunk->resent = 1;
 
-			chunk->sent_at = jiffies;
 			has_data = 1;
 		}
 
@@ -485,6 +524,35 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 		if (chunk == packet->auth)
 			auth = skb_tail_pointer(nskb);
 
+		/* DEBUG: Check to see if this chunk will overflow the
+		 * skb.  Output needed info
+		 */
+		if ((nskb->tail + chunk->skb->len) > nskb->end) {
+			int i = 1;
+			struct sctp_chunk *tmp;
+			int num = packet->num_chunks;
+
+			printk("SKB %p overflow: p_size = %lu, n_chunks = %u, list(%p, %p)\n",
+			nskb,
+			packet->size, num,
+			packet->chunk_list.next, packet->chunk_list.prev);
+
+			list_for_each_entry(tmp, &packet->chunk_list, list) {
+			    if (i > num) {
+			    	printk(KERN_CRIT
+				"*** Overflow Chunk [%d] %p[%d], nxt %p, prv %p, skb_len %d\n",
+				i, tmp, tmp->chunk_hdr->type,
+				tmp->list.next, tmp->list.prev,
+				tmp->skb->len);
+			    } else {
+					printk("Chunk %p[%d], skb_length %d\n",
+						tmp,
+						tmp->chunk_hdr->type,
+						tmp->skb->len);
+			    }
+			    i++;
+			}
+		}
 		cksum_buf_len += chunk->skb->len;
 		memcpy(skb_put(nskb, chunk->skb->len),
 			       chunk->skb->data, chunk->skb->len);
@@ -500,13 +568,6 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 				  "chunk->skb->len", chunk->skb->len,
 				  "rtt_in_progress", chunk->rtt_in_progress);
 
-		/*
-		 * If this is a control chunk, this is our last
-		 * reference. Free data chunks after they've been
-		 * acknowledged or have failed.
-		 */
-		if (!sctp_chunk_is_data(chunk))
-			sctp_chunk_free(chunk);
 	}
 
 	/* SCTP-AUTH, Section 6.2
@@ -591,8 +652,9 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	(*tp->af_specific->sctp_xmit)(nskb, tp);
 
 out:
-	packet->size = packet->overhead;
+	sctp_packet_reset(packet);
 	return err;
+
 no_route:
 	kfree_skb(nskb);
 	IP_INC_STATS_BH(&init_net, IPSTATS_MIB_OUTNOROUTES);
@@ -604,21 +666,10 @@ no_route:
 	 * to the user via notifications. So setting this error may not be
 	 * required.
 	 */
-	 /* err = -EHOSTUNREACH; */
-err:
-	/* Control chunks are unreliable so just drop them.  DATA chunks
-	 * will get resent or dropped later.
-	 */
-
-	list_for_each_entry_safe(chunk, tmp, &packet->chunk_list, list) {
-		list_del_init(&chunk->list);
-		if (!sctp_chunk_is_data(chunk))
-			sctp_chunk_free(chunk);
-	}
 	goto out;
 nomem:
 	err = -ENOMEM;
-	goto err;
+	goto out;
 }
 
 /********************************************************************
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 247ebc9..5d81bb6 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -560,6 +560,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 	asoc = q->asoc;
 	lqueue = &q->retransmit;
 	fast_rtx = q->fast_rtx;
+	q->fast_rtx = 0;
 
 	/* This loop handles time-out retransmissions, fast retransmissions,
 	 * and retransmissions due to opening of whindow.
@@ -592,8 +593,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		 * next chunk.
 		 */
 		if (chunk->tsn_gap_acked) {
-			list_del(&chunk->transmitted_list);
-			list_add_tail(&chunk->transmitted_list,
+			list_move_tail(&chunk->transmitted_list,
 					&transport->transmitted);
 			continue;
 		}
@@ -604,6 +604,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		if (fast_rtx && !chunk->fast_retransmit)
 			continue;
 
+again:
 		/* Attempt to append this chunk to the packet. */
 		status = sctp_packet_append_chunk(pkt, chunk);
 
@@ -617,20 +618,13 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			 */
 			if (rtx_timeout || fast_rtx)
 				done = 1;
+			else
+				goto again;
 
 			/* Bundle next chunk in the next round.  */
 			break;
 
 		case SCTP_XMIT_RWND_FULL:
-			/* Send this packet. */
-			error = sctp_packet_transmit(pkt);
-
-			/* Stop sending DATA as there is no more room
-			 * at the receiver.
-			 */
-			done = 1;
-			break;
-
 		case SCTP_XMIT_NAGLE_DELAY:
 			/* Send this packet. */
 			error = sctp_packet_transmit(pkt);
@@ -643,8 +637,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			/* The append was successful, so add this chunk to
 			 * the transmitted list.
 			 */
-			list_del(&chunk->transmitted_list);
-			list_add_tail(&chunk->transmitted_list,
+			list_move_tail(&chunk->transmitted_list,
 					&transport->transmitted);
 
 			/* Mark the chunk as ineligible for fast retransmit
@@ -687,10 +680,6 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 
 	*start_timer = timer;
 
-	/* Clear fast retransmit hint */
-	if (fast_rtx)
-		q->fast_rtx = 0;
-
 	return error;
 }
 
@@ -1028,7 +1017,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			list_add_tail(&chunk->transmitted_list,
 				      &transport->transmitted);
 
-			sctp_transport_reset_timers(transport, start_timer-1);
+			sctp_transport_reset_timers(transport, 0);
 
 			q->empty = 0;
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a6a0ea7..442752f 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2650,7 +2650,7 @@ sctp_disposition_t sctp_sf_do_9_2_shut_ctsn(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_CTSN,
 			SCTP_BE32(sdh->cum_tsn_ack));
 
-	return SCTP_DISPOSITION_CONSUME;
+	return sctp_sf_do_9_2_shutdown_ack(ep, asoc, type, arg, commands);
 }
 
 /* RFC 2960 9.2

--------------030303070308040503050601--
