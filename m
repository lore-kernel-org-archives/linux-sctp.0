From: Corey Minyard <minyard@acm.org>
Date: Tue, 14 Jul 2020 16:23:49 +0000
Subject: Re: 200ms delays with SCTP streaming data
Message-Id: <20200714162349.GP17797@minyard.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200713215907.GE3235@minyard.net>
In-Reply-To: <20200713215907.GE3235@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 14, 2020 at 03:51:49PM +0200, Michael Tuexen wrote:
> > On 14. Jul 2020, at 15:10, Corey Minyard <minyard@acm.org> wrote:
> > 
> > On Tue, Jul 14, 2020 at 07:12:58AM -0500, Corey Minyard wrote:
> >> On Mon, Jul 13, 2020 at 07:11:04PM -0300, Marcelo Leitner wrote:
> >>> On Mon, Jul 13, 2020 at 04:59:07PM -0500, Corey Minyard wrote:
> >>>> Hi, it's me again with another strange issue.  In case you didn't figure
> >>>> it out before, I'm working on a library that supports all different
> >>>> types of stream I/O, and SCTP is one supported building block.  I
> >>>> noticed when I stacked a multiplexer layer on top of SCTP I started
> >>>> getting timeouts occasionally.  It took a bit, but I finally realized
> >>>> that I was getting 200ms delays occasionally between sending a packet
> >>>> and receiving a packet.  I verified this with a trace right at the
> >>>> sctp_send() and sctp_recvmsg() calls.  It doesn't seem to be regular
> >>>> in any way I can see, but it happens often enough to cause issues.
> >>>> 
> >>>> If I replace the SCTP block with a TCP block, it works fine, and pretty
> >>>> much all the code is the same except where it does the read and write
> >>>> calls (including the epoll() usage, and I have also switched to select()
> >>>> and it has the same issue).  The write calls don't seem to be the issue,
> >>>> I see two back-to-back writes a few microseconds apart and see a 200ms
> >>>> delay between the messages on the receive side.
> >>>> 
> >>>> The test in question sets up two connections and does a big simultaneous
> >>>> bidirectional transfer.  The test app has 4 threads waiting on epoll()
> >>>> handling data and writing data.
> >>>> 
> >>>> And the delay is always ~200ms.  Which sounds suspicious.
> >>> 
> >>> That can be the delayed sack timer, in kernel.
> >>> /* Delayed sack timer - 200ms */
> >>> #define SCTP_DEFAULT_TIMEOUT_SACK       (200)
> >>> 
> >>> You may tweak the sysctl net.sctp.sack_timeout and see if changes
> >>> accordingly, or via SCTP_PEER_ADDR_PARAMS or even enable immediate ack
> >>> (by setting SPP_SACKDELAY_DISABLE)
> >> 
> >> Ok, setting SPP_SACKDELAY_DISABLE does make the problem go away.
> >> 
> >>> 
> >>>> 
> >>>> It's not using sctp_sendv() at the moment, as the systems I'm running on
> >>>> don't have that yet.  But the library does have support if it sees it is
> >>>> available.
> >>>> 
> >>>> So I don't think it's my library; I've stared at it a bunch (and found a
> >>>> few other bugs) but I can't reconcile this one.  There are no timers
> >>> 
> >>> Nice.
> >>> 
> >>>> that would cause this in the code in question.  Just basically an
> >>>> epoll() call waiting on data and receive processing that is comparing
> >>>> data, along with write processing that is sending the same data.
> >>>> 
> >>>> Anyway, I haven't tried to create a small reproducer; I thought I would
> >>>> report it first and see if anything rang a bell.  I tried this on a
> >>>> recent kernel and got the same issue.
> >>> 
> >>> I guess a combination of xmit rate, msg and buffer sizes and packet
> >>> drops can lead to this delay. I've seen it happening, but didn't have
> >>> the time to track it down back then.
> >> 
> >> There should be no packet drops.  It's running across localhost, and
> >> flow control in the multiplex layer as it's set up for the tests limits
> >> the maximum outstanding data to 1024 bytes.  With overhead and flow
> >> control messages it's maybe 1050 bytes of data that would ever be
> >> unacked.  (It's not really testing throughput, it's testing the inner
> >> workings of the multiplexing protocol.)
> >> 
> >> If I understand this correctly per the RFCs, by default if there are two
> >> messages outstanding, it will send an sack immediately.  Otherwise it
> >> waits 200ms.  I'm guessing what is happening is that that SCTP sends a
> >> sack and then receives one more message and the upper layer stops
> >> because of flow control.  Then the sack comes out in 200ms and things
> >> continue.
> > 
> > Actually, that still doesn't make sense.  The lack of a sack shouldn't
> > keep anything from sending unless the congestion window is closed, which
> > shouldn't happen in this case.  Am I correct?
> I guess you still have the Nagle algorithm enabled. Try enabled the SCTP_NODELAY
> socket option: https://tools.ietf.org/html/rfc6458#section-8.1.5 at the sender side.
> 
> It is enabled by default and will delay the sending of packet if they are
> not large enough (an implementation decision) and there is outstanding data.

Well, that was a surprise, disabling Nagle caused the problem to go
away.  Nagle generally doesn't make a difference when transferring lots
of data.

I guess this is a bad interaction between Nagle and the SCTP
sack algorithms.  With TCP in my test, data is flowing both ways so data
is always being acked, and Nagle is never significantly involved.

That's happening with SCTP, too, but in some situations a sack could be
sent, you get one more packet sent, and that packet won't be acked until
another packet is sent.  So you have unacked data, and Nagle will hold
any new data until it receives an ack for the outstanding packet.  So you
get stuck until the sack delay elapses.  Bah.

This is sort of like the interaction between Nagle and TCP delayed ack.
Which is sort of a bug, I guess, but well known.  I have a number of
ways to work around this issue, and I can document it so users can know.

Thanks for your help.

-corey

> 
> Best regards
> Michael
> > 
> > -corey
> > 
> >> 
> >> So I think I can figure out how to make this work smoothly.  I assume
> >> this doesn't happen in TCP because all packets carry an ack, and there
> >> is data flowing both ways all the time.
> >> 
> >> Thanks,
> >> 
> >> -corey
> >> 
> >>> 
> >>> That said, remember that Linux SCTP doesn't support buffer
> >>> auto-tuning. So considering you're running a stress test, you probably
> >>> want to adjust them accordingly manually to avoid packet drops.
> >>> 
> >>>  Marcelo
> >>> 
> >>>> 
> >>>> The library is at https://github.com/cminyard/gensio.  I'd need to
> >>>> provide a patch for the tracing.
> >>>> 
> >>>> -corey
> 
