From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 13 Jul 2016 18:08:59 +0000
Subject: [PATCH net-next 5/6] sctp: do not clear chunk->ecn_ce_done flag
Message-Id: <349cf5fdf54449cf16097503d5200f60ae388a65.1468432819.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1468432819.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1468432819.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

We should not clear that flag when switching to a new skb from a GSO skb
because it would cause ECN processing to happen multiple times per GSO
skb, which is not wanted. Instead, let it be processed once per chunk.
That is, in other words, once per IP header available.

Fixes: 90017accff61 ("sctp: Add GSO support")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/inqueue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 8fc773f9b59a8a9ad123dd132cfa5b7f916732b6..942770675f4cc0efc9686f4e4038450f060f34ae 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -217,7 +217,6 @@ new_skb:
 		chunk->auth = 0;
 		chunk->has_asconf = 0;
 		chunk->end_of_packet = 0;
-		chunk->ecn_ce_done = 0;
 		if (chunk->head_skb) {
 			struct sctp_input_cb
 				*cb = SCTP_INPUT_CB(chunk->skb),
-- 
2.7.4

