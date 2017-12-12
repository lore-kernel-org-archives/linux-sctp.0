From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 09:25:59 +0000
Subject: [PATCH net-next 8/8] sctp: support sysctl to allow users to use stream interleave
Message-Id: <2689359bfcc5f6712a50e98f91c1197c6040e061.1513070662.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com>
 <9b8315277069d021d8a6b581b7304af624a45c61.1513070662.git.lucien.xin@gmail.com>
 <dbe7bd0f6197086a6a4b4d28f0d63ee1073414e8.1513070662.git.lucien.xin@gmail.com>
 <807b1707f79b11d5883d71ea771e98e8f7af3ead.1513070662.git.lucien.xin@gmail.com>
 <5bdf9baf00c367ec91c1e06986be77835be7e451.1513070662.git.lucien.xin@gmail.com>
 <e4f468dc21292382de70c85f8e40272b37154ce0.1513070662.git.lucien.xin@gmail.com>
 <7a112fb936709ef7047548f778a895a46c31a935.1513070662.git.lucien.xin@gmail.com>
 <2ac016924b2b0f70e801297d203697fcb5deb227.1513070662.git.lucien.xin@gmail.com>
In-Reply-To: <2ac016924b2b0f70e801297d203697fcb5deb227.1513070662.git.lucien.xin@gmail.com>
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

