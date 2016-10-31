From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 31 Oct 2016 12:32:30 +0000
Subject: [PATCHv2 net 0/3] sctp: a bunch of fixes by holding transport
Message-Id: <cover.1477916928.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

There are several places where it holds assoc after getting transport by
searching from transport rhashtable, it may cause use-after-free issue.

This patchset is to fix them by holding transport instead.

v1->v2:
  Fix the changelog of patch 2/3

Xin Long (3):
  sctp: hold transport instead of assoc in sctp_diag
  sctp: return back transport in __sctp_rcv_init_lookup
  sctp: hold transport instead of assoc when lookup assoc in rx path

 include/net/sctp/sctp.h |  2 +-
 net/sctp/input.c        | 35 +++++++++++++++++------------------
 net/sctp/ipv6.c         |  2 +-
 net/sctp/socket.c       |  5 +----
 4 files changed, 20 insertions(+), 24 deletions(-)

-- 
2.1.0

