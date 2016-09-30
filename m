From: Jia He <hejianet@gmail.com>
Date: Fri, 30 Sep 2016 03:29:02 +0000
Subject: [PATCH v6 5/7] proc: Reduce cache miss in xfrm_statistics_seq_show
Message-Id: <1475206144-23228-6-git-send-email-hejianet@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1475206144-23228-1-git-send-email-hejianet@gmail.com>
In-Reply-To: <1475206144-23228-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, marcelo.leitner@gmail.com, Jia He <hejianet@gmail.com>

This is to use the generic interfaces snmp_get_cpu_field{,64}_batch to
aggregate the data by going through all the items of each cpu sequentially.

Signed-off-by: Jia He <hejianet@gmail.com>
---
 net/xfrm/xfrm_proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_proc.c b/net/xfrm/xfrm_proc.c
index 9c4fbd8..ba2b539 100644
--- a/net/xfrm/xfrm_proc.c
+++ b/net/xfrm/xfrm_proc.c
@@ -50,12 +50,18 @@ static const struct snmp_mib xfrm_mib_list[] = {
 
 static int xfrm_statistics_seq_show(struct seq_file *seq, void *v)
 {
+	unsigned long buff[LINUX_MIB_XFRMMAX];
 	struct net *net = seq->private;
 	int i;
+
+	memset(buff, 0, sizeof(unsigned long) * LINUX_MIB_XFRMMAX);
+
+	snmp_get_cpu_field_batch(buff, xfrm_mib_list,
+				 net->mib.xfrm_statistics);
 	for (i = 0; xfrm_mib_list[i].name; i++)
 		seq_printf(seq, "%-24s\t%lu\n", xfrm_mib_list[i].name,
-			   snmp_fold_field(net->mib.xfrm_statistics,
-					   xfrm_mib_list[i].entry));
+						buff[i]);
+
 	return 0;
 }
 
-- 
2.5.5

