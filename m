From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 07 Nov 2009 13:38:54 +0000
Subject: Re: [PATCH] sctp: Fix mis-ordering of user space data when
Message-Id: <20091107133854.GA32028@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091030141056.GA5181@hmsreliant.think-freely.org>
In-Reply-To: <20091030141056.GA5181@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Nov 06, 2009 at 10:35:16AM -0500, Vlad Yasevich wrote:
> 
> 
> Neil Horman wrote:
> > On Mon, Nov 02, 2009 at 08:41:06PM -0500, Neil Horman wrote:
> >> On Mon, Nov 02, 2009 at 01:57:42PM -0500, Vlad Yasevich wrote:
> >>>
> >>> Neil Horman wrote:
> >>>> On Mon, Nov 02, 2009 at 12:58:27PM -0500, Vlad Yasevich wrote:
> >>>>> Neil Horman wrote:
> >>>>>>> We could do that yes, but it concerns me, as assigning the tsn in
> >>>>>>>> sctp_outq_flush leaves us in a position where we assign tsn to chunks that might
> >>>>>>>> get dropped prior to submission to the ip layer.  Consider if we have a routing
> >>>>>>>> table disruption, and we  follow the no_route path in sctp_packet_transmit.  In
> >>>>>>>> that situation, we will discard chunks with tsns assigned, leaving a gap in our
> >>>>>>>> stream.  Unless we have a recovery path for that, I think the better option is
> >>>>>>>> to wait to assign tsns until we are sure we can submit them to the ip layer
> >>>>>>>> safely (where the transmitted queue can re-tranmit them if need be).  If you can
> >>>>>>>> explain the SACK case in a little more detail above, perhaps we can come up with
> >>>>>>>> some logic to govern when it is and is not safe to call sctp_packet_transmit
> >>>>>>>> from sctp_packet_transmit_chunk for data chunks.
> >>>>>>> Assume that we have a number of queued chunks that add up to multiple MTUs
> >>>>>>> all going to the same transport (typical case).  They are currently gated by
> >>>>>>> congestion window.
> >>>>>>>
> >>>>>>> A SACK arrives triggering a flush.  With the proposed patch, once we fill a
> >>>>>>> single MTU, the main loop in sctp_outq_flush will exist and we will transmit
> >>>>>>> only a single packet and under-utilize our congesting window thus preventing
> >>>>>>> future growth.  With the old code, we had multiple packets sent out thus
> >>>>>>> filling the congestion window.
> >>>>>>>
> >>>>>>> Another thing your patch didn't take into account is that every time we change
> >>>>>>> the transport in sctp_outq_flush, we reset the packet, effectively marking it
> >>>>>>> empty.  You would end up leaking chunks if there was any queuing effects.
> >>>>>>>
> >>>>>>> If a transient routing problem happens and the packet fails to get sent, that's
> >>>>>>> no different then a loss event in the network.  It will get reported back as
> >>>>>>> gaps or, if the failure is long term, it will be detected with HBs and
> >>>>>>> retransmissions.  So I don't see a problem of assigning TSNs when the DATA is
> >>>>>>> added to the packet.  We don't really want to do it any earlier though.
> >>>>>>>
> >>>>>> Yeah, ok, heres a new version, instead of just skipping the packet transmit in
> >>>>>> transmit_chunk, we instead simply assign a tsn in sctp_outq_flush, after we
> >>>>>> dequeue a data chunk from the outq and do the normal expiration and invalid
> >>>>>> stream checking.
> >>>>>>
> >>>>>> Regards
> >>>>>> Neil
> >>>>>>
> >>>>> Hi Neil
> >>>>>
> >>>>> I don't think we can do that in sctp_outq_flush().
> >>>>>
> >>>> Why can't we do it in sctp_outq_flush?
> >>> Ok, looking at the 'resent' code you left in packet_transmit, this will work,
> >>> but we now end up assigning sequence numbers to DATA that may not be transmitted
> >>> this time around.
> >>>
> >>> It will also make FWD-TSNs a bit weird.  Worth a test.  My personal preference
> >>> would be to do it when the chunk is added to the packet.
> >>>
> >> Ok, very well.  I've moved the assignment to the point right after we actually
> >> enqueue the chunk to the offered packet.
> >>
> > 
> > 
> > Ping, sorry vlad, not sure where we've left off with this.  I've given this some
> > testing here, and it works for me.  Were there more concerns you had with this
> > variant of the patch?
> > 
> 
> Just running some tests here.  It also looks like this was based on the pre .31
> code.
> 
> In the .31 code, you can put this in sctp_packet_append_data() and save
> us yet another branch based on chunk_is_data().
> 

copy that, here it is, applied to the latest net-next tree, with the assignment
moved to avoid the extra branch

Thanks & Regards
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

The fix is to change where we assign a tsn.  By doing this earlier,
we are then free to place chunks in packets, whatever way we
see fit and the protocol will make sure to do all the appropriate re-ordering on
receive as is needed.


 output.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: William Reich <reich@ulticom.com>

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 5cbda8f..17efda2 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -429,23 +429,22 @@ int sctp_packet_transmit(struct sctp_packet *packet)
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
+			if (!chunk->resent) {
+
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
 
 			has_data = 1;
 		}
@@ -747,6 +746,8 @@ static void sctp_packet_append_data(struct sctp_packet *packet,
 	/* Has been accepted for transmission. */
 	if (!asoc->peer.prsctp_capable)
 		chunk->msg->can_abandon = 0;
+	sctp_chunk_assign_tsn(chunk);
+	sctp_chunk_assign_ssn(chunk);
 }
 
 static sctp_xmit_t sctp_packet_will_fit(struct sctp_packet *packet,
