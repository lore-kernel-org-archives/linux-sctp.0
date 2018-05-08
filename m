From: Colin King <colin.king@canonical.com>
Date: Tue, 08 May 2018 22:24:28 +0000
Subject: [PATCH] sctp: fix spelling mistake: "max_retans" -> "max_retrans"
Message-Id: <20180508222428.24874-1-colin.king@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error string

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 4d7b3ccea078..4a4fd1971255 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1131,7 +1131,7 @@ struct sctp_chunk *sctp_make_violation_max_retrans(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk)
 {
-	static const char error[] = "Association exceeded its max_retans count";
+	static const char error[] = "Association exceeded its max_retrans count";
 	size_t payload_len = sizeof(error) + sizeof(struct sctp_errhdr);
 	struct sctp_chunk *retval;
 
-- 
2.17.0

