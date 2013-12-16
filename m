From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 16 Dec 2013 17:06:44 +0000
Subject: [PATCH v2 1/2] printk: Add a pr_warn_deprecated macro
Message-Id: <1387213605-27206-2-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org

sctp has several points in its setsockopt path in which it issues deprecation
warnings.  It seems like it might be handy to macrotize such a warning so other
subsystems can use it easily

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
---
 include/linux/printk.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6949258..2e043b3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -336,6 +336,9 @@ extern asmlinkage void dump_stack(void) __cold;
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 
+#define pr_warn_deprecated(fmt, ...)					\
+	pr_warn_ratelimited("Deprecated: " fmt, ##__VA_ARGS__)
+
 #if defined(DEBUG)
 #define pr_devel_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-- 
1.8.3.1

