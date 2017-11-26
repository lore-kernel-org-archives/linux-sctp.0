From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 12:16:05 +0000
Subject: [PATCH net 0/3] sctp: fix some other sparse errors
Message-Id: <cover.1511698478.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

After the last fixes for sparse errors, there are still three sparse
errors in sctp codes, two of them are type cast, and the other one
is using extern.

Xin Long (3):
  sctp: force SCTP_ERROR_INV_STRM with __u32 when calling
    sctp_chunk_fail
  sctp: force the params with right types for sctp csum apis
  sctp: remove extern from stream sched

 include/net/sctp/checksum.h     | 13 +++++++------
 include/net/sctp/sctp.h         |  5 +++++
 include/net/sctp/stream_sched.h |  5 +++++
 net/sctp/protocol.c             |  1 +
 net/sctp/stream.c               |  2 +-
 net/sctp/stream_sched.c         | 25 ++++++++++++++++++-------
 net/sctp/stream_sched_prio.c    |  7 ++++++-
 net/sctp/stream_sched_rr.c      |  7 ++++++-
 8 files changed, 49 insertions(+), 16 deletions(-)

-- 
2.1.0

