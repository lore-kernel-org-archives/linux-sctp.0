From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:56 +0000
Subject: [PATCH lksctp-tools 05/12] netinet/sctp.h: dynamically build based on system setup
Message-Id: <e59a91df9f7dbcd3ceab24f2f3a6a823a200ee8c.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

After this patch, the exported netinet/sctp.h will be updated to reflect
the features that configure could probe on available kernel headers.

Applications should use these defines to identify what is available.

This patch only adds the structure. Subsequent patches are to add such
defines.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                              | 1 +
 src/include/netinet/Makefile.am           | 5 +++--
 src/include/netinet/{sctp.h => sctp.h.in} | 0
 3 files changed, 4 insertions(+), 2 deletions(-)
 rename src/include/netinet/{sctp.h => sctp.h.in} (100%)

diff --git a/configure.ac b/configure.ac
index 349819e1fdca716274ac4dd1b33e1c5683303c5d..9598bc83579299b1b1e68bd49cac407e3a0713fb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,7 @@ AC_FUNC_VPRINTF
 AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket \
 		strchr strerror strtol strtoul])
 
+AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
 		bin/Makefile
diff --git a/src/include/netinet/Makefile.am b/src/include/netinet/Makefile.am
index 8aa9429c4af1078cd60bc80ff84066c75f859fb6..ca0aac21f531d97fc80df152e78b8b075ce17a02 100644
--- a/src/include/netinet/Makefile.am
+++ b/src/include/netinet/Makefile.am
@@ -9,6 +9,7 @@ libcnetinetdir = $(includedir)/netinet
 
 # Supposing this is part of the development package, header for our
 # API.
-include_HEADERS = 
+include_HEADERS  
-libcnetinet_HEADERS = sctp.h
+libcnetinet_HEADERS = sctp.h.in
+BUILT_SOURCES = sctp.h
diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h.in
similarity index 100%
rename from src/include/netinet/sctp.h
rename to src/include/netinet/sctp.h.in
-- 
2.14.3

