From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Mon, 10 Jan 2011 10:58:09 +0000
Subject: [PATCH 1/2] sctp: Remove variables that are only written to
Message-Id: <1294657090-2789-2-git-send-email-holger@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Holger Hans Peter Freyther <zecke@selfish.org>

The following variables only get a simple assignment but
are never read from. Remove these variables.

Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
---
 net/sctp/associola.c     |    2 --
 net/sctp/input.c         |    3 ---
 net/sctp/outqueue.c      |    2 --
 net/sctp/sm_make_chunk.c |    3 ---
 net/sctp/ulpqueue.c      |    6 +-----
 5 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5f1fb8b..6b04287 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1089,7 +1089,6 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			     base.inqueue.immediate);
 	struct sctp_endpoint *ep;
 	struct sctp_chunk *chunk;
-	struct sock *sk;
 	struct sctp_inq *inqueue;
 	int state;
 	sctp_subtype_t subtype;
@@ -1097,7 +1096,6 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 
 	/* The association should be held so we should be safe. */
 	ep = asoc->ep;
-	sk = asoc->base.sk;
 
 	inqueue = &asoc->base.inqueue;
 	sctp_association_hold(asoc);
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 471e048..e052243 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -986,14 +986,11 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct sk_buff *skb,
 	union sctp_addr addr;
 	union sctp_addr *paddr = &addr;
 	struct sctphdr *sh = sctp_hdr(skb);
-	sctp_chunkhdr_t *ch;
 	union sctp_params params;
 	sctp_init_chunk_t *init;
 	struct sctp_transport *transport;
 	struct sctp_af *af;
 
-	ch = (sctp_chunkhdr_t *) skb->data;
-
 	/*
 	 * This code will NOT touch anything inside the chunk--it is
 	 * strictly READ-ONLY.
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 8c6d379..26dc005 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -545,13 +545,11 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 	struct sctp_transport *transport = pkt->transport;
 	sctp_xmit_t status;
 	struct sctp_chunk *chunk, *chunk1;
-	struct sctp_association *asoc;
 	int fast_rtx;
 	int error = 0;
 	int timer = 0;
 	int done = 0;
 
-	asoc = q->asoc;
 	lqueue = &q->retransmit;
 	fast_rtx = q->fast_rtx;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 2cc46f0..9ea8ae7 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3375,7 +3375,6 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
 				    struct sctp_fwdtsn_skip *skiplist)
 {
 	struct sctp_chunk *retval = NULL;
-	struct sctp_fwdtsn_chunk *ftsn_chunk;
 	struct sctp_fwdtsn_hdr ftsn_hdr;
 	struct sctp_fwdtsn_skip skip;
 	size_t hint;
@@ -3388,8 +3387,6 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
 	if (!retval)
 		return NULL;
 
-	ftsn_chunk = (struct sctp_fwdtsn_chunk *)retval->subh.fwdtsn_hdr;
-
 	ftsn_hdr.new_cum_tsn = htonl(new_cum_tsn);
 	retval->subh.fwdtsn_hdr  		sctp_addto_chunk(retval, sizeof(ftsn_hdr), &ftsn_hdr);
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index c7f7e49..c86ee8b 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -105,11 +105,8 @@ int sctp_ulpq_tail_data(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 			gfp_t gfp)
 {
 	struct sk_buff_head temp;
-	sctp_data_chunk_t *hdr;
 	struct sctp_ulpevent *event;
 
-	hdr = (sctp_data_chunk_t *) chunk->chunk_hdr;
-
 	/* Create an event from the incoming chunk. */
 	event = sctp_ulpevent_make_rcvmsg(chunk->asoc, chunk, gfp);
 	if (!event)
@@ -744,10 +741,9 @@ static void sctp_ulpq_retrieve_ordered(struct sctp_ulpq *ulpq,
 	struct sctp_ulpevent *cevent;
 	struct sctp_stream *in;
 	__u16 sid, csid;
-	__u16 ssn, cssn;
+	__u16 cssn;
 
 	sid = event->stream;
-	ssn = event->ssn;
 	in  = &ulpq->asoc->ssnmap->in;
 
 	event_list = (struct sk_buff_head *) sctp_event2skb(event)->prev;
-- 
1.7.3.4

