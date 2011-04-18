From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 18 Apr 2011 03:24:33 +0000
Subject: [PATCH net-next-2.6 0/3] new SCTP sockets APIs
Message-Id: <4DABAEF1.1010506@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

This patchset implement some new sockets APIs for net-next-2.6.

Wei Yongjun (3):
  sctp: implement socket option SCTP_GET_ASSOC_ID_LIST
  sctp: change auth event type name to SCTP_AUTHENTICATION_EVENT
  sctp: implement event notification SCTP_SENDER_DRY_EVENT

 include/net/sctp/sm.h       |    1 +
 include/net/sctp/ulpevent.h |    3 ++
 include/net/sctp/user.h     |   33 ++++++++++++++++++++++++++-
 net/sctp/sm_statefuns.c     |   24 +++++++++++++++++++
 net/sctp/sm_statetable.c    |    2 +-
 net/sctp/socket.c           |   52 +++++++++++++++++++++++++++++++++++++++++++
 net/sctp/ulpevent.c         |   30 ++++++++++++++++++++++++-
 7 files changed, 142 insertions(+), 3 deletions(-)


