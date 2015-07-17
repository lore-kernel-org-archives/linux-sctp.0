From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 17 Jul 2015 16:50:21 +0000
Subject: [PATCH] sctp: fix cut and paste issue in comment
Message-Id: <c77ce1886beb4879f76bf7ca47b0d801609296df.1437151659.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Cookie ACK is always received by the association initiator, so fix the
comment to avoid confusion.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3ee27b7704ffb95430541507e83973e9207f9672..d7eaa7354cf76148d1a2c9ee3af4fff9a24990fb 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -853,7 +853,7 @@ nomem:
 
 /*
  * Respond to a normal COOKIE ACK chunk.
- * We are the side that is being asked for an association.
+ * We are the side that is asking for an association.
  *
  * RFC 2960 5.1 Normal Establishment of an Association
  *
-- 
2.4.1

