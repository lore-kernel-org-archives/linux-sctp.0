From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:29 +0000
Subject: [PATCHv3 net-next 04/16] sctp: create udp4 sock and add its encap_rcv
Message-Id: <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This patch is to add the functions to create/release udp4 sock,
and set the sock's encap_rcv to process the incoming udp encap
sctp packets. In sctp_udp_rcv(), as we can see, all we need to
do is fix the transport header for sctp_rcv(), then it would
implement the part of rfc6951#section-5.4:

  "When an encapsulated packet is received, the UDP header is removed.
   Then, the generic lookup is performed, as done by an SCTP stack
   whenever a packet is received, to find the association for the
   received SCTP packet"

Note that these functions will be called in the last patch of
this patchset when enabling this feature.

v1->v2:
  - Add pr_err() when fails to create udp v4 sock.
v2->v3:
  - Add 'select NET_UDP_TUNNEL' in sctp Kconfig.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h     |  5 +++++
 include/net/sctp/constants.h |  2 ++
 include/net/sctp/sctp.h      |  2 ++
 net/sctp/Kconfig             |  1 +
 net/sctp/protocol.c          | 43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index d8d02e4..3d10bef 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -22,6 +22,11 @@ struct netns_sctp {
 	 */
 	struct sock *ctl_sock;
 
+	/* udp tunneling listening sock. */
+	struct sock *udp4_sock;
+	/* udp tunneling listening port. */
+	int udp_port;
+
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
 	 * the system by catching address add/delete events.
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 122d9e2..b583166 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,8 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+#define SCTP_DEFAULT_UDP_PORT 9899	/* default udp tunneling port */
+
 /* These are the values for pf exposure, UNUSED is to keep compatible with old
  * applications by default.
  */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 4fc747b..bfd87a0 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -84,6 +84,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *addr,
 struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
 int sctp_register_pf(struct sctp_pf *, sa_family_t);
 void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
+int sctp_udp_sock_start(struct net *net);
+void sctp_udp_sock_stop(struct net *net);
 
 /*
  * sctp/socket.c
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 39d7fa9..5da599f 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -11,6 +11,7 @@ menuconfig IP_SCTP
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select LIBCRC32C
+	select NET_UDP_TUNNEL
 	help
 	  Stream Control Transmission Protocol
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2583323..2b7a3e1 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -44,6 +44,7 @@
 #include <net/addrconf.h>
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
+#include <net/udp_tunnel.h>
 
 #define MAX_SCTP_PORT_HASH_ENTRIES (64 * 1024)
 
@@ -840,6 +841,45 @@ static int sctp_ctl_sock_init(struct net *net)
 	return 0;
 }
 
+static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	skb_set_transport_header(skb, sizeof(struct udphdr));
+	sctp_rcv(skb);
+	return 0;
+}
+
+int sctp_udp_sock_start(struct net *net)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct udp_port_cfg udp_conf = {0};
+	struct socket *sock;
+	int err;
+
+	udp_conf.family = AF_INET;
+	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_err("Failed to create the SCTP udp tunneling v4 sock\n");
+		return err;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp4_sock = sock->sk;
+
+	return 0;
+}
+
+void sctp_udp_sock_stop(struct net *net)
+{
+	if (net->sctp.udp4_sock) {
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+	}
+}
+
 /* Register address family specific functions. */
 int sctp_register_af(struct sctp_af *af)
 {
@@ -1271,6 +1311,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable ECN by default. */
 	net->sctp.ecn_enable = 1;
 
+	/* Set udp tunneling listening port to default value */
+	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
-- 
2.1.0
