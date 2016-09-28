From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 28 Sep 2016 18:37:25 +0000
Subject: [PATCHv3 net 0/3] sctp: a bunch of fixes for prsctp polices
Message-Id: <cover.1475087147.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

This patchset is to fix 2 issues for prsctp polices:

  1. patch 1 and 2 fix "netperf-Throughput_Mbps -37.2% regression" issue
     when overloading the CPU.

  2. patch 3 fix "prsctp polices should check both sides' prsctp_capable,
     instead of only local side".

Xin Long (3):
  sctp: move sent_count to the memory hole in sctp_chunk
  sctp: remove prsctp_param from sctp_chunk
  sctp: change to check peer prsctp_capable when using prsctp polices

 include/net/sctp/structs.h | 13 +++----------
 net/sctp/chunk.c           | 11 ++++++++---
 net/sctp/outqueue.c        | 12 ++++++------
 net/sctp/sm_make_chunk.c   | 15 ---------------
 4 files changed, 17 insertions(+), 34 deletions(-)

-- 
2.1.0

