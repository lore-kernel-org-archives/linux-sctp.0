From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Oct 2018 19:07:49 +0000
Subject: [PATCH net-next 0/2] sctp: fix sk_wmem_queued and use it to check for writable space
Message-Id: <cover.1539716812.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp doesn't count and use asoc sndbuf_used, sk sk_wmem_alloc and
sk_wmem_queued properly, which also causes some problem.

This patchset is to improve it.

Xin Long (2):
  sctp: count both sk and asoc sndbuf with skb truesize and sctp_chunk
    size
  sctp: use sk_wmem_queued to check for writable space

 include/net/sctp/constants.h |  5 ----
 net/sctp/outqueue.c          |  8 ++----
 net/sctp/socket.c            | 59 +++++++++++---------------------------------
 3 files changed, 17 insertions(+), 55 deletions(-)

-- 
2.1.0
