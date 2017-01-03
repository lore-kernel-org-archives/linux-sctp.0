From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 03 Jan 2017 05:59:45 +0000
Subject: [PATCHv2 net-next 0/3] sctp: prepare asoc stream for stream reconf
Message-Id: <cover.1483422833.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

sctp stream reconf, described in RFC 6525, needs a structure to
save per stream information in assoc, like stream state.

In the future, sctp stream scheduler also needs it to save some
stream scheduler params and queues.

This patchset is to prepare the stream array in assoc for stream
reconf.

v1->v2:
  put these patches into a smaller group.

Xin Long (3):
  sctp: add stream arrays in asoc
  sctp: replace ssnmap with asoc stream arrays
  sctp: remove asoc ssnmap and ssnmap.c

 include/net/sctp/sctp.h    |   1 -
 include/net/sctp/structs.h |  70 +++++++++----------------
 net/sctp/Makefile          |   3 +-
 net/sctp/associola.c       |  23 ++++++---
 net/sctp/objcnt.c          |   2 -
 net/sctp/sm_make_chunk.c   |  24 ++++++---
 net/sctp/sm_statefuns.c    |   3 +-
 net/sctp/ssnmap.c          | 125 ---------------------------------------------
 net/sctp/ulpqueue.c        |  33 ++++--------
 9 files changed, 69 insertions(+), 215 deletions(-)
 delete mode 100644 net/sctp/ssnmap.c

-- 
2.1.0

