From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 17 Apr 2008 16:45:47 +0000
Subject: Is this a possible race condition.
Message-Id: <48077EBB.20006@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All

Background:

During the course of some stress testing we found an interesting scenario when
setting the socket send buffer fairly low.

The applications we use sets the send buffer low, and them performs a bunch of
short sends followed by a single receive.  The test runs for about 10-12 hours
with the application run a tight loop on each interface of the system.

Once in while this application ends up sitting in sendmsg().  Looking at the kernel
stack dumps (SysRq-T), the task in scheduled out sleeping in sctp_wait_for_sndbuf().
Looking at the memory consumption, everything is 0, i.e. all the skbs have been freed
and there is nothing on any queues.

This got me thinking that maybe wake-ups aren't getting to the socket.  I am working on
instrumenting a module to verify this, but looking through the wake-up logic, I think
we have a interesting race.

Race:

We charge every DATA chunk twice against the socket memory accounting, once in sctp_sendmsg()
and once in sctp_packet_transmit() when we allocated the skb that will hold all the bundled
chunks.  Now, a very important note is that we only perform the second charge against the
sk_wmem_alloc, so for short span of time socket wmem accounting does not match association
wmem accounting.  This is a separate bug, but it shows that the behavior described in the
Background section does not occur when sendbuf_policy is changed.

What I believe is happening is this.  The interface queue becomes full and thus a packet
that was charged during sctp_packet_transmit() is still sitting on this queue, while the
sendmsg() call completes successfully.  The actually draining of the queue happens later
and freeing up of the buffer happen when the interface is cleaning its tx rings.  This
can happen asynchronously from subsequent sendmsg() calls and also without any locking.

So, my supposition is that sock_rfree() and thus sctp_write_space() call
happens without a lock and in parallel with another sendmsg() call.  It appears that
the race is between checking to see if the asoc->wait queue is active and the activation
of this wait queue by the sctp_wait_for_sndbuf().  Thus, if by some very odd coincidence,
this happens to the last message that the application sent, the application we be scheduled
away and never wake up because the wake up logic already ran.

As you can see, the timing of this is very very narrow, and for us it takes about 10-12 hours
to reproduce.  The problem also happens on one or two interfaces out of 13 that are on the
systems and it's never the same interfaces every time.

Did I miss anything?  I was using e1000 as an example of how and when the transmitted skb is
freed and thus above is based on that.

-vlad
