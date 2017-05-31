From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 31 May 2017 08:36:30 +0000
Subject: [PATCH net-next 0/2] sctp: improve asoc streams management
Message-Id: <cover.1496219741.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset changes to define asoc->stream as an object, and also
improve some codes to make it more clearly.

Xin Long (2):
  sctp: define the member stream as an object instead of pointer in asoc
  sctp: merge sctp_stream_new and sctp_stream_init

 include/net/sctp/structs.h |  7 ++--
 net/sctp/associola.c       | 16 ++++----
 net/sctp/chunk.c           |  4 +-
 net/sctp/outqueue.c        | 10 ++---
 net/sctp/proc.c            |  4 +-
 net/sctp/sm_make_chunk.c   |  5 ++-
 net/sctp/sm_statefuns.c    |  8 ++--
 net/sctp/socket.c          | 14 +++----
 net/sctp/stream.c          | 93 ++++++++++++++++++++--------------------------
 net/sctp/ulpqueue.c        |  8 ++--
 10 files changed, 78 insertions(+), 91 deletions(-)

-- 
2.1.0

