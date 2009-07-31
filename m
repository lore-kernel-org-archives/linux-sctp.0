From: "Doug Graham" <dgraham@nortel.com>
Date: Fri, 31 Jul 2009 16:02:01 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet size exceed current MTU
Message-Id: <20090731160201.GB14894@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 31, 2009 at 10:01:31AM -0400, Vlad Yasevich wrote:
> Wei Yongjun wrote:
> > The sender should create a SACK only if the size of the final SCTP
> > packet does not exceed the current MTU. Base on RFC 4960:
> > 
> >   6.1.  Transmission of DATA Chunks
> > 
> >     Before an endpoint transmits a DATA chunk, if any received DATA
> >     chunks have not been acknowledged (e.g., due to delayed ack), the
> >     sender should create a SACK and bundle it with the outbound DATA
> >     chunk, as long as the size of the final SCTP packet does not exceed
> >     the current MTU.
> 
> 
> I like this much better, but the one thing I don't like is that we end
> up delaying the SACK if it doesn't fit in the chunk.
> 
> May be we can add some checking to see if there are more chunks that we'll
> be sending and try to bundle it later.
> 
> Another question is whether we should really be sending an immediate SACK
> back after receiving just one DATA?

IMO, if there is data flowing in the other direction, a SACK should
always be sent back at the same time as the DATA.  If the SACK can't be
bundled into the last chunk of DATA within a message, then it should be
sent by itself.

I'll try coming up with a patch to implement that behaviour when I
get time to look at the code some more (and if nobody beats me to it),
but I think the logic when sending DATA should be:

  if (have SACK to send)
     if (this is the last or only DATA chunk of a message)
        if (SACK+DATA fits in MTU)
           bundle SACK
        else
           send SACK in a separate packet

Doing something like this would mean that a SACK would always be sent
back immediately if there is DATA to send.  The only time the SACK would
be sent in a separate packet would be if the last fragment of a message
was too large to be bundled with a SACK.  That's a pretty narrow range
of packet sizes (1436-1452 bytes), so it shouldn't happen often.  In all
other cases, the SACK would be bundled with the last message fragment.

How does that sound?  Looks like it should be quite simple to implement,
provided that it's not difficult to figure out whether a DATA chunk
is the last in a message.

--Doug.
