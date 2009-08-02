From: "Doug Graham" <dgraham@nortel.com>
Date: Sun, 02 Aug 2009 03:03:29 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet size exceed current MTU
Message-Id: <20090802030329.GB24148@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 31, 2009 at 01:04:44PM -0400, Vlad Yasevich wrote:
> Wei Yongjun wrote:
> > Vlad Yasevich wrote:
> >> I like this much better, but the one thing I don't like is that we end
> >> up delaying the SACK if it doesn't fit in the chunk.
> >>   
> > 
> > Why we need to send the SACK immediate? Just to make the one send one
> > recv mode happy?
> > In this case, it is better to disable the delay ack, is this correct?
> 
> Consistent behavior.  A change in message size shouldn't cause a change in
> on the wire behavior.
> 
> Either we always send a SACK if we have DATA to send, or we don't.  Having a
> weird "only if it fits" behavior will have unpredictable results.

My attempt at solving this is below.  Messages whose last or only
fragment are just less than or equal to the PMTU (meaning that no SACK
can be bundled in any fragment of the message) have a bare SACK sent just
before the last fragment of the message.  For all other message sizes,
normal piggybacking takes care of sending a bundled SACK.  I've tested
this by ping-ponging messages of different sizes between two applications
as fast as possible, and have not come across any sizes where performance
drops precipitously.

> > 
> >> May be we can add some checking to see if there are more chunks that we'll
> >> be sending and try to bundle it later.
> >>
> >> Another question is whether we should really be sending an immediate SACK
> >> back after receiving just one DATA?
> >>
> >> I still think that this should really be handled by SACK immediately extension.
> >> The extension can apply when we are single sub-MTU packets, essentially a
> >> request-response scenario.  There is no reason that Immediate SACKs can't be
> >> bundled in this manner.

The main problems I can think of with depending on this extension are:

 1) If it's left up to the user to decide when to use SCTP_SACK_IMMEDIATELY flag,
    rather than taking care to use it only under the conditions when it would
    actually help, they'd be likely to just use it all the time, thus defeating
    the purpose of delayed SACKs altogether.  I suspect that this is what is
    happening now with SCTP_NODELAY.

 2) Probably the only way a user could determine when SCTP_SACK_IMMEDIATELY
    would be useful would be to first get a PhD in networking and SCTP,
    then spend some time sniffing their application's on-the-wire
    behaviour.    

 3) Even if users are careful about when to use SCTP_SACK_IMMEDIATELY, there will
    still be cases where the SACK could have been piggybacked on returning DATA,
    but wasn't because this flag requested an immediate SACK.  This
    applies even if the entity deciding whether or not to set the I bit
    is the sending SCTP (as opposed to a user).

I think it is better if the receiving SCTP is able to determine without
any hints from the sender when to piggyback, when to send a bare immediate
SACK, and when to delay the SACK.  This may not always be possible,
so there may be cases where there is no other way to do what the I bit
does, but I don't think it's a good idea to use it to solve problems
that can be solved in other ways.  All the same issues with Nagle and
delayed-ACKs and whatever else exist in TCP as well, but to my knowledge,
nobody has ever seen the need to implement an extension like this for TCP.


Here's my patch to make sure a SACK gets sent back with a message when
the last or only fragment of the message is just less than the PMTU.

Signed-off-by: Doug Graham <dgraham@nortel.com>

---

--- linux-2.6.29/net/sctp/output.c	2009/08/02 00:51:45	1.4
+++ linux-2.6.29/net/sctp/output.c	2009/08/02 01:21:37
@@ -249,14 +249,36 @@ static sctp_xmit_t sctp_packet_bundle_sa
 		struct sctp_association *asoc;
 		struct timer_list *timer;
 		__u16 chunk_len;
+		__u8 frag_bits, last_frag;
 
 		asoc = pkt->transport->asoc;
 		timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
 		chunk_len = WORD_ROUND(ntohs(chunk->chunk_hdr->length)) +
 			    sizeof(struct sctp_sack_chunk);
+		frag_bits = chunk->chunk_hdr->flags & SCTP_DATA_FRAG_MASK;
+		last_frag = (frag_bits = SCTP_DATA_NOT_FRAG ||
+			     frag_bits = SCTP_DATA_LAST_FRAG);
 
-		/* If the SACK timer is running, we have a pending SACK */
-		if (timer_pending(timer) && can_append_chunk(pkt, chunk_len)) {
+		/*
+		 * If the SACK timer is running, we have a pending SACK
+		 *
+		 * If we have room, bundle it with the current DATA chunk.
+		 * If we do not have room but this is either the only
+		 * fragment of a message or the last fragment of a message,
+		 * append the SACK chunk anyway.  It'll be sent in a separate
+		 * packet just before the DATA chunk.  The reason for sending
+		 * the SACK immediately is to avoid odd anomalies in behaviour
+		 * when sending messages of a size just less than or equal
+		 * to a multiple of the PMTU.  Small messages get a SACK
+		 * bundled with them, since there is room.  Messages greater
+		 * than the PMTU also get a SACK bundled into the last DATA
+		 * chunk if there is room.  Messages whose last or only chunks
+		 * are just less than the PMTU can not bundle a SACK with
+		 * a DATA chunk, so we send one in a separate packet just
+		 * before the last DATA chunk in the message.
+		 */
+		if (timer_pending(timer) &&
+		    (can_append_chunk(pkt, chunk_len) || last_frag)) {
 			struct sctp_chunk *sack;
 			asoc->a_rwnd = asoc->rwnd;
 			sack = sctp_make_sack(asoc);


--Doug
