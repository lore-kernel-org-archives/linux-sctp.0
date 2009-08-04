From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 04 Aug 2009 17:33:43 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet size exceed current MTU
Message-Id: <20090804173343.GC4941@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Aug 04, 2009 at 01:08:05PM -0400, Vlad Yasevich wrote:
> Doug Graham wrote:
> > On Tue, Aug 04, 2009 at 10:16:32AM -0400, Vlad Yasevich wrote:
> >>>> The main point being that if a SACK won't fit in the last chunk of a
> >>>> message, then your scheme
> >>>> would just push all the data down so that a new DATA chunk has to be
> >>>> sent to send the last
> >>>> few bytes of data,
> >> One thing to mention is that a generally accepted practice is send control
> >> chunks first, be it bundled or separate.  This why BSD ends up sending SACK
> >> first when it can't bundle it with outgoing data.  Additionally, the way
> >> the code is now, we might end up sending a SACK even when sending DATA is
> >> prohibited via congestion or receive window.   Should we still be doing it
> >> even if we do not send DATA?
> > 
> > I don't think BSD is doing this deliberately.  BSD is behaving exactly how
> > lksctp would have behaved after my very first patch and before Wei noticed
> > the bit in the RFC about only appending the SACK if it doesn't cause the MTU
> > to be exceeded.  So I think that when the SACK is too big to be bundled in
> > the first fragment of a message, BSD is sending the SACK in separate packet
> > before the DATA more or less by accident.
> 
> Actually, it is rather deliberate.  Control chunks are always sent first.  If
> we have data to send and can bundle the data along with control chunks, we do so.
> 
> So, the stack attempts to bundle the SACK, but it can't due to size and sends
> the SACK first, followed by data.  It would be the same with other control
> chunks that may have but out the send queue as well.

Did you get this by reading the BSD code?  The reason I thought it was
more or less by accident is that, as I mentioned, BSD's behaviour is
the same as what lksctp would have done before Wei's MTU patch.  ie:
if it is sending a fragmented packet, it just blindly notices that the
first fragment it's about to send after the SACK becomes pending has no
room for a SACK, so it sends the SACK in a separate packet.  I'd have
thought that if they'd put much thought into it, they'd have implemented
something closer to what we're trying to do, which is that if there's
room in *any* fragment of a message, that they'd try to bundle the SACK.
Doesn't matter too much whether they leave room in the first fragment
and bundle the SACK there, or wait till the last fragment and bundle
the SACK there if there's room; they key thing is that BSD does not take
advantage of piggybacking the SACK onto fragmented messages even in the
"easy" cases.


> > 
> > I don't think the SACK needs to be sent immediately if sending DATA
> > is prohibited; the normal delay of 200ms should be fine in that case.
> > The case we're trying to opimize (I think) is when a client is sending
> > requests and receiving responses as fast as possible from a server.
> > So we just want to ensure that when a message is sent in either direction,
> > that it includes a SACK to the message that triggered the request/reply
> > it's just about to send.  That way, nobody ever has to stop and wait for
> > a SACK before sending their next request or response.  If the congestion
> > window prevents the sending of a request from C to S, there's no rush
> > to send a SACK to S because it hasn't received the request yet, and so
> > probably isn't going to need a send a reply anytime soon.
> > 
> 
> Yep, that's what I was thinking as well.  As such, I don't think that logic
> of bundling the SACK only if it fits (Wei's patch) is quite right.  What we
> want to do is see if we'll, in fact, send the data.  If we do, then try to
> send the SACK letting it bundle or be standalone.  To promote bundling, we'll
> try to size our DATA correctly in the first place when segmenting.
> 
> I think that will provide the most correct on-the-wire behavior.

Sure, works for me.

You'd think maybe the RFC would have more to say about all this!

--Doug.
