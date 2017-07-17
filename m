From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jul 2017 03:29:54 +0000
Subject: [PATCHv2 net-next 06/11] sctp: remove struct sctp_ecn_capable_param
Message-Id: <ec19ee88ce40e1e11b7bef6c84c1372dfebd5704.1500261974.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500261974.git.lucien.xin@gmail.com>
 <cadd1baef89e215244af82032957ccde1189bcc8.1500261974.git.lucien.xin@gmail.com>
 <0add39ae0879e3b332bafc24aa6ccdb6b0d5c85a.1500261974.git.lucien.xin@gmail.com>
 <c8cdb622f7de0edc639936e3fa15a262e92cfa66.1500261974.git.lucien.xin@gmail.com>
 <7faff4d9e2bef97652b742006c0165641ad84504.1500261974.git.lucien.xin@gmail.com>
 <6c3cea13894a96c24fb2e84fc0fab8363cb4b70f.1500261974.git.lucien.xin@gmail.com>
In-Reply-To: <6c3cea13894a96c24fb2e84fc0fab8363cb4b70f.1500261974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Remove it, there is even no places using it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 3ca3ab7..7552482 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -302,11 +302,6 @@ struct sctp_supported_addrs_param {
 	__be16 types[0];
 };
 
-/* Appendix A. ECN Capable (32768) */
-typedef struct sctp_ecn_capable_param {
-	struct sctp_paramhdr param_hdr;
-} sctp_ecn_capable_param_t;
-
 /* ADDIP Section 3.2.6 Adaptation Layer Indication */
 typedef struct sctp_adaptation_ind_param {
 	struct sctp_paramhdr param_hdr;
-- 
2.1.0

