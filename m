From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 02 Jul 2018 10:21:14 +0000
Subject: [PATCHv2 net-next 4/5] sctp: add support for setting flowlabel when adding a transport
Message-Id: <ec560e0a131aac9425c93a02eafd320c3bb5e584.1530526661.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1530526661.git.lucien.xin@gmail.com>
 <6504d3609be85e1574b6f44051d2523342f9e955.1530526661.git.lucien.xin@gmail.com>
 <d4512b8239763cedc076bdbc3a10fe1fb9e88481.1530526661.git.lucien.xin@gmail.com>
 <cbeee9df0afd61d4f1bf1ac08a627b1d8e9dcf6a.1530526661.git.lucien.xin@gmail.com>
In-Reply-To: <cbeee9df0afd61d4f1bf1ac08a627b1d8e9dcf6a.1530526661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, hideaki.yoshifuji@miraclelinux.com

Struct sockaddr_in6 has the member sin6_flowinfo that includes the
ipv6 flowlabel, it should also support for setting flowlabel when
adding a transport whose ipaddr is from userspace.

Note that addrinfo in sctp_sendmsg is using struct in6_addr for
the secondary addrs, which doesn't contain sin6_flowinfo, and
it needs to copy sin6_flowinfo from the primary addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 12 ++++++++++--
 net/sctp/socket.c    |  5 +++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 16ecfbc..297d9cf 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -650,8 +650,16 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	peer->sackdelay = asoc->sackdelay;
 	peer->sackfreq = asoc->sackfreq;
 
-	if (addr->sa.sa_family = AF_INET6)
-		peer->flowlabel = asoc->flowlabel;
+	if (addr->sa.sa_family = AF_INET6) {
+		__be32 info = addr->v6.sin6_flowinfo;
+
+		if (info) {
+			peer->flowlabel = ntohl(info & IPV6_FLOWLABEL_MASK);
+			peer->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+		} else {
+			peer->flowlabel = asoc->flowlabel;
+		}
+	}
 	peer->dscp = asoc->dscp;
 
 	/* Enable/disable heartbeat, SACK delay, and path MTU discovery
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 452029f..2607b50 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1697,6 +1697,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	struct sctp_association *asoc;
 	enum sctp_scope scope;
 	struct cmsghdr *cmsg;
+	__be32 flowinfo = 0;
 	struct sctp_af *af;
 	int err;
 
@@ -1781,6 +1782,9 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	if (!cmsgs->addrs_msg)
 		return 0;
 
+	if (daddr->sa.sa_family = AF_INET6)
+		flowinfo = daddr->v6.sin6_flowinfo;
+
 	/* sendv addr list parse */
 	for_each_cmsghdr(cmsg, cmsgs->addrs_msg) {
 		struct sctp_transport *transport;
@@ -1813,6 +1817,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 			}
 
 			dlen = sizeof(struct in6_addr);
+			daddr->v6.sin6_flowinfo = flowinfo;
 			daddr->v6.sin6_family = AF_INET6;
 			daddr->v6.sin6_port = htons(asoc->peer.port);
 			memcpy(&daddr->v6.sin6_addr, CMSG_DATA(cmsg), dlen);
-- 
2.1.0

