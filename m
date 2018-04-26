From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:54 +0000
Subject: [PATCH net-next 05/13] sctp: introduce sctp_mtu_payload
Message-Id: <54cf97d9fb948489ca0dedb5087cc2a0c9233c72.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

When given a MTU, this function calculates how much payload we can carry
on it. Without a MTU, it calculates the amount of header overhead we
have.

So that when we have extra overhead, like the one added for IP options
on SELinux patches, it is easier to handle it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h | 19 +++++++++++++++++++
 net/sctp/output.c       | 25 ++++++++++---------------
 net/sctp/socket.c       |  7 ++-----
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 28b996d6349072fb031de91e10115b688d89b42d..0b98e4683f108670c65a0a7aceaf9a736d54bf29 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -607,6 +607,25 @@ static inline struct dst_entry *sctp_transport_dst_check(struct sctp_transport *
 	return t->dst;
 }
 
+/* Calculate max payload size given a MTU, or the total overhead if
+ * given MTU is zero
+ */
+static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
+				     __u32 mtu, __u32 extra)
+{
+	__u32 overhead = sizeof(struct sctphdr) + extra;
+
+	if (sp)
+		overhead += sp->pf->af->net_header_len;
+	else
+		overhead += sizeof(struct ipv6hdr);
+
+	if (WARN_ON_ONCE(mtu && mtu <= overhead))
+		mtu = overhead;
+
+	return mtu ? mtu - overhead : overhead;
+}
+
 static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
 {
 	__u32 pmtu = max_t(size_t, SCTP_TRUNC4(dst_mtu(t->dst)),
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 690d8557bb7bfe20a0a209b6c937c85c764a3bd0..bf4226c3cc1de79f2041d55a68ea53f4fd600b25 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -90,8 +90,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 {
 	struct sctp_transport *tp = packet->transport;
 	struct sctp_association *asoc = tp->asoc;
+	struct sctp_sock *sp = NULL;
 	struct sock *sk;
-	size_t overhead = sizeof(struct ipv6hdr) + sizeof(struct sctphdr);
 
 	pr_debug("%s: packet:%p vtag:0x%x\n", __func__, packet, vtag);
 	packet->vtag = vtag;
@@ -102,25 +102,20 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 
 	/* set packet max_size with pathmtu, then calculate overhead */
 	packet->max_size = tp->pathmtu;
+
 	if (asoc) {
-		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
-		struct sctp_af *af = sp->pf->af;
-
-		overhead = af->net_header_len +
-			   af->ip_options_len(asoc->base.sk);
-		overhead += sizeof(struct sctphdr);
-		packet->overhead = overhead;
-		packet->size = overhead;
-	} else {
-		packet->overhead = overhead;
-		packet->size = overhead;
-		return;
+		sk = asoc->base.sk;
+		sp = sctp_sk(sk);
 	}
+	packet->overhead = sctp_mtu_payload(sp, 0, 0);
+	packet->size = packet->overhead;
+
+	if (!asoc)
+		return;
 
 	/* update dst or transport pathmtu if in need */
-	sk = asoc->base.sk;
 	if (!sctp_transport_dst_check(tp)) {
-		sctp_transport_route(tp, NULL, sctp_sk(sk));
+		sctp_transport_route(tp, NULL, sp);
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
 	} else if (!sctp_transport_pmtu_check(tp)) {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index eeec81d5c485b86076f4e3a4f5dc01fc28fbb91b..b9d14f57146b8e551c28379e379158231fb40ae7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3234,11 +3234,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 	if (val) {
 		int min_len, max_len;
 
-		min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
-		min_len -= af->ip_options_len(sk);
-		min_len -= sizeof(struct sctphdr) +
-			   sizeof(struct sctp_data_chunk);
-
+		min_len = sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
+					   sizeof(struct sctp_data_chunk));
 		max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
 
 		if (val < min_len || val > max_len)
-- 
2.14.3

