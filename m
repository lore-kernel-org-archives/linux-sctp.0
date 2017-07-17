From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jul 2017 03:29:53 +0000
Subject: [PATCHv2 net-next 05/11] sctp: remove the typedef sctp_supported_addrs_param_t
Message-Id: <6c3cea13894a96c24fb2e84fc0fab8363cb4b70f.1500261974.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500261974.git.lucien.xin@gmail.com>
 <cadd1baef89e215244af82032957ccde1189bcc8.1500261974.git.lucien.xin@gmail.com>
 <0add39ae0879e3b332bafc24aa6ccdb6b0d5c85a.1500261974.git.lucien.xin@gmail.com>
 <c8cdb622f7de0edc639936e3fa15a262e92cfa66.1500261974.git.lucien.xin@gmail.com>
 <7faff4d9e2bef97652b742006c0165641ad84504.1500261974.git.lucien.xin@gmail.com>
In-Reply-To: <7faff4d9e2bef97652b742006c0165641ad84504.1500261974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to remove the typedef sctp_supported_addrs_param_t, and
replace with struct sctp_supported_addrs_param in the places where it's
using this typedef.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     | 4 ++--
 net/sctp/sm_make_chunk.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index c43e906..3ca3ab7 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -297,10 +297,10 @@ struct sctp_hostname_param {
 };
 
 /* Section 3.3.2.1 Supported Address Types (12) */
-typedef struct sctp_supported_addrs_param {
+struct sctp_supported_addrs_param {
 	struct sctp_paramhdr param_hdr;
 	__be16 types[0];
-} sctp_supported_addrs_param_t;
+};
 
 /* Appendix A. ECN Capable (32768) */
 typedef struct sctp_ecn_capable_param {
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e5be305..fb06d4f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -223,7 +223,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	struct sctp_chunk *retval = NULL;
 	int num_types, addrs_len = 0;
 	struct sctp_sock *sp;
-	sctp_supported_addrs_param_t sat;
+	struct sctp_supported_addrs_param sat;
 	__be16 types[2];
 	sctp_adaptation_ind_param_t aiparam;
 	sctp_supported_ext_param_t ext_param;
-- 
2.1.0

