From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 20:24:18 +0000
Subject: [PATCH next 0/2] Rename WORD_TRUNC/ROUND macros and use them
Message-Id: <cover.1474402102.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, David Laight <David.Laight@ACULAB.COM>

This patchset aims to rename these macros to a non-confusing name, as
reported by David Laight and David Miller, and to update all remaining
places to make use of it, which was 1 last remaining spot.

Details on the specific changelogs.

Thanks!

Marcelo Ricardo Leitner (2):
  sctp: rename WORD_TRUNC/ROUND macros
  sctp: make use of WORD_TRUNC macro

 include/net/sctp/sctp.h  | 10 +++++-----
 net/netfilter/xt_sctp.c  |  2 +-
 net/sctp/associola.c     |  2 +-
 net/sctp/chunk.c         | 13 +++++++------
 net/sctp/input.c         |  8 ++++----
 net/sctp/inqueue.c       |  2 +-
 net/sctp/output.c        | 12 ++++++------
 net/sctp/sm_make_chunk.c | 26 +++++++++++++-------------
 net/sctp/sm_statefuns.c  |  6 +++---
 net/sctp/transport.c     |  4 ++--
 net/sctp/ulpevent.c      |  4 ++--
 11 files changed, 45 insertions(+), 44 deletions(-)

-- 
2.7.4

