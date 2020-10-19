From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:22 +0000
Subject: [PATCHv4 net-next 05/16] sctp: create udp6 sock and set its encap_rcv
Message-Id: <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This patch is to add the udp6 sock part in sctp_udp_sock_start/stop().
udp_conf.use_udp6_rx_checksums is set to true, as:

   "The SCTP checksum MUST be computed for IPv4 and IPv6, and the UDP
    checksum SHOULD be computed for IPv4 and IPv6"

says in rfc6951#section-5.3.

v1->v2:
  - Add pr_err() when fails to create udp v6 sock.
  - Add #if IS_ENABLED(CONFIG_IPV6) not to create v6 sock when ipv6 is
    disabled.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h |  1 +
 net/sctp/protocol.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 8cc9aff..247b401 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -24,6 +24,7 @@ struct netns_sctp {
 
 	/* UDP tunneling listening sock. */
 	struct sock *udp4_sock;
+	struct sock *udp6_sock;
 	/* UDP tunneling listening port. */
 	int udp_port;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6fb03fc..e1501e7 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -869,6 +869,28 @@ int sctp_udp_sock_start(struct net *net)
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
+#if IS_ENABLED(CONFIG_IPV6)
+	memset(&udp_conf, 0, sizeof(udp_conf));
+
+	udp_conf.family = AF_INET6;
+	udp_conf.local_ip6 = in6addr_any;
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	udp_conf.use_udp6_rx_checksums = true;
+	udp_conf.ipv6_v6only = true;
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_err("Failed to create the SCTP UDP tunneling v6 sock\n");
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+		return err;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp6_sock = sock->sk;
+#endif
+
 	return 0;
 }
 
@@ -878,6 +900,10 @@ void sctp_udp_sock_stop(struct net *net)
 		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
 		net->sctp.udp4_sock = NULL;
 	}
+	if (net->sctp.udp6_sock) {
+		udp_tunnel_sock_release(net->sctp.udp6_sock->sk_socket);
+		net->sctp.udp6_sock = NULL;
+	}
 }
 
 /* Register address family specific functions. */
-- 
2.1.0
