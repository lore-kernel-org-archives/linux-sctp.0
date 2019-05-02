From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 02 May 2019 13:48:58 +0000
Subject: [PATCH lksctp-tools] travis: add tests for building using a build dir
Message-Id: <b2ef8b66e46e4dffe7c47b76a30d9e0631f4203f.1556804896.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In the light of Issue #30.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis/linux-build.sh | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/.travis/linux-build.sh b/.travis/linux-build.sh
index c96bd11958816f0625b8ba95df6ec96b2b4124fe..97ce3cd9d003a04b0405151367eb40ce1e50b727 100755
--- a/.travis/linux-build.sh
+++ b/.travis/linux-build.sh
@@ -57,6 +57,8 @@ function download_prep_kernel()
 
 function build_lksctp()
 {
+	local use_builddir="$1"
+
 	make distclean || :
 	./bootstrap
 
@@ -65,12 +67,23 @@ function build_lksctp()
 		CFLAGS="$CFLAGS -I$KERNEL_HEADERS"
 	fi
 	export CFLAGS
-	./configure
+
+	if [ "$use_builddir" = 1 ]; then
+		mkdir build
+		pushd build
+		../configure
+	else
+		./configure
+	fi
 
 	make -j $nproc
 
 	#make -j $nproc distcheck
 
+	if [ "$use_builddir" = 1 ]; then
+		popd
+		rm -rf build
+	fi
 }
 
 trap cleanup EXIT
@@ -80,9 +93,11 @@ if [ -z "$KERNEL" ]; then
 	for ver in $VERS; do
 		git_prep_kernel "$ver"
 		build_lksctp
+		build_lksctp 1
 	done
 else
 	download_kernel "$KERNEL"
 	download_prep_kernel "$KERNEL"
 	build_lksctp
+	build_lksctp 1
 fi
-- 
2.20.1
