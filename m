From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Oct 2019 06:14:43 +0000
Subject: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Message-Id: <cover.1571033544.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

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

v1->v2:
  - See Patch 2/5 and Patch 5/5.
v2->v3:
  - See Patch 1/5, 2/5 and 3/5.

Xin Long (5):
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt

 include/net/netns/sctp.h     |  14 +++++
 include/net/sctp/constants.h |  10 +++
 include/net/sctp/structs.h   |  13 +++-
 include/uapi/linux/sctp.h    |  15 +++++
 net/sctp/associola.c         |  31 ++++-----
 net/sctp/protocol.c          |   6 ++
 net/sctp/sm_sideeffect.c     |   5 ++
 net/sctp/socket.c            | 147 ++++++++++++++++++++++++++++++++++++++-----
 net/sctp/sysctl.c            |  19 ++++++
 9 files changed, 226 insertions(+), 34 deletions(-)

-- 
2.1.0
