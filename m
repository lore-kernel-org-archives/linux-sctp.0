From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 21 Oct 2018 04:43:35 +0000
Subject: [PATCH net-next 0/3] sctp: add support for sk_reuseport
Message-Id: <cover.1540095102.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1520253539.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1520253539.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp sk_reuseport allows multiple socks to listen on the same port and
addresses, as long as these socks have the same uid. This works pretty
much as TCP/UDP does, the only difference is that sctp is multi-homing
and all the bind_addrs in these socks will have to completely matched,
otherwise listen() will return err.

The below is when 5 sockets are listening on 172.16.254.254:6400 on a
server, 26 sockets on a client connect to 172.16.254.254:6400 and each
may be processed by a different socket on the server which is selected
by hash(lport, pport, paddr) in reuseport_select_sock():

 # ss --sctp -nn
   State      Recv-Q Send-Q        Local Address:Port     Peer Address:Port
   LISTEN     0      10           172.16.254.254:6400                *:*
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.1:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.4:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.3:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.4:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.2:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.3:1234
   LISTEN     0      10           172.16.254.254:6400                *:*
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.3:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.4:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.2:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.1:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.2:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.3:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.4:1234
   LISTEN     0      10           172.16.254.254:6400                *:*
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.2:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.5:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.4.5:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400   172.16.253.253:1234
   LISTEN     0      10           172.16.254.254:6400                *:*
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.2:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.3:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.4:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.5:1234
   LISTEN     0      10           172.16.254.254:6400                *:*
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.1:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.1.5:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.2.5:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.3.1:1234
   `- ESTAB   0      0       172.16.254.254%eth1:6400       172.16.5.1:1234

Xin Long (3):
  sctp: do reuseport_select_sock in __sctp_rcv_lookup_endpoint
  sctp: add sock_reuseport for the sock in __sctp_hash_endpoint
  sctp: process sk_reuseport in sctp_get_port_local

 include/net/sctp/sctp.h    |   2 +-
 include/net/sctp/structs.h |   6 ++-
 net/core/sock_reuseport.c  |   1 +
 net/sctp/bind_addr.c       |  28 ++++++++++
 net/sctp/input.c           | 129 ++++++++++++++++++++++++++++++++-------------
 net/sctp/socket.c          |  49 +++++++++++------
 6 files changed, 162 insertions(+), 53 deletions(-)

-- 
2.1.0
