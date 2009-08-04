From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 04 Aug 2009 17:05:01 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <20090804170501.GB4941@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Aug 04, 2009 at 10:50:18AM -0400, Vlad Yasevich wrote:
> > I admit that I didn't study too closely exactly what
> > q->outstanding_bytes represents.  I assumed
> > it meant the number of bytes that had been sent on the wire, but not yet
> > acknowledged.
> > Any bytes that were delayed because of Nagle would not be counted in
> > outstanding_bytes
> > (I assume).  So the first send of 726 would get sent immediately and
> > counted in
> > outstanding_bytes.  The second one would get delayed by Nagle and not
> > counted
> > in outstanding_bytes.  All the later ones would also get delayed by
> > Nagle because
> > outstanding_bytes is still 726.
> > 
> > I do think that using outstanding_bytes the way I did is probably an
> > ugly kludge, and
> > there's hopefully a better way.  But the right way will probably involve
> > adding
> > some more state to each association (the snd.sml variable mentioned in
> > the minshall
> > draft at the very least).  I'm not sure that using asoc->frag_point the
> > way I did is correct
> > either, because I think the frag_point can change during the lifetime of
> > an association.
> 
> Using division in such a hot path is a non-starter to begin with, so we
> definitely need to find a better way.

That thought crossed by mind too, although I didn't consider it as much
of a show-stopper as you do.  32 bit integer division isn't really all
that expensive on modern processors is it?  The C compiler is probably
doing it in places as a result of pointer arithmetic anyway.

> Using frag_point is not the right way to do it either since it's effected by
> MTU and user API.
> 
> I think we can add something to sctp_outq structure to properly track this.

I've pretty much convinced myself that Wei's original Nagle patch is fine
anyway.  Just disable Nagle for large messages that need to be fragmented.

--Doug.
