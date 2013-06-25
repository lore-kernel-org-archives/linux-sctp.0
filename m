From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 25 Jun 2013 15:13:35 +0000
Subject: [PATCH net-next 0/6] Further SCTP changes
Message-Id: <1372173221-15244-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Mostly it's all about getting rid of unnecessary code, and/or making
it more clean and readable. Code has been tested with lksctp-tools
functional test suite and also my small sctp stress test helper that
was used to discover the recent null-ptr derefs.

Changes since last version:
  - Left sctp_put_port() still in sctp_endpoint_destroy() for now
  - Added minor "net: sctp: simplify sctp_get_port" patch

Daniel Borkmann (6):
  net: sctp: remove TEST_FRAME ifdef
  ktime: add ms_to_ktime() and ktime_add_ms() helpers
  net: sctp: migrate cookie life from timeval to ktime
  net: sctp: minor: sctp_seq_dump_local_addrs add missing newline
  net: sctp: decouple cleaning some socket data from endpoint
  net: sctp: simplify sctp_get_port

 include/linux/ktime.h      | 13 +++++++++++++
 include/net/sctp/sctp.h    | 25 -------------------------
 include/net/sctp/structs.h |  6 +++---
 net/sctp/associola.c       |  8 +-------
 net/sctp/endpointola.c     | 18 +++++++++---------
 net/sctp/proc.c            |  2 +-
 net/sctp/sm_make_chunk.c   | 19 ++++++++-----------
 net/sctp/socket.c          | 35 +++++++++++++++++++----------------
 8 files changed, 54 insertions(+), 72 deletions(-)

-- 
1.7.11.7

