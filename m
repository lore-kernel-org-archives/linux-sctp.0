From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:18:31 +0000
Subject: [PATCH 4/6] sctp: implement user interface definitions for STREAM-RESET
Message-Id: <49B48A87.7040303@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implementation the user interface definitions for STREAM-RESET
extension.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/user.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index b259fc5..f722c7f 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -147,6 +147,8 @@ enum sctp_optname {
 #define SCTP_GET_LOCAL_ADDRS	SCTP_GET_LOCAL_ADDRS
 	SCTP_SOCKOPT_CONNECTX, /* CONNECTX requests. */
 #define SCTP_SOCKOPT_CONNECTX	SCTP_SOCKOPT_CONNECTX
+	SCTP_RESET_STREAMS,	/* Stream Reconfiguration */
+#define SCTP_RESET_STREAMS SCTP_RESET_STREAMS
 };
 
 /*
@@ -402,6 +404,18 @@ struct sctp_authkey_event {
 
 enum { SCTP_AUTH_NEWKEY = 0, };
 
+struct sctp_stream_reset_event {
+	__u16 strrst_type;
+	__u16 strrst_flags;
+	__u32 strrst_length;
+	sctp_assoc_t strrst_assoc_id;
+};
+
+enum {
+	SCTP_STREAM_RESET_INBOUND = 0,
+	SCTP_STREAM_RESET_OUTBOUND,
+	SCTP_STREAM_RESET_FAILED,
+};
 
 /*
  * Described in Section 7.3
@@ -417,6 +431,7 @@ struct sctp_event_subscribe {
 	__u8 sctp_partial_delivery_event;
 	__u8 sctp_adaptation_layer_event;
 	__u8 sctp_authentication_event;
+	__u8 sctp_stream_reset_event;
 };
 
 /*
@@ -440,6 +455,7 @@ union sctp_notification {
 	struct sctp_adaptation_event sn_adaptation_event;
 	struct sctp_pdapi_event sn_pdapi_event;
 	struct sctp_authkey_event sn_authkey_event;
+	struct sctp_stream_reset_event sn_strrst_event;
 };
 
 /* Section 5.3.1
@@ -457,6 +473,7 @@ enum sctp_sn_type {
 	SCTP_PARTIAL_DELIVERY_EVENT,
 	SCTP_ADAPTATION_INDICATION,
 	SCTP_AUTHENTICATION_INDICATION,
+	SCTP_STREAM_RESET_EVENT,
 };
 
 /* Notification error codes used to fill up the error fields in some
@@ -758,4 +775,19 @@ typedef struct {
 	int sd;
 } sctp_peeloff_arg_t;
 
+enum sctp_strrst_flags {
+	SCTP_STREAM_RESET_IN = 1<<0,	/* Outgoing SSN Reset Request */
+	SCTP_STREAM_RESET_OUT = 1<<1,	/* Incoming SSN Reset Request */
+	SCTP_STREAM_RESET_BOTH = SCTP_STREAM_RESET_IN | SCTP_STREAM_RESET_OUT,
+	SCTP_STREAM_RESET_TSN = 1<<2,	/* SSN/TSN Reset Request */
+	SCTP_STREAM_RESET_ADD = 1<<3,	/* Add Streams */
+};
+
+struct sctp_stream_reset {
+	sctp_assoc_t strrst_assoc_id;
+	__u16 strrst_flags;
+	__u16 strrst_number_of_streams;
+	__u16 strrst_streams[];
+};
+
 #endif /* __net_sctp_user_h__ */
-- 
1.5.3.8




