From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 May 2017 05:28:53 +0000
Subject: [PATCH net 0/2] sctp: a bunch of fixes for processing dupcookie
Message-Id: <cover.1495517205.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

After introducing transport hashtable and per stream info into sctp,
some regressions were caused when processing dupcookie, this patchset
is to fix them.

Xin Long (2):
  sctp: fix stream update when processing dupcookie
  sctp: set new_asoc temp when processing dupcookie

 net/sctp/associola.c     |  4 +++-
 net/sctp/sm_make_chunk.c | 13 ++++---------
 net/sctp/sm_statefuns.c  |  3 +++
 3 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.1.0

