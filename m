From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 02 May 2019 13:48:48 +0000
Subject: [PATCH lksctp-tools] travis: disable kernel retpoline
Message-Id: <6861d1450cb76484769a468b9e1f1c798a61e682.1556804893.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Because Travis compilers doesn't support it and that breaks the build
as is.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis/linux-build.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.travis/linux-build.sh b/.travis/linux-build.sh
index 746f17252992f8f80a49fd9004bc9600cc97081e..c96bd11958816f0625b8ba95df6ec96b2b4124fe 100755
--- a/.travis/linux-build.sh
+++ b/.travis/linux-build.sh
@@ -30,6 +30,8 @@ function __prep_kernel()
 {
 	make mrproper
 	make allmodconfig
+	sed -i 's/CONFIG_RETPOLINE=/# CONFIG_RETPOLINE is not set/' .config
+	make oldconfig
 	make -j $nproc modules_prepare
 	make -j $nproc headers_install
 	KERNEL_HEADERS=$(pwd)/usr/include
-- 
2.20.1
