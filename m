From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 09 Sep 2019 07:56:46 +0000
Subject: [PATCH net-next 0/5] sctp: update from rfc7829
Message-Id: <cover.1568015756.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

SCTP-PF was implemented based on a Internet-Draft in 2012:

  https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05

It's been updated quite a few by rfc7829 in 2016.

This patchset adds the following features:

  1. add SCTP_ADDR_POTENTIALLY_FAILED notification
  2. add pf_expose per netns/sock/asoc
  3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  4. add ps_retrans per netns/sock/asoc/transport
     (Primary Path Switchover)
  5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt

Xin Long (5):
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add spt_pathcpthld in struct sctp_paddrthlds

 include/net/netns/sctp.h   | 13 ++++++
 include/net/sctp/structs.h | 13 ++++--
 include/uapi/linux/sctp.h  |  4 ++
 net/sctp/associola.c       | 28 ++++++-------
 net/sctp/protocol.c        |  6 +++
 net/sctp/sm_sideeffect.c   |  5 +++
 net/sctp/socket.c          | 99 +++++++++++++++++++++++++++++++++++++++++++++-
 net/sctp/sysctl.c          | 16 ++++++++
 8 files changed, 165 insertions(+), 19 deletions(-)

-- 
2.1.0
