From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Dec 2017 16:41:32 +0000
Subject: [PATCHv2 net-next 8/8] sctp: support sysctl to allow users to use stream interleave
Message-Id: <2613f085c987063fba3bc7a45cadedd99cae19e3.1513269224.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
 <5982a46414cdea7856ee17683c5a714b411c7eb4.1513269224.git.lucien.xin@gmail.com>
 <30a1a95a2943469521de456d050717e1d46711fc.1513269224.git.lucien.xin@gmail.com>
 <d19327abb7e1001da4f9f66e06b3dff94b867b18.1513269224.git.lucien.xin@gmail.com>
 <d001538d3ff8d80ba726b5443675b7eea6ee09f6.1513269224.git.lucien.xin@gmail.com>
 <754ccfd8f4be04136dafa1d86deb8ee812638887.1513269224.git.lucien.xin@gmail.com>
 <3cfeed24a57f7c09d51f95df8545d7efc34db9cc.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <3cfeed24a57f7c09d51f95df8545d7efc34db9cc.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This is the last patch for support of stream interleave, after this patch,
users could enable stream interleave by systcl -w net.sctp.intl_enable=1.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sysctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index ef7ca44..33ca5b7 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -289,6 +289,13 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_sctp_do_auth,
 	},
 	{
+		.procname	= "intl_enable",
+		.data		= &init_net.sctp.intl_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0

