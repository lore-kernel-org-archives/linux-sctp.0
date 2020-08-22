From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:15:54 +0000
Subject: [PATCH 0/7] net: sctp: delete duplicated words + other fixes
Message-Id: <20200822231601.32125-1-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop or fix repeated words in net/sctp/.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>


 net/sctp/associola.c     |    4 ++--
 net/sctp/auth.c          |    4 ++--
 net/sctp/bind_addr.c     |    2 +-
 net/sctp/chunk.c         |    2 +-
 net/sctp/protocol.c      |    8 ++++----
 net/sctp/sm_make_chunk.c |    6 +++---
 net/sctp/ulpqueue.c      |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)
