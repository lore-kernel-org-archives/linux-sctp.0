From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 18 Apr 2011 03:28:01 +0000
Subject: [PATCH net-next-2.6 2/3] sctp: change auth event type name to SCTP_AUTHENTICATION_EVENT
Message-Id: <4DABAFC1.7040105@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DABAEF1.1010506@cn.fujitsu.com>
In-Reply-To: <4DABAEF1.1010506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

This patch change the auth event type name to SCTP_AUTHENTICATION_EVENT,
which is based on API extension compliance.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 include/net/sctp/user.h |    3 ++-
 net/sctp/ulpevent.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 793617e..4525d8c 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -408,7 +408,8 @@ enum sctp_sn_type {
 	SCTP_SHUTDOWN_EVENT,
 	SCTP_PARTIAL_DELIVERY_EVENT,
 	SCTP_ADAPTATION_INDICATION,
-	SCTP_AUTHENTICATION_INDICATION,
+	SCTP_AUTHENTICATION_EVENT,
+#define SCTP_AUTHENTICATION_INDICATION	SCTP_AUTHENTICATION_EVENT
 };
 
 /* Notification error codes used to fill up the error fields in some
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index dff27d5..62d4a7b 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -843,7 +843,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_authkey(
 	ak = (struct sctp_authkey_event *)
 		skb_put(skb, sizeof(struct sctp_authkey_event));
 
-	ak->auth_type = SCTP_AUTHENTICATION_INDICATION;
+	ak->auth_type = SCTP_AUTHENTICATION_EVENT;
 	ak->auth_flags = 0;
 	ak->auth_length = sizeof(struct sctp_authkey_event);
 
-- 
1.6.5.2


