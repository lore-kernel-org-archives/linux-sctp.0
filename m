From: Mikko Rapeli <mikko.rapeli@iki.fi>
Date: Sat, 30 May 2015 15:38:17 +0000
Subject: [PATCH 25/98] sctp.h: use __u8 and __u32 from linux/types.h
Message-Id: <1433000370-19509-26-git-send-email-mikko.rapeli@iki.fi>
List-Id: <linux-sctp.vger.kernel.org>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, linux-api@vger.kernel.org

Fixes userspace compilation errors like:

linux/sctp.h:652:2: error: unknown type name ‘uint32_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/sctp.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index ce70fe6..dd0a9c2 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -718,13 +718,13 @@ struct sctp_authkeyid {
  */
 struct sctp_sack_info {
 	sctp_assoc_t	sack_assoc_id;
-	uint32_t	sack_delay;
-	uint32_t	sack_freq;
+	__u32	sack_delay;
+	__u32	sack_freq;
 };
 
 struct sctp_assoc_value {
     sctp_assoc_t            assoc_id;
-    uint32_t                assoc_value;
+    __u32                assoc_value;
 };
 
 /*
@@ -794,7 +794,7 @@ struct sctp_status {
 struct sctp_authchunks {
 	sctp_assoc_t	gauth_assoc_id;
 	__u32		gauth_number_of_chunks;
-	uint8_t		gauth_chunks[];
+	__u8		gauth_chunks[];
 };
 
 /* The broken spelling has been released already in lksctp-tools header,
-- 
2.1.4

