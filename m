From: "Doug Graham" <dgraham@nortel.com>
Date: Fri, 31 Jul 2009 12:59:29 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <20090731125929.GD2758@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 31, 2009 at 12:21:15PM +0800, Wei Yongjun wrote:
> Doug Graham wrote:
> > On Thu, Jul 30, 2009 at 07:40:47PM -0400, Doug Graham wrote:
> >   
> >> On Thu, Jul 30, 2009 at 05:24:09PM -0400, Vlad Yasevich wrote:
> >>     
> >>> If you still have BSD setup, can you try increasing you message size
> >>> to say 1442 and see what happens.
> >>>
> >>> I'd expect bundles SACKs at 1440 bytes, but then probably a separate SACK and DATA.
> >>>       
> >> The largest amount of data I can send and still have the BSD server bundle
> >> a SACK with the response is 1436 bytes.  The total ethernet frame size
> >> at that point is 1514 bytes, so this seems correct.  I've attached
> >> wireshark captures with data sizes of 1436 bytes and 1438 bytes.
> >> It's interesting to note that if BSD decides not to bundle a SACK,
> >> it instead sends a separate SACK packet immediately; it does not wait
> >> for the SACK timer to timeout.  It first sends the SACK, then the DATA
> >> immediately follows. I don't think Wei's patch would do this; I think
> >> that if his patch determined that bundling a SACK would cause the packet
> >> to exceed the MTU, then the behaviour will revert to what it was before
> >> my patch is applied: ie the SACK will not be sent for 200ms.
> >>     
> >
> > I think it's about time that I sat down and carefully read the RFC all the
> > way through before trying to do much more analysis of what's happening on
> > the wire, but I did just notice something surprising while try slightly
> > larger packets.  For one, I could've sworn that I saw a ethernet frame
> > of 1516 bytes at one point, but I didn't save the capture and don't
> > know whether it was Linux or BSD that sent the oversized frame, or just
> > my imagination.  But here's one that I did capture when sending and
> > receiving 1454 bytes of data.  1452 bytes is the most data that will fit
> > in a single 1514 byte ethernet frame, so 1454 bytes must be fragmented.
> > The capture is attached, but here's one iteration:
> >
> >  13 2.002632    10.0.0.15   10.0.0.11   DATA (1452 bytes data) 
> >  14 2.203092    10.0.0.11   10.0.0.15   SACK 
> >  15 2.203153    10.0.0.15   10.0.0.11   DATA (2 bytes data)
> >  16 2.203427    10.0.0.11   10.0.0.15   SACK 
> >  17 2.203808    10.0.0.11   10.0.0.15   DATA (1452 bytes data)
> >  18 2.403524    10.0.0.15   10.0.0.11   SACK 
> >  19 2.403686    10.0.0.11   10.0.0.15   DATA (2 bytes data)
> >  20 2.603285    10.0.0.15   10.0.0.11   SACK 
> >
> > What bothers me about this is that Nagle seems to be introducing a delay
> > here.  The first DATA packets in both directions are MTU-sized packets,
> > yet both the Linux client and the BSD server wait 200ms until they get
> > the SACK to the first fragment before sending the second fragment.
> > The server can't send its reply until it gets both fragments, and the
> > client can't reassemble the reply until it gets both fragments, so from
> > the application's point of view, the reply doesn't arrive until 400ms
> > after the request is sent.  This could probably be fixed by disabling
> > Nagle with SCTP_NODELAY, but that shouldn't be required.  Nagle is only
> > supposed to prevent multiple outstanding *small* packets.
> >   
> 
> I think you hit the point which Nagle's algorithm should be not used.
> 
> Can you try the following patch?
> 
> [PATCH] sctp: do not used Nagle algorithm while fragmented data is transmitted
> 
> If fragmented data is sent, the Nagle's algorithm should not be
> used. In special case, if only one large packet is sent, the delay
> send of fragmented data will cause the receiver wait for more
> fragmented data to reassembe them and not send SACK, but the sender
> still wait for SACK before send the last fragment.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/output.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index b94c211..0d8d765 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -718,7 +718,9 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
>  	 * unacknowledged.
>  	 */
>  	if (!sp->nodelay && sctp_packet_empty(packet) &&
> -	    q->outstanding_bytes && sctp_state(asoc, ESTABLISHED)) {
> +	    q->outstanding_bytes && sctp_state(asoc, ESTABLISHED) &&
> +	    (chunk->chunk_hdr->flags & SCTP_DATA_FRAG_MASK) =
> +							SCTP_DATA_NOT_FRAG) {
>  		unsigned len = datasize + q->out_qlen;
>  
>  		/* Check whether this chunk and all the rest of pending
> -- 
> 1.6.2.2

This patch seems to do the job.  I applied it in a UML instance and ran
my server in that.  The client is still unpatched.  I see this:

 13 2.002638    10.0.0.15    10.0.0.249    DATA (1452 bytes data)
 14 2.204041    10.0.0.249   10.0.0.15     SACK 
 15 2.204090    10.0.0.15    10.0.0.249    DATA (2 bytes data)
 16 2.204428    10.0.0.249   10.0.0.15     SACK 
 17 2.204822    10.0.0.249   10.0.0.15     DATA (1452 bytes data)
 18 2.204856    10.0.0.249   10.0.0.15     DATA (2 bytes data)
 19 2.204890    10.0.0.15    10.0.0.249    SACK 

So 10.0.0.249 (the patched UML server) did send back-to-back data
packets without waiting for the SACK,

I have not applied your MTU patch yet, so the server also sent a
separate SACK immediately.  This is less than ideal, since it could have
piggybacked the SACK on the second DATA fragment (frame 18), which has
lots of room.  I think your MTU patch might accomplish that.

--Doug
