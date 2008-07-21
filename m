From: "leon zadorin" <leonleon77@gmail.com>
Date: Mon, 21 Jul 2008 01:10:00 +0000
Subject: where is (if at all) ioctl support for sctp...?
Message-Id: <26d2cb010807201810s413e0027y9c0e717fe860696d@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <26d2cb010807201802h2a638962j3323627a54a7d646@mail.gmail.com>
In-Reply-To: <26d2cb010807201802h2a638962j3323627a54a7d646@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all - sorry if this is being re-posted (have sent a message earlier
w/o first subscribing... so would expect the earlier message not to
make through),
... anyhow... my system is
2.6.23.1-42.fc8 #1 SMP x86_64 x86_64 x86_64 GNU/Linux
as I understand it - it comes with the kernel that is already
sctp-enabled... (in fact I am able to create sctp sockets and
communicate data between them).

I have a question wrt ability of finding the amount of 'free space' in
the SND buffer associated with a givent sctp socket's fd (the actual
buffering strategy [single buffer per association or not] is not
important to me - only the fact that eventually any message written
via an SCTP socket will have to go to some kernel-level buffer - and I
want to know the amount of free space left in such a buffer before
actually writing the message).

Essentially I don't want to wait for 'would block' type of a response
from a written socket as in my deployment scenario it would,
essentially, be too late- I want to begin throttling the data rate
being directed to the outgoing sctp socket based on the amount of free
space available in socket's buffer (the exact reasons are not that
important and will not benefit this discussion).

This is present in TCP protocols with ioctls like SIOCOUTQ.

This is also available in SCTP's implelmentation by OpenSS7 (sctp-0.2.26)...

So just to clear a few things:
1) is linux's default SCTP implementation in 2.6 different from
OpenSS7 implementation?
2) if so - are there any plans to support the aforementioned ioctl?

kind regards
Leon.
