From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:42 +0000
Subject: [PATCH net-next 0/8] sctp: support per endpoint auth and asconf flags
Message-Id: <cover.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset mostly does 3 things:

  1. add per endpint asconf flag and use asconf flag properly
     and add SCTP_ASCONF_SUPPORTED sockopt.
  2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
  3. remove the 'global feature switch' to discard chunks.

Xin Long (8):
  sctp: add asconf_enable in struct sctp_endpoint
  sctp: not set peer.asconf_capable in sctp_association_init
  sctp: check asoc peer.asconf_capable before processing asconf
  sctp: add SCTP_ASCONF_SUPPORTED sockopt
  sctp: use ep and asoc auth_enable properly
  sctp: add sctp_auth_init and sctp_auth_free
  sctp: add SCTP_AUTH_SUPPORTED sockopt
  sctp: remove net sctp.x_enable working as a global switch

 include/net/sctp/auth.h    |   2 +
 include/net/sctp/structs.h |   1 +
 include/uapi/linux/sctp.h  |   2 +
 net/sctp/associola.c       |   9 --
 net/sctp/auth.c            | 101 ++++++++++++++++++--
 net/sctp/endpointola.c     |  64 ++-----------
 net/sctp/sm_make_chunk.c   |  18 ++--
 net/sctp/sm_statefuns.c    |   6 +-
 net/sctp/sm_statetable.c   |  28 +++---
 net/sctp/socket.c          | 230 ++++++++++++++++++++++++++++++++++++++-------
 10 files changed, 325 insertions(+), 136 deletions(-)

-- 
2.1.0
