From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 16 Apr 2013 21:07:09 +0000
Subject: [PATCH net-next 0/9] Minor SCTP cleanups all over the place
Message-Id: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

That's a batch of cleanups for the SCTP protocol. Probably all
deadly boring and trivial patches, but it always bugs me. :-) I
guess this is still from the very SCTP beginning in Linux. Well,
at least we can now remove 41 lines of code in total. lksctp-tools
test suite run through without problems.

Daniel Borkmann (9):
  net: sctp: sctp_ssnmap: remove 'malloced' element from struct
  net: sctp: sctp_inq: remove dead code
  net: sctp: sctp_outq: remove 'malloced' from its struct
  net: sctp: sctp_outq: consolidate chars into bitfield
  net: sctp: outqueue: simplify sctp_outq_uncork function
  net: sctp: sctp_transport: remove unused variable
  net: sctp: sctp_bind_addr: remove dead code
  net: sctp: sctp_ulpq: remove 'malloced' struct member
  net: sctp: sctp_ulpq: do not use char as a struct member

 include/net/sctp/structs.h  | 24 ++++--------------------
 include/net/sctp/ulpqueue.h |  3 +--
 net/sctp/bind_addr.c        |  7 -------
 net/sctp/inqueue.c          |  7 -------
 net/sctp/outqueue.c         | 11 ++---------
 net/sctp/ssnmap.c           | 23 ++++++++++++-----------
 net/sctp/transport.c        |  1 -
 net/sctp/ulpqueue.c         |  3 ---
 8 files changed, 19 insertions(+), 60 deletions(-)

-- 
1.7.11.7

