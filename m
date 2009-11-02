From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 02 Nov 2009 18:38:34 +0000
Subject: Re: [PATCH] sctp: Fix mis-ordering of user space data when
Message-Id: <20091102183834.GF4075@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091030141056.GA5181@hmsreliant.think-freely.org>
In-Reply-To: <20091030141056.GA5181@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Nov 02, 2009 at 12:58:27PM -0500, Vlad Yasevich wrote:
> 
> 
> Neil Horman wrote:
> >> We could do that yes, but it concerns me, as assigning the tsn in
> >>> sctp_outq_flush leaves us in a position where we assign tsn to chunks that might
> >>> get dropped prior to submission to the ip layer.  Consider if we have a routing
> >>> table disruption, and we  follow the no_route path in sctp_packet_transmit.  In
> >>> that situation, we will discard chunks with tsns assigned, leaving a gap in our
> >>> stream.  Unless we have a recovery path for that, I think the better option is
> >>> to wait to assign tsns until we are sure we can submit them to the ip layer
> >>> safely (where the transmitted queue can re-tranmit them if need be).  If you can
> >>> explain the SACK case in a little more detail above, perhaps we can come up with
> >>> some logic to govern when it is and is not safe to call sctp_packet_transmit
> >>> from sctp_packet_transmit_chunk for data chunks.
> >> Assume that we have a number of queued chunks that add up to multiple MTUs
> >> all going to the same transport (typical case).  They are currently gated by
> >> congestion window.
> >>
> >> A SACK arrives triggering a flush.  With the proposed patch, once we fill a
> >> single MTU, the main loop in sctp_outq_flush will exist and we will transmit
> >> only a single packet and under-utilize our congesting window thus preventing
> >> future growth.  With the old code, we had multiple packets sent out thus
> >> filling the congestion window.
> >>
> >> Another thing your patch didn't take into account is that every time we change
> >> the transport in sctp_outq_flush, we reset the packet, effectively marking it
> >> empty.  You would end up leaking chunks if there was any queuing effects.
> >>
> >> If a transient routing problem happens and the packet fails to get sent, that's
> >> no different then a loss event in the network.  It will get reported back as
> >> gaps or, if the failure is long term, it will be detected with HBs and
> >> retransmissions.  So I don't see a problem of assigning TSNs when the DATA is
> >> added to the packet.  We don't really want to do it any earlier though.
> >>
> > 
> > Yeah, ok, heres a new version, instead of just skipping the packet transmit in
> > transmit_chunk, we instead simply assign a tsn in sctp_outq_flush, after we
> > dequeue a data chunk from the outq and do the normal expiration and invalid
> > stream checking.
> > 
> > Regards
> > Neil
> > 
> 
> Hi Neil
> 
> I don't think we can do that in sctp_outq_flush().
> 
Why can't we do it in sctp_outq_flush?
Neil

