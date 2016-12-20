From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Dec 2016 05:49:48 +0000
Subject: [PATCHv2 net 0/2] fix the issue that may copy duplicate addrs into assoc's bind address list
Message-Id: <cover.1482212764.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Patch 1/2 is to fix some indent level.

Given that we have kernels out there with this issue, patch 2/2 also
fix sctp_raw_to_bind_addrs.

v1 -> v2:
  Explain why we didn't filter the duplicate addresses when global
  address list gets updated in patch 2/2 changelog.

Xin Long (2):
  sctp: reduce indent level in sctp_copy_local_addr_list
  sctp: not copying duplicate addrs to the assoc's bind address list

 net/sctp/bind_addr.c |  3 +++
 net/sctp/protocol.c  | 40 ++++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 18 deletions(-)

-- 
2.1.0

