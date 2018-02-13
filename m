From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Feb 2018 11:33:21 +0000
Subject: [PATCHv2 net 2/2] sctp: add file comments in diag.c
Message-Id: <7cbb050a84e55a15e3574e868f3b330a24a0d62c.1518521415.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1518521415.git.lucien.xin@gmail.com>
 <7dd7eb29395121a4855482b69bf594e0cf1db62e.1518521415.git.lucien.xin@gmail.com>
In-Reply-To: <7dd7eb29395121a4855482b69bf594e0cf1db62e.1518521415.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patch is to add the missing file comments for sctp diag file.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/diag.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a72a7d9..078f01a 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -1,3 +1,34 @@
+/* SCTP kernel implementation
+ * (C) Copyright Red Hat Inc. 2017
+ *
+ * This file is part of the SCTP kernel implementation
+ *
+ * These functions implement sctp diag support.
+ *
+ * This SCTP implementation is free software;
+ * you can redistribute it and/or modify it under the terms of
+ * the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This SCTP implementation is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; without even the implied
+ *                 ************************
+ * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with GNU CC; see the file COPYING.  If not, see
+ * <http://www.gnu.org/licenses/>.
+ *
+ * Please send any bug reports or fixes you make to the
+ * email addresched(es):
+ *    lksctp developers <linux-sctp@vger.kernel.org>
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
 #include <linux/module.h>
 #include <linux/inet_diag.h>
 #include <linux/sock_diag.h>
-- 
2.1.0

