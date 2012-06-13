From: Peter Meerwald <pmeerw@pmeerw.net>
Date: Wed, 13 Jun 2012 14:53:20 +0000
Subject: [PATCH] sctp: typo, fix destructruction
Message-Id: <1339599200-24265-1-git-send-email-pmeerw@pmeerw.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

---
 net/sctp/chunk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 6c85564..d7c4d83 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -90,7 +90,7 @@ void sctp_datamsg_free(struct sctp_datamsg *msg)
 	sctp_datamsg_put(msg);
 }
 
-/* Final destructruction of datamsg memory. */
+/* Final destruction of datamsg memory. */
 static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 {
 	struct list_head *pos, *temp;
-- 
1.7.5.4

