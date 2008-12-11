From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 11 Dec 2008 09:27:52 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081211092752.GA5236@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue 09-12-08 16:38:34, Michal Hocko wrote:
> [CCing David Sterba]
> 
> On Mon 08-12-08 13:53:11, Vlad Yasevich wrote:
> [...]
> > Michal
> > 
> > Can you try this patch.  This applies on top of a clean tree.  I've started a
> > run with it here as well.
> 
> I am still testing with your previous patch (sent in private email -
> attached) and the kernel survived overnight. I will give it another day
> and then try it without patch. Unfortunatelly it can be HW related so I
> don't want to make any fast statements.

Testing with the patch didn't crash my machine, but unfortunately
neither without patch did! 
Maybe It is important that I have changed my HW configuration because I
don't have access to the one of computers used in my previous tests
(where I was able to reproduce). Code base is very same though
(4e14e833ac3b97a4aa8803eea49f899adc5bb5f4 kernel with your debug patch
on top of it).

> 
> I can try the following patch afterwards.

I will try this one later because I have to find out whether I am able
to reproduce with my current HW configuration and sles10sp2 kernel.

Are you able to reproduce this issue? Does the patch you have sent
helped you?

> 
> > 
> > Thanks
> > -vlad
> 
> > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > index 247ebc9..0fdf544 100644
> > --- a/net/sctp/outqueue.c
> > +++ b/net/sctp/outqueue.c
> > @@ -604,6 +604,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
> >  		if (fast_rtx && !chunk->fast_retransmit)
> >  			continue;
> >  
> > +again:
> >  		/* Attempt to append this chunk to the packet. */
> >  		status = sctp_packet_append_chunk(pkt, chunk);
> >  
> > @@ -617,20 +618,14 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
> >  			 */
> >  			if (rtx_timeout || fast_rtx)
> >  				done = 1;
> > +			else {
> > +				/* Bundle this chunk in the next round.  */
> > +				goto again;
> > +			}
> >  
> > -			/* Bundle next chunk in the next round.  */
> >  			break;
> >  
> >  		case SCTP_XMIT_RWND_FULL:
> > -			/* Send this packet. */
> > -			error = sctp_packet_transmit(pkt);
> > -
> > -			/* Stop sending DATA as there is no more room
> > -			 * at the receiver.
> > -			 */
> > -			done = 1;
> > -			break;
> > -
> >  		case SCTP_XMIT_NAGLE_DELAY:
> >  			/* Send this packet. */
> >  			error = sctp_packet_transmit(pkt);
> > @@ -929,7 +924,6 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
> >  		}
> >  
> >  		/* Finally, transmit new packets.  */
> > -		start_timer = 0;
> >  		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
> >  			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
> >  			 * stream identifier.
> > @@ -1028,7 +1022,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
> >  			list_add_tail(&chunk->transmitted_list,
> >  				      &transport->transmitted);
> >  
> > -			sctp_transport_reset_timers(transport, start_timer-1);
> > +			sctp_transport_reset_timers(transport, 0);
> >  
> >  			q->empty = 0;
> >  
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
