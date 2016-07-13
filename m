From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 13 Jul 2016 18:08:54 +0000
Subject: [PATCH net-next 0/6] sctp: allow GSO frags to access the chunk too
Message-Id: <cover.1468432819.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

Patchset is named after the most important fix in it. First two patches
are preparing the grounds for the 3rd patch.

After the 3rd, they are not strictly logically related to the patchset,
but I kept them together as they depend on each other.

More details on patch changelogs.

Thanks!

Marcelo Ricardo Leitner (6):
  sctp: allow others to use sctp_input_cb
  sctp: reorder sctp_ulpevent and shrink msg_flags
  sctp: allow GSO frags to access the chunk too
  sctp: avoid identifying address family many times for a chunk
  sctp: do not clear chunk->ecn_ce_done flag
  sctp: only check for ECN if peer is using it

 include/net/sctp/structs.h  | 23 +++++++++++++++++++++++
 include/net/sctp/ulpevent.h | 12 ++++++------
 net/sctp/input.c            | 12 +-----------
 net/sctp/inqueue.c          |  9 ++++++++-
 net/sctp/ipv6.c             |  9 ++++-----
 net/sctp/protocol.c         |  1 +
 net/sctp/sm_make_chunk.c    | 20 ++++----------------
 net/sctp/sm_statefuns.c     |  9 +++------
 net/sctp/socket.c           | 10 +++++++---
 net/sctp/ulpevent.c         | 14 +++++++++++---
 10 files changed, 68 insertions(+), 51 deletions(-)

-- 
2.7.4

