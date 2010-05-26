From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 26 May 2010 09:51:03 +0000
Subject: [PATCH 1/4] sctp:  kill unused variable in __sctp_rcv_init_lookup()
Message-Id: <4BFCEF07.8060101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Remove "ch" variable as it never be used.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/input.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index dc421d5..9b1dde5 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -942,14 +942,11 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct sk_buff *skb,
 	union sctp_addr addr;
 	union sctp_addr *paddr = &addr;
 	struct sctphdr *sh = sctp_hdr(skb);
-	sctp_chunkhdr_t *ch;
 	union sctp_params params;
 	sctp_init_chunk_t *init;
 	struct sctp_transport *transport;
 	struct sctp_af *af;
 
-	ch = (sctp_chunkhdr_t *) skb->data;
-
 	/*
 	 * This code will NOT touch anything inside the chunk--it is
 	 * strictly READ-ONLY.
-- 
1.7.0





