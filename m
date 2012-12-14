From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 14 Dec 2012 18:51:00 +0000
Subject: [PATCH] sctp: Change defaults on cookie hmac selection
Message-Id: <1355511060-27320-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

Recently I posted commit 3c68198e75 which made selection of the cookie hmac
algorithm selectable.  This is all well and good, but Linus noted that it
changes the default config:
http://marc.info/?l=linux-netdev&m5536629004808&w=2

I've modified the sctp Kconfig file to reflect the recommended way of making
this choice, using the thermal driver example specified, and brought the
defaults back into line with the way they were prior to my origional patch

Tested by myself (allbeit fairly quickly).  All configuration combinations seems
to work soundly.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: linux-sctp@vger.kernel.org
---
 net/sctp/Kconfig | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index a9edd2e..7cd47be 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -66,12 +66,31 @@ config SCTP_DBG_OBJCNT
 	  'cat /proc/net/sctp/sctp_dbg_objcnt'
 
 	  If unsure, say N
+choice
+	prompt "Default SCTP cookie HMAC encoding"
+	default SCTP_COOKIE_HMAC_MD5
+	help
+	  This option sets the default sctp cookie hmac algorithm
+	  when in doubt select 'md5'
+
+config SCTP_DEFAULT_COOKIE_HMAC_MD5
+	bool "Enable optional MD5 hmac cookie generation"
+	help
+	  Enable optional MD5 hmac based SCTP cookie generation
+	select SCTP_COOKIE_HMAC_MD5
+
+config SCTP_DEFAULT_COOKIE_HMAC_SHA1
+	bool "Enable optional SHA1 hmac cookie generation"
+	help
+	  Enable optional SHA1 hmac based SCTP cookie generation
+	select SCTP_COOKIE_HMAC_SHA1
+
+endchoice
 
 config SCTP_COOKIE_HMAC_MD5
 	bool "Enable optional MD5 hmac cookie generation"
 	help
 	  Enable optional MD5 hmac based SCTP cookie generation
-	default y
 	select CRYPTO_HMAC if SCTP_COOKIE_HMAC_MD5
 	select CRYPTO_MD5 if SCTP_COOKIE_HMAC_MD5
 
@@ -79,7 +98,6 @@ config SCTP_COOKIE_HMAC_SHA1
 	bool "Enable optional SHA1 hmac cookie generation"
 	help
 	  Enable optional SHA1 hmac based SCTP cookie generation
-	default y
 	select CRYPTO_HMAC if SCTP_COOKIE_HMAC_SHA1
 	select CRYPTO_SHA1 if SCTP_COOKIE_HMAC_SHA1
 
-- 
1.7.11.7

