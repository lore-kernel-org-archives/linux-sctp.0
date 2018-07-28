From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 28 Jul 2018 22:31:23 +0000
Subject: [PATCH 4/4] travis: only send notifications if build status changed
Message-Id: <35eff65055194ac7a89c211967ce3435e0ca3513.1532816583.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Less emails..

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .travis.yml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index eb636e18c7e3a2c85201b7c5bb235ac0cbed7d7b..8416b621a6f486469cef8fbb61e3d782674a4978 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -106,4 +106,6 @@ before_install:
 
 notifications:
   email:
-    - linux-sctp@vger.kernel.org
+    on_success: change
+    on_failure: change
+    recipients: linux-sctp@vger.kernel.org
-- 
2.17.1

