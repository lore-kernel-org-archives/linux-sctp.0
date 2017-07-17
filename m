From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jul 2017 03:29:50 +0000
Subject: [PATCHv2 net-next 02/11] sctp: remove the typedef sctp_ipv6addr_param_t
Message-Id: <0add39ae0879e3b332bafc24aa6ccdb6b0d5c85a.1500261974.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500261974.git.lucien.xin@gmail.com>
 <cadd1baef89e215244af82032957ccde1189bcc8.1500261974.git.lucien.xin@gmail.com>
In-Reply-To: <cadd1baef89e215244af82032957ccde1189bcc8.1500261974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to remove the typedef sctp_ipv6addr_param_t, and replace
with struct sctp_ipv6addr_param in the places where it's using this
typedef.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     | 4 ++--
 net/sctp/ipv6.c          | 2 +-
 net/sctp/sm_make_chunk.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index e42095d..6b45c8a 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -279,10 +279,10 @@ struct sctp_ipv4addr_param {
 };
 
 /* Section 3.3.2.1. IPv6 Address Parameter (6) */
-typedef struct sctp_ipv6addr_param {
+struct sctp_ipv6addr_param {
 	struct sctp_paramhdr param_hdr;
 	struct in6_addr addr;
-} sctp_ipv6addr_param_t;
+};
 
 /* Section 3.3.2.1 Cookie Preservative (9) */
 typedef struct sctp_cookie_preserve_param {
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 2a186b20..107d7c9 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -497,7 +497,7 @@ static void sctp_v6_from_addr_param(union sctp_addr *addr,
 static int sctp_v6_to_addr_param(const union sctp_addr *addr,
 				 union sctp_addr_param *param)
 {
-	int length = sizeof(sctp_ipv6addr_param_t);
+	int length = sizeof(struct sctp_ipv6addr_param);
 
 	param->v6.param_hdr.type = SCTP_PARAM_IPV6_ADDRESS;
 	param->v6.param_hdr.length = htons(length);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 0dc64da..e5be305 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3163,7 +3163,7 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 			addr_param_seen = true;
 			break;
 		case SCTP_PARAM_IPV6_ADDRESS:
-			if (length != sizeof(sctp_ipv6addr_param_t))
+			if (length != sizeof(struct sctp_ipv6addr_param))
 				return false;
 			if (param.v != addip->addip_hdr.params)
 				return false;
-- 
2.1.0

