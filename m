From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 20 Jun 2008 13:39:28 +0000
Subject: [PATCH net-next] sctp: Kill unused variable in sctp_assoc_bh_rcv()
Message-Id: <12139691681334-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/associola.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index ff1dc5b..35b6a02 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1025,7 +1025,6 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 	struct sctp_chunk *chunk;
 	struct sock *sk;
 	struct sctp_inq *inqueue;
-	struct sctp_outq *outq;
 	int state;
 	sctp_subtype_t subtype;
 	int error = 0;
-- 
1.5.2.5

