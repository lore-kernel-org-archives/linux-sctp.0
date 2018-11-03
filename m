From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 03 Nov 2018 05:59:45 +0000
Subject: [PATCH net] sctp: fix strchange_flags name for Stream Change Event
Message-Id: <34b8e0475a841d258c2165b5a46a72c373e52976.1541224785.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

As defined in rfc6525#section-6.1.3, SCTP_STREAM_CHANGE_DENIED
and SCTP_STREAM_CHANGE_FAILED should be used instead of
SCTP_ASSOC_CHANGE_DENIED and SCTP_ASSOC_CHANGE_FAILED.

To keep the compatibility, fix it by adding two macros.

Fixes: b444153fb5a6 ("sctp: add support for generating add stream change event notification")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 34dd3d4..680ecc3 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -568,6 +568,8 @@ struct sctp_assoc_reset_event {
 
 #define SCTP_ASSOC_CHANGE_DENIED	0x0004
 #define SCTP_ASSOC_CHANGE_FAILED	0x0008
+#define SCTP_STREAM_CHANGE_DENIED	SCTP_ASSOC_CHANGE_DENIED
+#define SCTP_STREAM_CHANGE_FAILED	SCTP_ASSOC_CHANGE_FAILED
 struct sctp_stream_change_event {
 	__u16 strchange_type;
 	__u16 strchange_flags;
-- 
2.1.0
