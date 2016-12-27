From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 27 Dec 2016 17:08:27 +0000
Subject: [PATCH net-next 0/5] SCTP cleanups
Message-Id: <cover.1482857832.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Some cleanups/simplifications I've been collecting.

Marcelo Ricardo Leitner (5):
  sctp: reduce indent level at sctp_sf_tabort_8_4_8
  sctp: reduce indent level in sctp_sf_shut_8_4_5
  sctp: simplify addr copy
  sctp: remove return value from sctp_packet_init/config
  sctp: sctp_chunk_length_valid should return bool

 include/net/sctp/structs.h |   7 ++-
 net/sctp/ipv6.c            |  16 +++---
 net/sctp/output.c          |  14 ++----
 net/sctp/protocol.c        |  18 +++----
 net/sctp/sm_statefuns.c    | 122 ++++++++++++++++++++++-----------------------
 5 files changed, 81 insertions(+), 96 deletions(-)

-- 
2.9.3

