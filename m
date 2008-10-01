From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 01 Oct 2008 18:14:52 +0000
Subject: pull request: net-next sctp updates
Message-Id: <1222884892-22938-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org

Hi David

Please consider the following sctp work for net-next.

The following changes since commit bcd41303f422015ab662c9276d108414aa75b796:
  KOVACS Krisztian (1):
        udp: Export UDP socket lookup function

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vxy/lksctp-dev.git net-next

Neil Horman (1):
      sctp: reduce memory footprint of sctp_chunk structure

Vlad Yasevich (6):
      sctp: Only mark chunks as missing when there are gaps
      sctp: Optimize SFR-CACC transport list walking during SACK processing
      sctp: Retransmit list is ineligable for missing indications
      sctp: try harder to figure out address family when checking wildcards
      sctp: enable cookie-echo retransmission transport switch
      sctp: correctly save sctp_adaptation from parameter.

Wei Yongjun (2):
      sctp: Fix to start T5-shutdown-guard timer while enter SHUTDOWN-SENT state
      sctp: Fix the SNMP counter of SCTP_MIB_OUTOFBLUES

 include/net/sctp/structs.h |   33 ++++++++++--------
 net/sctp/bind_addr.c       |   16 +++++++--
 net/sctp/ipv6.c            |    5 ++-
 net/sctp/output.c          |    2 +-
 net/sctp/outqueue.c        |   65 +++++++++++++++++++-----------------
 net/sctp/sm_make_chunk.c   |    4 +-
 net/sctp/sm_sideeffect.c   |   78 +++++++++++++++++++++++++-------------------
 net/sctp/sm_statefuns.c    |   36 +++++++++-----------
 net/sctp/sm_statetable.c   |    2 +-
 net/sctp/socket.c          |   10 +++---
 10 files changed, 139 insertions(+), 112 deletions(-)

Thanks
-vlad
