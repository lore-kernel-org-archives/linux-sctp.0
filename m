From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 30 Jul 2019 12:38:18 +0000
Subject: [PATCHv2 net-next 0/5] sctp: clean up __sctp_connect function
Message-Id: <cover.1564490276.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset is to factor out some common code for
sctp_sendmsg_new_asoc() and __sctp_connect() into 2
new functioins.

v1->v2:
  - add the patch 1/5 to avoid a slab-out-of-bounds warning.
  - add some code comment for the check change in patch 2/5.
  - remove unused 'addrcnt' as Marcelo noticed in patch 3/5.

Xin Long (5):
  sctp: only copy the available addr data in sctp_transport_init
  sctp: check addr_size with sa_family_t size in
    __sctp_setsockopt_connectx
  sctp: clean up __sctp_connect
  sctp: factor out sctp_connect_new_asoc
  sctp: factor out sctp_connect_add_peer

 net/sctp/socket.c    | 376 ++++++++++++++++++++-------------------------------
 net/sctp/transport.c |   2 +-
 2 files changed, 147 insertions(+), 231 deletions(-)

-- 
2.1.0
