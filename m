From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 02 Nov 2009 17:38:22 +0000
Subject: Re: [PATCH] sctp: Fix mis-ordering of user space data when
Message-Id: <20091102173822.GC4075@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091030141056.GA5181@hmsreliant.think-freely.org>
In-Reply-To: <20091030141056.GA5181@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Nov 02, 2009 at 11:15:54AM -0500, Vlad Yasevich wrote:
> 
> 
> Neil Horman wrote:
> > On Mon, Nov 02, 2009 at 09:49:50AM -0500, Vlad Yasevich wrote:
> >> Hi Neil
> >>
> >> Neil Horman wrote:
> >>> Fix use of sctp_packet_transmit so as to prevent packet re-ordering
> >>>
> >>> Recently had a bug reported to me, in which the user was sending packets with a
> >>> payload containing a sequence number.  The packets were getting delivered in
> >>> order according the chunk TSN values, but the sequence values in the payload
> >>> were arriving out of order.  At first I thought it must be an application error,
> >>> but we eventually found it to be a problem on the transmit side in the sctp
> >>> stack.
> >>>
> >>> The conditions for the error are that multihoming must be in use, and it helps
> >>> if each transport has a different pmtu.  The problem occurs in sctp_outq_flush.
> >>> Basically we dequeue packets from the data queue, and attempt to append them to
> >>> the orrered packet for a given transport.  After we append a data chunk we add
> >>> the trasport to the end of a list of transports to have their packets sent at
> >>> the end of sctp_outq_flush.  The problem occurs when a data chunks fills up a
> >>> offered packet on a transport.  The function that does the appending
> >>> (sctp_packet_transmit_chunk), will try to call sctp_packet_transmit on the full
> >>> packet, and then append the chunk to a new packet.  This call to
> >>> sctp_packet_transmit, sends that packet ahead of the others that may be queued
> >>> in the transport_list in sctp_outq_flush.  The result is that frames that were
> >>> sent in one order from the user space sending application get re-ordered prior
> >>> to tsn assignment in sctp_packet_transmit, resulting in mis-sequencing of data
> >>> payloads, even though tsn ordering is correct.
> >>>
> >>> The fix is to add a parameter to sctp_packet_transmit_chunk, to inform that
> >>> function if it should send the packet immediately or not.  It makes sense to do
> >>> so for control chunks, which are handled prior to data chunks, but for data
> >>> chunks we want to do what sctp_outq_flush already does, which is to replace the
> >>> overflowing data chunk on the outq, and then flush all the queued transports.
> >>>
> >> Wouldn't that mean that if we fill a path mtu, we will only generate a single
> >> DATA packet?
> >>
> > Not necessecarily.  An offered packet might have previously appended data chunks
> > in it, before we went to sctp_outq_flush.  but I don't think thats relevant to
> > the problem.
> > 
> >> The code seems to confirm that.  If we get a return of SCTP_XMIT_PMTU_FULL,
> >> we stop walking the queue jump to 'sctp_flush_out'.  If we are here in response
> > But not before we transmit the full packet.  Thats the problem.  When we call
> > sctp_packet_transmit_chunk, if we get a PMTU_FULL reponse from the append
> > operation, we send it before ahead of anything else we might have queued up on
> > other transports.
> > 
> >> to a SACK and congestion window is open, we'll never end up filling it.
> >>
> > Why not?  Not sure I'm following
> > 
> >> Is there something special that the application is doing to trigger this?
> >>
> > Yes, as william pointed out, the application in question was secifying
> > SNDRCVINFO for each packet to toggle the outgoing transport periodically.
> > 
> >> In any case, I think a better solution would be to change where TSN happens.
> >> Right now, we assign TSNs in sctp_packet_transmit.  Thus it's theoretically
> >> possible, with the current code, to re-order the data.
> >> If we assign TSNs at the time the DATA is assigned to a packet, then the order
> >> problem would be solved.
> >>
> > We could do that yes, but it concerns me, as assigning the tsn in
> > sctp_outq_flush leaves us in a position where we assign tsn to chunks that might
> > get dropped prior to submission to the ip layer.  Consider if we have a routing
> > table disruption, and we  follow the no_route path in sctp_packet_transmit.  In
> > that situation, we will discard chunks with tsns assigned, leaving a gap in our
> > stream.  Unless we have a recovery path for that, I think the better option is
> > to wait to assign tsns until we are sure we can submit them to the ip layer
> > safely (where the transmitted queue can re-tranmit them if need be).  If you can
> > explain the SACK case in a little more detail above, perhaps we can come up with
> > some logic to govern when it is and is not safe to call sctp_packet_transmit
> > from sctp_packet_transmit_chunk for data chunks.
> 
> Assume that we have a number of queued chunks that add up to multiple MTUs
> all going to the same transport (typical case).  They are currently gated by
> congestion window.
> 
> A SACK arrives triggering a flush.  With the proposed patch, once we fill a
> single MTU, the main loop in sctp_outq_flush will exist and we will transmit
> only a single packet and under-utilize our congesting window thus preventing
> future growth.  With the old code, we had multiple packets sent out thus
> filling the congestion window.
> 
> Another thing your patch didn't take into account is that every time we change
> the transport in sctp_outq_flush, we reset the packet, effectively marking it
> empty.  You would end up leaking chunks if there was any queuing effects.
> 
> If a transient routing problem happens and the packet fails to get sent, that's
> no different then a loss event in the network.  It will get reported back as
> gaps or, if the failure is long term, it will be detected with HBs and
> retransmissions.  So I don't see a problem of assigning TSNs when the DATA is
> added to the packet.  We don't really want to do it any earlier though.
> 

