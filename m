From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 28 Jul 2018 22:31:21 +0000
Subject: [PATCH 2/4] travis: build against multiple gcc versions
Message-Id: <79183dc4552b3c8945042af1b7aa2ea06da3ea80.1532816583.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

To improve our coverage, lets build the library against all gcc versions
that travis-ci.org provides. All of them will be using the latest kernel
version only.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis.yml | 65 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index c0fb7c68c4977c7185cd05df1b88b6d552cfa59f..6b06efc7a16ef4085091f27202b7a3832eccd405 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -6,15 +6,68 @@ addons:
 script:
   - ./.travis/linux-build.sh
 env:
-  - KERNEL=4.10
-  - KERNEL=4.11
-  - KERNEL=4.12
-  - KERNEL=4.13
-  - KERNEL=4.16
-  - KERNEL=4.17
+  global:
+    - KERNEL=4.17
+  matrix:
+    - KERNEL=4.10
+    - KERNEL=4.11
+    - KERNEL=4.12
+    - KERNEL=4.13
+    - KERNEL=4.16
+    - KERNEL=4.17
 compiler:
   - gcc
   - clang
+
+matrix:
+  include:
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - ubuntu-toolchain-r-test
+          packages:
+            - libelf-dev
+            - g++-4.9
+      env:
+        - MATRIX_EVAL="CC=gcc-4.9 && CXX=g++-4.9"
+
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - ubuntu-toolchain-r-test
+          packages:
+            - libelf-dev
+            - g++-5
+      env:
+        - MATRIX_EVAL="CC=gcc-5 && CXX=g++-5"
+
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - ubuntu-toolchain-r-test
+          packages:
+            - libelf-dev
+            - g++-6
+      env:
+        - MATRIX_EVAL="CC=gcc-6 && CXX=g++-6"
+
+    - os: linux
+      addons:
+        apt:
+          sources:
+            - ubuntu-toolchain-r-test
+          packages:
+            - libelf-dev
+            - g++-7
+      env:
+        - MATRIX_EVAL="CC=gcc-7 && CXX=g++-7"
+before_install:
+  - eval "${MATRIX_EVAL}"
+  - $CC --version
+
 notifications:
   email:
     - linux-sctp@vger.kernel.org
-- 
2.17.1

