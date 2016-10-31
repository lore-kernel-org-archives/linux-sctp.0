From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 31 Oct 2016 12:32:32 +0000
Subject: [PATCHv2 net 2/3] sctp: return back transport in __sctp_rcv_init_lookup
Message-Id: <8d72a86988a2c16c74c45c52dafbf2bbbe9c3b4d.1477916928.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1477916928.git.lucien.xin@gmail.com>
 <a58ed3a60643e38876a12ed9193e60f7b38cba4d.1477916928.git.lucien.xin@gmail.com>
In-Reply-To: <a58ed3a60643e38876a12ed9193e60f7b38cba4d.1477916928.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Prior to this patch, it used a local variable to save the transport that is
looked up by __sctp_lookup_association(), and didn't return it back. But in
sctp_rcv, it is used to initialize chunk->transport. So when hitting this,
even if it found the transport, it was still initializing chunk->transport
with null instead.

This patch is to return the transport back through transport pointer
that is from __sctp_rcv_lookup_harder().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index a2ea1d1..8e0bc58 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1021,7 +1021,6 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 	struct sctphdr *sh = sctp_hdr(skb);
 	union sctp_params params;
 	sctp_init_chunk_t *init;
-	struct sctp_transport *transport;
 	struct sctp_af *af;
 
 	/*
@@ -1052,7 +1051,7 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 
 		af->from_addr_param(paddr, params.addr, sh->source, 0);
 
-		asoc = __sctp_lookup_association(net, laddr, paddr, &transport);
+		asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
 		if (asoc)
 			return asoc;
 	}
-- 
2.1.0

