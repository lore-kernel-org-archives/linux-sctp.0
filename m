From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 31 Jul 2018 17:44:11 +0000
Subject: [PATCH v2] travis: add support for building against Linus master
Message-Id: <2220f27a907e8761cf274b92a5d7568e178f1fca.1533059016.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

So we can catch build errors before GA.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

v2: use unzip -q, otherwise it lists all unpacked files.

 .travis.yml            |  3 ++-
 .travis/linux-build.sh | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 8416b621a6f486469cef8fbb61e3d782674a4978..ee4653424ac202f3024dd8ea2a9a1210590dee8d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -7,7 +7,7 @@ script:
   - ./.travis/linux-build.sh
 env:
   global:
-    - KERNEL=4.17
+    - KERNEL=master
   matrix:
     - KERNEL=4.10
     - KERNEL=4.11
@@ -15,6 +15,7 @@ env:
     - KERNEL=4.13
     - KERNEL=4.16
     - KERNEL=4.17
+    - KERNEL=master
 compiler:
   - gcc
   - clang
diff --git a/.travis/linux-build.sh b/.travis/linux-build.sh
index e1874f3e16fb86ab86d7796b6c807b791b584e95..01b0a9468a96cf5c7b23b16cd90d371982dbf5c8 100755
--- a/.travis/linux-build.sh
+++ b/.travis/linux-build.sh
@@ -7,9 +7,15 @@ nproc=$(/usr/bin/getconf _NPROCESSORS_ONLN)
 function install_kernel()
 {
 	VER="$1"
-	URL="https://www.kernel.org/pub/linux/kernel/v4.x/linux-$VER.tar.xz"
-	wget "$URL"
-	tar xf "linux-$VER.tar.xz"
+	if [ "$VER" = "master" ]; then
+		URL="https://codeload.github.com/marceloleitner/linux/zip/master"
+		wget "$URL"
+		unzip -q master
+	else
+		URL="https://www.kernel.org/pub/linux/kernel/v4.x/linux-$VER.tar.xz"
+		wget "$URL"
+		tar xf "linux-$VER.tar.xz"
+	fi
 
 	pushd "linux-$VER"
 	make allmodconfig
-- 
2.17.1

