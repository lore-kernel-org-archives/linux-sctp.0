From: yegorslists@googlemail.com
Date: Fri, 04 Mar 2016 08:42:04 +0000
Subject: [PATCH 2/2] autoconf: add m4 folder
Message-Id: <1457080924-400-1-git-send-email-yegorslists@googlemail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

This patch resolves autoconf warning about the missing m4 folder.
m4 folder is not empty and provides .gitignore file for *.m4 artefacts.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 m4/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 m4/.gitignore

diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..0f4126c
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1 @@
+*.m4
-- 
2.7.0

