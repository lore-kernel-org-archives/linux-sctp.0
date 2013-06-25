From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 25 Jun 2013 16:17:28 +0000
Subject: [PATCH net-next v3 4/6] net: sctp: minor: sctp_seq_dump_local_addrs add missing newline
Message-Id: <1372177050-17829-5-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372177050-17829-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1372177050-17829-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

A trailing newline has been forgotten to add into the WARN().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 0c83162..62526c4 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -138,7 +138,7 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
 
 		peer = asoc->peer.primary_path;
 		if (unlikely(peer = NULL)) {
-			WARN(1, "Association %p with NULL primary path!", asoc);
+			WARN(1, "Association %p with NULL primary path!\n", asoc);
 			return;
 		}
 
-- 
1.7.11.7

