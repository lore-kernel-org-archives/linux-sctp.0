From: Corey Minyard <minyard@acm.org>
Date: Mon, 13 Jul 2020 21:59:07 +0000
Subject: 200ms delays with SCTP streaming data
Message-Id: <20200713215907.GE3235@minyard.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi, it's me again with another strange issue.  In case you didn't figure
it out before, I'm working on a library that supports all different
types of stream I/O, and SCTP is one supported building block.  I
noticed when I stacked a multiplexer layer on top of SCTP I started
getting timeouts occasionally.  It took a bit, but I finally realized
that I was getting 200ms delays occasionally between sending a packet
and receiving a packet.  I verified this with a trace right at the
sctp_send() and sctp_recvmsg() calls.  It doesn't seem to be regular
in any way I can see, but it happens often enough to cause issues.

If I replace the SCTP block with a TCP block, it works fine, and pretty
much all the code is the same except where it does the read and write
calls (including the epoll() usage, and I have also switched to select()
and it has the same issue).  The write calls don't seem to be the issue,
I see two back-to-back writes a few microseconds apart and see a 200ms
delay between the messages on the receive side.

The test in question sets up two connections and does a big simultaneous
bidirectional transfer.  The test app has 4 threads waiting on epoll()
handling data and writing data.

And the delay is always ~200ms.  Which sounds suspicious.

It's not using sctp_sendv() at the moment, as the systems I'm running on
don't have that yet.  But the library does have support if it sees it is
available.

So I don't think it's my library; I've stared at it a bunch (and found a
few other bugs) but I can't reconcile this one.  There are no timers
that would cause this in the code in question.  Just basically an
epoll() call waiting on data and receive processing that is comparing
data, along with write processing that is sending the same data.

Anyway, I haven't tried to create a small reproducer; I thought I would
report it first and see if anything rang a bell.  I tried this on a
recent kernel and got the same issue.

The library is at https://github.com/cminyard/gensio.  I'd need to
provide a patch for the tracing.

-corey
