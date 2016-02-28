From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 28 Feb 2016 02:33:11 +0000
Subject: [PATCH net] sctp: sctp_remaddr_seq_show use the wrong variable to dump transport info
Message-Id: <08f9ec3d48c3fffd7224e6eb0c129ed113d23fbd.1456626791.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

Now in sctp_remaddr_seq_show(), we use variable *tsp to get the param *v.
but *tsp is also used to traversal transport_addr_list, which will cover
the previous value, and make sctp_transport_put work on the wrong transport.

So fix it by adding a new variable to get the param *v.

Fixes: fba4c330c5b9 ("sctp: hold transport before we access t->asoc in sctp proc")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/proc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index ded7d93..963dffc 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -482,7 +482,7 @@ static void sctp_remaddr_seq_stop(struct seq_file *seq, void *v)
 static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 {
 	struct sctp_association *assoc;
-	struct sctp_transport *tsp;
+	struct sctp_transport *transport, *tsp;
 
 	if (v = SEQ_START_TOKEN) {
 		seq_printf(seq, "ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX "
@@ -490,10 +490,10 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 		return 0;
 	}
 
-	tsp = (struct sctp_transport *)v;
-	if (!sctp_transport_hold(tsp))
+	transport = (struct sctp_transport *)v;
+	if (!sctp_transport_hold(transport))
 		return 0;
-	assoc = tsp->asoc;
+	assoc = transport->asoc;
 
 	list_for_each_entry_rcu(tsp, &assoc->peer.transport_addr_list,
 				transports) {
@@ -546,7 +546,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 
-	sctp_transport_put(tsp);
+	sctp_transport_put(transport);
 
 	return 0;
 }
-- 
2.1.0

