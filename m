From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Thu, 24 Jul 2014 18:12:30 +0000
Subject: source IP and interface selection
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E374E28@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

We have a multi-homed SCTP network topology that essentially boils down to this

A <----------> A'
B <----------> B'

where IPs A and B are on the local host, and A' and B' are the corresponding IPs on the remote host.

We are seeing HEARTBEAT request messages leave the B interface (destined for B') but that contain a source IP address of A.  On the other hand, a simple ICMP 'ping' command to B will leave the B interface, but with the (expected) source address of B as well.  So presumably the issue is SCTP-specific.

I know the Linux uses a fairly weak host model and will route packets with source address A out of B if instructed to do so.  So the question here is, is it SCTP that is specifically instructing the kernel to do so in this case?  Are there any kernel SCTP parameters, or generic kernel IP parameters for that matter, that can be configured so as to disallow this behaviour?


