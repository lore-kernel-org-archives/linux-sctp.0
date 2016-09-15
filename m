From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 15 Sep 2016 18:02:38 +0000
Subject: [PATCH net] sctp: fix SSN comparision
Message-Id: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

This function actually operates on u32 yet its paramteres were declared
as u16, causing integer truncation upon calling.

Note in patch context that ADDIP_SERIAL_SIGN_BIT is already 32 bits.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

This issue exists since before git import, so I can't put a Fixes tag.
Also, that said, probably not worth queueing it to stable.
Thanks

 include/net/sctp/sm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index efc01743b9d641bf6b16a37780ee0df34b4ec698..bafe2a0ab9085f24e17038516c55c00cfddd02f4 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -382,7 +382,7 @@ enum {
 	ADDIP_SERIAL_SIGN_BIT = (1<<31)
 };
 
-static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
+static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
 {
 	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
 }
-- 
2.7.4

