From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 11 Jan 2018 16:22:07 +0000
Subject: [PATCH net] sctp: removed unused var from sctp_make_auth
Message-Id: <a3ff9e23cd1c4c040c76b80196d1c3b99fe22bb6.1515687693.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_make_chunk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9bf575f2e8ed0888e0219a872e84018ada5064e0..f08531de5682256064ce35e3d44200caa71c3db8 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1273,7 +1273,6 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
 	struct sctp_authhdr auth_hdr;
 	struct sctp_hmac *hmac_desc;
 	struct sctp_chunk *retval;
-	__u8 *hmac;
 
 	/* Get the first hmac that the peer told us to use */
 	hmac_desc = sctp_auth_asoc_get_hmac(asoc);
@@ -1292,7 +1291,7 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
 	retval->subh.auth_hdr = sctp_addto_chunk(retval, sizeof(auth_hdr),
 						 &auth_hdr);
 
-	hmac = skb_put_zero(retval->skb, hmac_desc->hmac_len);
+	skb_put_zero(retval->skb, hmac_desc->hmac_len);
 
 	/* Adjust the chunk header to include the empty MAC */
 	retval->chunk_hdr->length -- 
2.14.3

