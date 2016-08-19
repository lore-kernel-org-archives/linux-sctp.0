From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Aug 2016 11:30:20 +0000
Subject: [PATCH net 0/2] sctp: not copying duplicate addrs to the assoc's bind address list
Message-Id: <cover.1471605833.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

Patch 1/2 is to fix some indent level.

Given that we have kernels out there with this issue, patch 2/2 also
fix sctp_raw_to_bind_addrs.

Xin Long (2):
  sctp: reduce indent level in sctp_copy_local_addr_list
  sctp: not copying duplicate addrs to the assoc's bind address list

 net/sctp/bind_addr.c |  3 +++
 net/sctp/protocol.c  | 40 ++++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 18 deletions(-)

-- 
2.1.0

