From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 03:16:34 +0000
Subject: [PATCH lksctp-tools 1/2] travis: use parallel build
Message-Id: <37a979af27150a7214ea8612d94f3f66b7b04f6a.1525835560.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis.yml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index f76dd4249613db1a5bf59b451fd75541207409f1..c67a815612d6202601b6605cae680bb0e558bba0 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,6 +1,8 @@
 language: c
 script:
-  - ./bootstrap && ./configure && make
+  - ./bootstrap
+    && ./configure
+    && make -j `/usr/bin/getconf _NPROCESSORS_ONLN`
   # ipv6 is not supported by Travis
   - make -C src/func_tests/ v4test
 compiler:
-- 
2.14.3

