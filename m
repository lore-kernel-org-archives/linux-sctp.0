From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 05 Jan 2018 13:17:16 +0000
Subject: [PATCH net v3 0/2] SCTP PMTU discovery fixes
Message-Id: <cover.1515152627.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, marcelo.leitner@gmail.com

This patchset fixes 2 issues with PMTU discovery that can lead to flood
of retransmissions.
The first patch fixes the issue for when PMTUD is disabled by the
application, while the second fixes it for when its enabled.

Please consider these to stable.

Thanks,

Marcelo Ricardo Leitner (2):
  sctp: do not retransmit upon FragNeeded if PMTU discovery is disabled
  sctp: fix the handling of ICMP Frag Needed for too small MTUs

 include/net/sctp/structs.h |  2 +-
 net/sctp/input.c           | 28 ++++++++++++++++------------
 net/sctp/transport.c       | 29 +++++++++++++++++++----------
 3 files changed, 36 insertions(+), 23 deletions(-)

-- 
2.14.3

