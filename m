From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Thu, 07 Aug 2014 21:08:19 +0000
Subject: MSG_EOR flag in conjunction with SOCK_STREAM
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E38504E@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

A question about using a SOCK_STREAM socket (one-to-one TCP-style) and checking for the MSG_EOR flag.

If, on a given association (i.e. a single file descriptor, as per the one-to-one TCP-style SOCK_STREAM socket semantics), a message is received via sctp_recvmsg() with the MSG_EOR flag *not* set (such that more of the message is yet to be retrieved), does LKSCTP guarantee that the subsequent call to sctp_recvmsg() will still pertain to the same message (i.e. record)?

That is, could the following message sequence (as returned by sctp_recvmsg(); not necessarily in this order on the wire) ever occur in subsequent calls to sctp_recvmsg() on the aforementioned file descriptor?

MSG A, part 1
MSG A, part 2
MSG A, part 3
MSG B
MSG A, part 4
MSG A, part 5 (EOR)
.
.
.

Or will the kernel always guarantee the following:

MSG A, part 1
MSG A, part 2
MSG A, part 3
MSG A, part 4
MSG A, part 5 (EOR)
MSG B
.
.
.

If the former is indeed possible, can the 'interleaving' only occur within separate streams of the association?  Or can it also occur within a single given stream?

Can unordered data ever cause this to occur?

