From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 28 Jul 2018 22:31:22 +0000
Subject: [PATCH 3/4] travis: build against multiple clang versions
Message-Id: <fb64c5eca53c693e7b1c4071611c114e6c10a8d9.1532816583.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In case we get anything odd out of it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis.yml | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index 6b06efc7a16ef4085091f27202b7a3832eccd405..eb636e18c7e3a2c85201b7c5bb235ac0cbed7d7b 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -64,6 +64,42 @@ matrix:
             - g++-7
       env:
         - MATRIX_EVAL="CC=gcc-7 && CXX=g++-7"
+
+    # works on Trusty
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - llvm-toolchain-trusty-3.9
+          packages:
+            - libelf-dev
+            - clang-3.9
+      env:
+        - MATRIX_EVAL="CC=clang-3.9 && CXX=clang++-3.9"
+
+    # works on Trusty
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - llvm-toolchain-trusty-4.0
+          packages:
+            - libelf-dev
+            - clang-4.0
+      env:
+        - MATRIX_EVAL="CC=clang-4.0 && CXX=clang++-4.0"
+
+    # works on Trusty
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - llvm-toolchain-trusty-5.0
+          packages:
+            - libelf-dev
+            - clang-5.0
+      env:
+        - MATRIX_EVAL="CC=clang-5.0 && CXX=clang++-5.0"
 before_install:
   - eval "${MATRIX_EVAL}"
   - $CC --version
-- 
2.17.1

