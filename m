From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 03 Sep 2018 07:47:09 +0000
Subject: [PATCH net 0/2] sctp: two fixes for spp_ipv6_flowlabel and spp_dscp sockopts
Message-Id: <cover.1535960717.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patchset fixes two problems in sctp_apply_peer_addr_params()
when setting spp_ipv6_flowlabel or spp_dscp.

Xin Long (2):
  sctp: fix invalid reference to the index variable of the iterator
  sctp: not traverse asoc trans list if non-ipv6 trans exists for
    ipv6_flowlabel

 net/sctp/socket.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

-- 
2.1.0