Yeah, ok, heres a new version, instead of just skipping the packet transmit in
transmit_chunk, we instead simply assign a tsn in sctp_outq_flush, after we
dequeue a data chunk from the outq and do the normal expiration and invalid
stream checking.

Regards
Neil



Fix use of sctp_packet_transmit so as to prevent packet re-ordering

Recently had a bug reported to me, in which the user was sending packets with a
payload containing a sequence number.  The packets were getting delivered in
order according the chunk TSN values, but the sequence values in the payload
were arriving out of order.  At first I thought it must be an application error,
but we eventually found it to be a problem on the transmit side in the sctp
stack.

The conditions for the error are that multihoming must be in use, and it helps
if each transport has a different pmtu.  The problem occurs in sctp_outq_flush.
Basically we dequeue packets from the data queue, and attempt to append them to
the orrered packet for a given transport.  After we append a data chunk we add
the trasport to the end of a list of transports to have their packets sent at
the end of sctp_outq_flush.  The problem occurs when a data chunks fills up a
offered packet on a transport.  The function that does the appending
(sctp_packet_transmit_chunk), will try to call sctp_packet_transmit on the full
packet, and then append the chunk to a new packet.  This call to
sctp_packet_transmit, sends that packet ahead of the others that may be queued
in the transport_list in sctp_outq_flush.  The result is that frames that were
sent in one order from the user space sending application get re-ordered prior
to tsn assignment in sctp_packet_transmit, resulting in mis-sequencing of data
payloads, even though tsn ordering is correct.

The fix is to change where we assign a tsn.  By doing this earlier, in
sctp_outq_flush, we are then free to place chunks in packets, whatever way we
see fit and the protocol will make sure to do all the appropriate re-ordering on
receive as is needed.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: William Reich <reich@ulticom.com>

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 7363935..03e80a8 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -454,23 +454,21 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 		list_del_init(&chunk->list);
 		if (sctp_chunk_is_data(chunk)) {
 
-			if (!chunk->has_tsn) {
-				sctp_chunk_assign_ssn(chunk);
-				sctp_chunk_assign_tsn(chunk);
-
-			/* 6.3.1 C4) When data is in flight and when allowed
-			 * by rule C5, a new RTT measurement MUST be made each
-			 * round trip.  Furthermore, new RTT measurements
-			 * SHOULD be made no more than once per round-trip
-			 * for a given destination transport address.
-			 */
-
+			if (!chunk->resent) {
+				/* 6.3.1 C4) When data is in flight and when allowed
+				 * by rule C5, a new RTT measurement MUST be made each
+				 * round trip.  Furthermore, new RTT measurements
+				 * SHOULD be made no more than once per round-trip
+				 * for a given destination transport address.
+				 */
 				if (!tp->rto_pending) {
 					chunk->rtt_in_progress = 1;
 					tp->rto_pending = 1;
 				}
-			} else
-				chunk->resent = 1;
+			} 
+
+			chunk->resent = 1;
+
 
 			has_data = 1;
 		}
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index bc411c8..58b9d91 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -949,6 +949,9 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				continue;
 			}
 
+			sctp_chunk_assign_tsn(chunk);
+			sctp_chunk_assign_ssn(chunk);
+
 			/* If there is a specified transport, use it.
 			 * Otherwise, we want to use the active path.
 			 */
