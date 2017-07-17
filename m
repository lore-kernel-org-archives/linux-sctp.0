From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jul 2017 03:29:52 +0000
Subject: [PATCHv2 net-next 04/11] sctp: remove the typedef sctp_hostname_param_t
Message-Id: <7faff4d9e2bef97652b742006c0165641ad84504.1500261974.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500261974.git.lucien.xin@gmail.com>
 <cadd1baef89e215244af82032957ccde1189bcc8.1500261974.git.lucien.xin@gmail.com>
 <0add39ae0879e3b332bafc24aa6ccdb6b0d5c85a.1500261974.git.lucien.xin@gmail.com>
 <c8cdb622f7de0edc639936e3fa15a262e92cfa66.1500261974.git.lucien.xin@gmail.com>
In-Reply-To: <c8cdb622f7de0edc639936e3fa15a262e92cfa66.1500261974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Remove this typedef, there is even no places using it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index d8f9d8f..c43e906 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -291,10 +291,10 @@ struct sctp_cookie_preserve_param {
 };
 
 /* Section 3.3.2.1 Host Name Address (11) */
-typedef struct sctp_hostname_param {
+struct sctp_hostname_param {
 	struct sctp_paramhdr param_hdr;
 	uint8_t hostname[0];
-} sctp_hostname_param_t;
+};
 
 /* Section 3.3.2.1 Supported Address Types (12) */
 typedef struct sctp_supported_addrs_param {
-- 
2.1.0

