From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 26 Jun 2013 17:01:11 +0000
Subject: [PATCH net-next 0/2] Rework SCTP debugging framework
Message-Id: <1372266073-11998-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Please see patch 2 for a detailed description. Tested with lksctp-tools
suite and other stress tests.

Daniel Borkmann (2):
  lib: vsprintf: add IPv4/v6 generic %pig/%pIg format specifier
  net: sctp: rework debugging framework to use pr_debug and friends

 include/net/sctp/sctp.h  |  75 ---------------------
 lib/vsprintf.c           |  18 ++++-
 net/sctp/Kconfig         |  12 ++--
 net/sctp/associola.c     |  69 +++++++++----------
 net/sctp/chunk.c         |   5 +-
 net/sctp/debug.c         |   4 --
 net/sctp/endpointola.c   |   5 +-
 net/sctp/input.c         |   6 +-
 net/sctp/inqueue.c       |   9 ++-
 net/sctp/ipv6.c          |  21 +++---
 net/sctp/output.c        |  40 +++++------
 net/sctp/outqueue.c      | 160 ++++++++++++++++++++------------------------
 net/sctp/protocol.c      |  48 +++++++-------
 net/sctp/sm_make_chunk.c |  25 +++----
 net/sctp/sm_sideeffect.c |  97 ++++++++++++---------------
 net/sctp/sm_statefuns.c  |  77 +++++++++++++---------
 net/sctp/socket.c        | 168 ++++++++++++++++++++++-------------------------
 net/sctp/transport.c     |  51 +++++++-------
 18 files changed, 405 insertions(+), 485 deletions(-)

-- 
1.7.11.7

