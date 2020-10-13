From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:41 +0000
Subject: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
 <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
 <46f33eb9331b7e1e688a7f125201ad600ae83fbd.1602574012.git.lucien.xin@gmail.com>
 <c79a0be422c96fec9da194a20853811d93809393.1602574012.git.lucien.xin@gmail.com>
 <df18ce9f94be0a58bbf1743071993b95696aed2d.1602574012.git.lucien.xin@gmail.com>
 <59d083919cccb32dad7aec119d00c5300b0c2800.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <59d083919cccb32dad7aec119d00c5300b0c2800.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This patch is to enable udp tunneling socks by calling
sctp_udp_sock_start() in sctp_ctrlsock_init(), and
sctp_udp_sock_stop() in sctp_ctrlsock_exit().

Also add sysctl udp_port to allow changing the listening
sock's port by users.

Wit this patch, the whole sctp over udp feature can be
enabled and used.

v1->v2:
  - Also update ctl_sock udp_port in proc_sctp_do_udp_port()
    where netns udp_port gets changed.
v2->v3:
  - call htons() when setting sk udp_port from netns udp_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c |  5 +++++
 net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index be002b7..79fb4b5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	if (status)
 		pr_err("Failed to initialize the SCTP control sock\n");
 
+	status = sctp_udp_sock_start(net);
+	if (status)
+		pr_err("Failed to initialize the SCTP udp tunneling sock\n");
+
 	return status;
 }
 
@@ -1476,6 +1480,7 @@ static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
+	sctp_udp_sock_stop(net);
 }
 
 static struct pernet_operations sctp_ctrlsock_ops = {
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index ecc1b5e..4395659 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -49,6 +49,8 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write, void *buffer,
 				size_t *lenp, loff_t *ppos);
+static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write, void *buffer,
+				 size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_alpha_beta(struct ctl_table *ctl, int write,
 				   void *buffer, size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
@@ -292,6 +294,15 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "udp_port",
+		.data		= &init_net.sctp.udp_port,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_sctp_do_udp_port,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_port_max,
+	},
+	{
 		.procname	= "encap_port",
 		.data		= &init_net.sctp.encap_port,
 		.maxlen		= sizeof(int),
@@ -487,6 +498,45 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	unsigned int min = *(unsigned int *)ctl->extra1;
+	unsigned int max = *(unsigned int *)ctl->extra2;
+	struct ctl_table tbl;
+	int ret, new_value;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.udp_port;
+
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (write && ret = 0) {
+		struct sock *sk = net->sctp.ctl_sock;
+
+		if (new_value > max || new_value < min)
+			return -EINVAL;
+
+		net->sctp.udp_port = new_value;
+		sctp_udp_sock_stop(net);
+		ret = sctp_udp_sock_start(net);
+		if (ret)
+			net->sctp.udp_port = 0;
+
+		/* Update the value in the control socket */
+		lock_sock(sk);
+		sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
+		release_sock(sk);
+	}
+
+	return ret;
+}
+
 int sctp_sysctl_net_register(struct net *net)
 {
 	struct ctl_table *table;
-- 
2.1.0
