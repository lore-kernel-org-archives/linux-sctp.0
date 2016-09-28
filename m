From: Jia He <hejianet@gmail.com>
Date: Wed, 28 Sep 2016 06:22:25 +0000
Subject: [PATCH v5 4/7] proc: Reduce cache miss in sctp_snmp_seq_show
Message-Id: <1475043748-18161-5-git-send-email-hejianet@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1475043748-18161-1-git-send-email-hejianet@gmail.com>
In-Reply-To: <1475043748-18161-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, marcelo.leitner@gmail.com, Jia He <hejianet@gmail.com>

This is to use the generic interfaces snmp_get_cpu_field{,64}_batch to
aggregate the data by going through all the items of each cpu sequentially.

Signed-off-by: Jia He <hejianet@gmail.com>
---
 net/sctp/proc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index ef8ba77..9e7f4a7 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -73,13 +73,17 @@ static const struct snmp_mib sctp_snmp_list[] = {
 /* Display sctp snmp mib statistics(/proc/net/sctp/snmp). */
 static int sctp_snmp_seq_show(struct seq_file *seq, void *v)
 {
-	struct net *net = seq->private;
 	int i;
+	struct net *net = seq->private;
+	unsigned long buff[SCTP_MIB_MAX];
+
+	memset(buff, 0, sizeof(unsigned long) * SCTP_MIB_MAX);
 
+	snmp_get_cpu_field_batch(buff, sctp_snmp_list,
+				 net->sctp.sctp_statistics);
 	for (i = 0; sctp_snmp_list[i].name != NULL; i++)
 		seq_printf(seq, "%-32s\t%ld\n", sctp_snmp_list[i].name,
-			   snmp_fold_field(net->sctp.sctp_statistics,
-				      sctp_snmp_list[i].entry));
+						buff[i]);
 
 	return 0;
 }
-- 
2.5.5

