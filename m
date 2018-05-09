From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 03:16:35 +0000
Subject: [PATCH lksctp-tools 2/2] travis: enable email notifications
Message-Id: <947a3bba53b722f76ef68c44808c40fc778bafbb.1525835560.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis.yml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index c67a815612d6202601b6605cae680bb0e558bba0..75d07aa0640d73d12321231ecce18aa407ce15f4 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -8,3 +8,6 @@ script:
 compiler:
   - gcc
   - clang
+notifications:
+  email:
+    - linux-sctp@vger.kernel.org
-- 
2.14.3

