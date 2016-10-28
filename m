From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 28 Oct 2016 10:10:51 +0000
Subject: [PATCH net 0/3]  sctp: a bunch of fixes by holding transport
Message-Id: <cover.1477649076.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

There are several places where it holds assoc after getting transport by
searching from transport rhashtable, it may cause use-after- free issue.

This patchset is to fix them by holding transport instead.

Xin Long (3):
  sctp: hold transport instead of assoc in sctp_diag
  sctp: return back transport in __sctp_rcv_init_lookup
  sctp: hold transport instead of assoc when lookup assoc in rx path

 include/net/sctp/sctp.h |  2 +-
 net/sctp/input.c        | 35 +++++++++++++++++------------------
 net/sctp/ipv6.c         |  2 +-
 net/sctp/socket.c       |  5 +----
 4 files changed, 20 insertions(+), 24 deletions(-)

-- 
2.1.0

