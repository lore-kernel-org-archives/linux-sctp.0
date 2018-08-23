From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 23 Aug 2018 17:13:32 +0000
Subject: [PATCH lksctp-tools] build: fix netinet/sctp.h not to be installed
Message-Id: <16d4fc6998450e9aba61259a1ee4869df841cc6c.1535044412.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

After libcnetinet_HEADERS was set to sctp.h.in, netinet/sctp.h can
no longer be installed into ${includedir}.

Since "AC_CONFIG_HEADERS([src/include/netinet/sctp.h])" is already
added into configure.ac, there's no need to generate sctp.h by
automake.

So we simply set libcnetinet_HEADERS back to sctp.h.

Fixes: 9607dd85e70a ("netinet/sctp.h: dynamically build based on system setup")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/include/netinet/Makefile.am | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/include/netinet/Makefile.am b/src/include/netinet/Makefile.am
index ca0aac2..965db8c 100644
--- a/src/include/netinet/Makefile.am
+++ b/src/include/netinet/Makefile.am
@@ -11,5 +11,4 @@ libcnetinetdir = $(includedir)/netinet
 # API.
 include_HEADERS  
-libcnetinet_HEADERS = sctp.h.in
-BUILT_SOURCES = sctp.h
+libcnetinet_HEADERS = sctp.h
-- 
2.1.0
