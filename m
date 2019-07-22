From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Jul 2019 17:37:56 +0000
Subject: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
Message-Id: <cover.1563817029.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patchset is to factor out some common code for
sctp_sendmsg_new_asoc() and __sctp_connect() into 2
new functioins.

Xin Long (4):
  sctp: check addr_size with sa_family_t size in
    __sctp_setsockopt_connectx
  sctp: clean up __sctp_connect
  sctp: factor out sctp_connect_new_asoc
  sctp: factor out sctp_connect_add_peer

 net/sctp/socket.c | 377 +++++++++++++++++++++---------------------------------
 1 file changed, 147 insertions(+), 230 deletions(-)

-- 
2.1.0
