From: Danny Smit <danny.smit.0@gmail.com>
Date: Fri, 06 Mar 2015 10:39:03 +0000
Subject: Memory issue with kernel sctp_connectx
Message-Id: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,

I'm look into a possible memory issue when using sctp_connectx. This
week I've asked to following on the CentOS mailing list:

------------------------------
I'm running into a possible memory issue with the SCTP implementation
in CentOS 6, using lksctp-tools. So far I've not seen the problem with
other distributions yet.

The problem is that whenever a SCTP client connection is initiated to
a second host and port at which no SCTP server application is
listening

The scenario is simple:
- call socket() to create a socket.
- call sctp_connectx() to establish a connection.

The last call is repeated periodically to retry to establish a connection.

When looking on the wire using wireshark it shows that an SCTP INIT
packet is sent to the second host, which replies with an SCTP ABORT.

This is exactly according to the SCTP specification. However it
appears ABORT isn't propagated into to application layer that calls
sctp_connectx().

Furthermore, because reconnect attempts are made, a steady memory
increasement occurs. Looking at /proc/meminfo, the increasement occurs
in SUnreclaim, the kernel slab cache.

Can you advice if this can be an issue with the SCTP implementation in
the kernel? Maybe an issue solved upstream, but not (yet) backported
into centos 6?

It applies to the following package versions (also to older kernels):

- kernel-2.6.32-504.8.1.el6.x86_64
- lksctp-tools-1.0.10-7.el6.x86_64
------------------------------

Note that the API is used in non-blocking mode.

However, I've now seen the problem also with other distributions and
came to realize that it may not be a CentOS specific problem. Can
someone advice whether this may be an issue in the linux kernel sctp
implementation?

Kind regards,

Danny Smit
