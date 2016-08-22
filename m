From: Mikko Rapeli <mikko.rapeli@iki.fi>
Date: Mon, 22 Aug 2016 18:32:26 +0000
Subject: [PATCH v05 09/72] sctp.h: use __u8 and __u32 from linux/types.h
Message-Id: <1471890809-4383-10-git-send-email-mikko.rapeli@iki.fi>
List-Id: <linux-sctp.vger.kernel.org>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
In-Reply-To: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

Fixes userspace compilation errors like:

linux/sctp.h:652:2: error: unknown type name ‘uint32_t’

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/sctp.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a406adc..ab697b3 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -743,13 +743,13 @@ struct sctp_authkeyid {
  */
 struct sctp_sack_info {
 	sctp_assoc_t	sack_assoc_id;
-	uint32_t	sack_delay;
-	uint32_t	sack_freq;
+	__u32	sack_delay;
+	__u32	sack_freq;
 };
 
 struct sctp_assoc_value {
-    sctp_assoc_t            assoc_id;
-    uint32_t                assoc_value;
+	sctp_assoc_t	assoc_id;
+	__u32		assoc_value;
 };
 
 /*
@@ -819,7 +819,7 @@ struct sctp_status {
 struct sctp_authchunks {
 	sctp_assoc_t	gauth_assoc_id;
 	__u32		gauth_number_of_chunks;
-	uint8_t		gauth_chunks[];
+	__u8		gauth_chunks[];
 };
 
 /* The broken spelling has been released already in lksctp-tools header,
-- 
2.8.1

