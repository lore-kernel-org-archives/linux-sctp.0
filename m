From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 13:49:00 +0000
Subject: [PATCH net-next 08/15] sctp: add encap_port for netns sock asoc and transport
Message-Id: <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

encap_port is added as per netns/sock/assoc/transport, and the
latter one's encap_port inherits the former one's by default.
The transport's encap_port value would mostly decide if one
packet should go out with udp encaped or not.

This patch also allows users to set netns's encap_port by sysctl.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  2 ++
 include/net/sctp/structs.h |  6 ++++++
 net/sctp/associola.c       |  4 ++++
 net/sctp/protocol.c        |  3 +++
 net/sctp/socket.c          |  1 +
 net/sctp/sysctl.c          | 10 ++++++++++
 6 files changed, 26 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index f622945..6af7a39 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -27,6 +27,8 @@ struct netns_sctp {
 	struct sock *udp6_sock;
 	/* udp tunneling listening port. */
 	int udp_port;
+	/* udp tunneling remote encap port. */
+	int encap_port;
 
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0bdff38..b6d0e58 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,8 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__u16 encap_port;
+
 	/* This is the max_retrans value for new associations. */
 	__u16 pathmaxrxt;
 
@@ -877,6 +879,8 @@ struct sctp_transport {
 	 */
 	unsigned long last_time_ecne_reduced;
 
+	__u16 encap_port;
+
 	/* This is the max_retrans value for the transport and will
 	 * be initialized from the assocs value.  This can be changed
 	 * using the SCTP_SET_PEER_ADDR_PARAMS socket option.
@@ -1790,6 +1794,8 @@ struct sctp_association {
 	 */
 	unsigned long hbinterval;
 
+	__u16 encap_port;
+
 	/* This is the max_retrans value for new transports in the
 	 * association.
 	 */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index fdb69d4..336df4b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -99,6 +99,8 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->hbinterval = msecs_to_jiffies(sp->hbinterval);
 
+	asoc->encap_port = sp->encap_port;
+
 	/* Initialize path max retrans value. */
 	asoc->pathmaxrxt = sp->pathmaxrxt;
 
@@ -624,6 +626,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 */
 	peer->hbinterval = asoc->hbinterval;
 
+	peer->encap_port = asoc->encap_port;
+
 	/* Set the path max_retrans.  */
 	peer->pathmaxrxt = asoc->pathmaxrxt;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 953891b..8b788bd 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1353,6 +1353,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set udp tunneling listening port to default value */
 	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
 
+	/* Set remote encap port to 0 by default */
+	net->sctp.encap_port = 0;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 53d0a41..9aa0c3d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4876,6 +4876,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->encap_port  = net->sctp.encap_port;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
 	sp->ps_retrans  = net->sctp.ps_retrans;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c16c809..ecc1b5e 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -36,6 +36,7 @@ static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
 static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
 static int ps_retrans_max = SCTP_PS_RETRANS_MAX;
+static int udp_port_max = 65535;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max @@ -291,6 +292,15 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "encap_port",
+		.data		= &init_net.sctp.encap_port,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_port_max,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0
