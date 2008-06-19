From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 19 Jun 2008 22:24:40 +0000
Subject: [PATCH net-next 1/2] sctp: Validate Initiate Tag when handling ICMP message
Message-Id: <1213914282357-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

This patch add to validate initiate tag and chunk type if verification
tag is 0 when handling ICMP message.

RFC 4960, Appendix C. ICMP Handling

ICMP6) An implementation MUST validate that the Verification Tag
contained in the ICMP message matches the Verification Tag of the peer.
If the Verification Tag is not 0 and does NOT match, discard the ICMP
message.  If it is 0 and the ICMP message contains enough bytes to
verify that the chunk type is an INIT chunk and that the Initiate Tag
matches the tag of the peer, continue with ICMP7.  If the ICMP message
is too short or the chunk type or the Initiate Tag does not match,
silently discard the packet.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/input.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index ca6b022..d354a23 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -430,6 +430,9 @@ struct sock *sctp_err_lookup(int family, struct sk_buff *skb,
 	struct sock *sk = NULL;
 	struct sctp_association *asoc;
 	struct sctp_transport *transport = NULL;
+	struct sctp_init_chunk *chunkhdr;
+	__u32 vtag = ntohl(sctphdr->vtag);
+	int len = skb->len - ((void *)sctphdr - (void *)skb->data);
 
 	*app = NULL; *tpp = NULL;
 
@@ -451,8 +454,28 @@ struct sock *sctp_err_lookup(int family, struct sk_buff *skb,
 
 	sk = asoc->base.sk;
 
-	if (ntohl(sctphdr->vtag) != asoc->c.peer_vtag) {
-		ICMP_INC_STATS_BH(ICMP_MIB_INERRORS);
+	/* RFC 4960, Appendix C. ICMP Handling
+	 *
+	 * ICMP6) An implementation MUST validate that the Verification Tag
+	 * contained in the ICMP message matches the Verification Tag of
+	 * the peer.  If the Verification Tag is not 0 and does NOT
+	 * match, discard the ICMP message.  If it is 0 and the ICMP
+	 * message contains enough bytes to verify that the chunk type is
+	 * an INIT chunk and that the Initiate Tag matches the tag of the
+	 * peer, continue with ICMP7.  If the ICMP message is too short
+	 * or the chunk type or the Initiate Tag does not match, silently
+	 * discard the packet.
+	 */
+	if (vtag = 0) {
+		chunkhdr = (struct sctp_init_chunk *)((void *)sctphdr
+				+ sizeof(struct sctphdr));
+		if (len < sizeof(struct sctphdr) + sizeof(sctp_chunkhdr_t)
+			  + sizeof(__be32) ||
+		    chunkhdr->chunk_hdr.type != SCTP_CID_INIT ||
+		    ntohl(chunkhdr->init_hdr.init_tag) != asoc->c.my_vtag) {
+			goto out;
+		}
+	} else if (vtag != asoc->c.peer_vtag) {
 		goto out;
 	}
 
-- 
1.5.2.5

