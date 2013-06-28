From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 28 Jun 2013 12:05:29 +0000
Subject: [PATCH net-next v3 0/2] Rework SCTP debugging framework
Message-Id: <1372421131-1672-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Please see patch 2 for a detailed description. Tested with lksctp-tools
suite and other stress tests. For the changes between v1,v2,v3, please
have a look into the individual patches.

Thanks for feedback/comments to Vlad Yasevich, Neil Horman, Joe Perches,
Andy Shevchenko.

Daniel Borkmann (2):
  lib: vsprintf: add IPv4/v6 generic %p[Ii]S[pfs] format specifier
  net: sctp: rework debugging framework to use pr_debug and friends

 Documentation/printk-formats.txt |  32 ++++++++
 include/net/sctp/sctp.h          |  75 -----------------
 lib/vsprintf.c                   | 108 ++++++++++++++++++++++++-
 net/sctp/Kconfig                 |  12 +--
 net/sctp/associola.c             |  67 ++++++++--------
 net/sctp/chunk.c                 |   5 +-
 net/sctp/debug.c                 |   4 -
 net/sctp/endpointola.c           |   5 +-
 net/sctp/input.c                 |   6 +-
 net/sctp/inqueue.c               |   9 +--
 net/sctp/ipv6.c                  |  21 ++---
 net/sctp/output.c                |  40 ++++------
 net/sctp/outqueue.c              | 160 ++++++++++++++++---------------------
 net/sctp/protocol.c              |  48 +++++------
 net/sctp/sm_make_chunk.c         |  25 +++---
 net/sctp/sm_sideeffect.c         |  96 ++++++++++------------
 net/sctp/sm_statefuns.c          |  77 +++++++++++-------
 net/sctp/socket.c                | 168 +++++++++++++++++++--------------------
 net/sctp/transport.c             |  49 ++++++------
 19 files changed, 521 insertions(+), 486 deletions(-)

-- 
1.7.11.7

