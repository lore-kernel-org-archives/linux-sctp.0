From: Andreas Steinmetz <ast@domdv.de>
Date: Tue, 20 Jun 2017 13:24:13 +0000
Subject: SCTP_SOCKOPT_PEELOFF is missing SOCK_CLOEXEC (and SOCK_NONBLOCK)
Message-Id: <1497965053.10887.2.camel@domdv.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

[please CC me, I'm not subscribed]

It seems that if one does a getsockopt(SCTP_SOCKOPT_PEELOFF) a.k.a.
sctp_peeloff(), even if the socket descriptor from which the
association is to be peeled off has SOCK_CLOEXEC/SOCK_NONBLOCK set,
the peeled off socket descriptor doesn't have so.

It would be advisable to either clone these flags or add an atomic
version of SCTP_SOCKOPT_PEELOFF (accept4() style).

The missing SOCK_CLOEXEC requires unintentional additional locking
which typically is prone to errors and can slow down processing.
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
