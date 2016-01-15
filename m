From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 15 Jan 2016 13:44:31 +0000
Subject: [PATCH] net: sctp: Move sequence start handling into sctp_transport_get_idx()
Message-Id: <1452865471-32509-1-git-send-email-geert@linux-m68k.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

net/sctp/proc.c: In function ‘sctp_transport_get_idx’:
net/sctp/proc.c:313: warning: ‘obj’ may be used uninitialized in this function

This is currently a false positive, as all callers check for a zero
offset first, and handle this case in the exact same way.

Move the check and handling into sctp_transport_get_idx() to kill the
compiler warning, and avoid future bugs.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.
---
 net/sctp/proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index dfa7eeccb5373053..684c5b31563badc1 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -310,7 +310,7 @@ static struct sctp_transport *sctp_transport_get_next(struct seq_file *seq)
 static struct sctp_transport *sctp_transport_get_idx(struct seq_file *seq,
 						     loff_t pos)
 {
-	void *obj;
+	void *obj = SEQ_START_TOKEN;
 
 	while (pos && (obj = sctp_transport_get_next(seq)) && !IS_ERR(obj))
 		pos--;
@@ -347,7 +347,7 @@ static void *sctp_assocs_seq_start(struct seq_file *seq, loff_t *pos)
 	if (err)
 		return ERR_PTR(err);
 
-	return *pos ? sctp_transport_get_idx(seq, *pos) : SEQ_START_TOKEN;
+	return sctp_transport_get_idx(seq, *pos);
 }
 
 static void sctp_assocs_seq_stop(struct seq_file *seq, void *v)
@@ -462,7 +462,7 @@ static void *sctp_remaddr_seq_start(struct seq_file *seq, loff_t *pos)
 	if (err)
 		return ERR_PTR(err);
 
-	return *pos ? sctp_transport_get_idx(seq, *pos) : SEQ_START_TOKEN;
+	return sctp_transport_get_idx(seq, *pos);
 }
 
 static void *sctp_remaddr_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-- 
1.9.1

