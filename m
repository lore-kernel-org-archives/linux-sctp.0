From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 01 Jul 2013 16:10:36 +0000
Subject: [PATCH net-next] net: sctp: prevent checksum.h from double inclusion
Message-Id: <1372695036-10914-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

The header file checksum.h is missing proper defines that prevents
it from double inclusion.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/checksum.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index 5a2110d..0cb08e6 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -42,6 +42,9 @@
  * be incorporated into the next SCTP release.
  */
 
+#ifndef __sctp_checksum_h__
+#define __sctp_checksum_h__
+
 #include <linux/types.h>
 #include <net/sctp/sctp.h>
 #include <linux/crc32c.h>
@@ -81,3 +84,5 @@ static inline __le32 sctp_end_cksum(__u32 crc32)
 {
 	return cpu_to_le32(~crc32);
 }
+
+#endif /* __sctp_checksum_h__ */
-- 
1.7.11.7

