From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:57:03 +0000
Subject: [PATCH net-next 0/4] sctp: tidy up some ep and asoc feature flags
Message-Id: <cover.1562604972.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset is to remove some unnecessary feature flags from
sctp_assocation and move some others to the right places.

Xin Long (4):
  sctp: remove reconf_enable from asoc
  sctp: remove prsctp_enable from asoc
  sctp: rename asoc intl_enable to asoc peer.intl_capable
  sctp: rename sp strm_interleave to ep intl_enable

 include/net/sctp/structs.h   | 37 ++++++++++++++++++-------------------
 net/sctp/associola.c         |  2 --
 net/sctp/sm_make_chunk.c     | 21 ++++++++++-----------
 net/sctp/socket.c            | 19 ++++++++-----------
 net/sctp/stream_interleave.c |  4 ++--
 net/sctp/stream_sched.c      |  2 +-
 6 files changed, 39 insertions(+), 46 deletions(-)

-- 
2.1.0
