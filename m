From: Jia He <hejianet@gmail.com>
Date: Fri, 30 Sep 2016 03:29:00 +0000
Subject: [PATCH v6 3/7] proc: Reduce cache miss in snmp6_seq_show
Message-Id: <1475206144-23228-4-git-send-email-hejianet@gmail.com>
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
 net/ipv6/proc.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 679253d0..cc8e3ae 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -30,6 +30,11 @@
 #include <net/transp_v6.h>
 #include <net/ipv6.h>
 
+#define MAX4(a, b, c, d) \
+	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+#define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
+			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
+
 static int sockstat6_seq_show(struct seq_file *seq, void *v)
 {
 	struct net *net = seq->private;
@@ -191,25 +196,34 @@ static void snmp6_seq_show_item(struct seq_file *seq, void __percpu *pcpumib,
 				atomic_long_t *smib,
 				const struct snmp_mib *itemlist)
 {
+	unsigned long buff[SNMP_MIB_MAX];
 	int i;
-	unsigned long val;
 
-	for (i = 0; itemlist[i].name; i++) {
-		val = pcpumib ?
-			snmp_fold_field(pcpumib, itemlist[i].entry) :
-			atomic_long_read(smib + itemlist[i].entry);
-		seq_printf(seq, "%-32s\t%lu\n", itemlist[i].name, val);
+	if (pcpumib) {
+		memset(buff, 0, sizeof(unsigned long) * SNMP_MIB_MAX);
+
+		snmp_get_cpu_field_batch(buff, itemlist, pcpumib);
+		for (i = 0; itemlist[i].name; i++)
+			seq_printf(seq, "%-32s\t%lu\n",
+				   itemlist[i].name, buff[i]);
+	} else {
+		for (i = 0; itemlist[i].name; i++)
+			seq_printf(seq, "%-32s\t%lu\n", itemlist[i].name,
+				   atomic_long_read(smib + itemlist[i].entry));
 	}
 }
 
 static void snmp6_seq_show_item64(struct seq_file *seq, void __percpu *mib,
 				  const struct snmp_mib *itemlist, size_t syncpoff)
 {
+	u64 buff64[SNMP_MIB_MAX];
 	int i;
 
+	memset(buff64, 0, sizeof(unsigned long) * SNMP_MIB_MAX);
+
+	snmp_get_cpu_field64_batch(buff64, itemlist, mib, syncpoff);
 	for (i = 0; itemlist[i].name; i++)
-		seq_printf(seq, "%-32s\t%llu\n", itemlist[i].name,
-			   snmp_fold_field64(mib, itemlist[i].entry, syncpoff));
+		seq_printf(seq, "%-32s\t%llu\n", itemlist[i].name, buff64[i]);
 }
 
 static int snmp6_seq_show(struct seq_file *seq, void *v)
-- 
2.5.5

