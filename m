From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:18:33 +0000
Subject: [PATCH net 0/3] a couple of fixes for chunks abandoned in prsctp
Message-Id: <cover.1511615658.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now when abandoning chunks in prsctp, it doesn't consider for frags in
one msg, which would cause peer can never receive the whole frags for
one msg to get them reassembled, these pieces of this msg will stay in
the reasm queue forever and block the following chunks' receiving.

This patchset is to fix them in patch 2 and 3, and also fix another
issue for prsctp in patch 1.

Xin Long (3):
  sctp: only update outstanding_bytes for transmitted queue when doing
    prsctp_prune
  sctp: abandon the whole msg if one part of a fragmented message is
    abandoned
  sctp: do not abandon the other frags in unsent outq if one msg has
    outstanding frags

 include/net/sctp/structs.h |  3 ++-
 net/sctp/chunk.c           | 11 +++++++++++
 net/sctp/outqueue.c        | 19 +++++++++++++------
 3 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.1.0

