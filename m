From: Matthias Maennich <maennich@google.com>
Date: Thu, 28 Feb 2019 11:36:52 +0000
Subject: [PATCH] sctp: chunk.c: correct format string for size_t in printk
Message-Id: <20190228113652.55552-1-maennich@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Matthias Maennich <maennich@google.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

According to Documentation/core-api/printk-formats.rst, size_t should be
printed with %zu, rather than %Zu.

In addition, using %Zu triggers a warning on clang (-Wformat-extra-args):

net/sctp/chunk.c:196:25: warning: data argument not used by format string [-Wformat-extra-args]
                                    __func__, asoc, max_data);
                                    ~~~~~~~~~~~~~~~~^~~~~~~~~
./include/linux/printk.h:440:49: note: expanded from macro 'pr_warn_ratelimited'
        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
./include/linux/printk.h:424:17: note: expanded from macro 'printk_ratelimited'
                printk(fmt, ##__VA_ARGS__);                             \
                       ~~~    ^

Fixes: 5b5e0928f742 ("lib/vsprintf.c: remove %Z support")
Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 net/sctp/chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 64bef313d436..5cb7c1ff97e9 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -192,7 +192,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	if (unlikely(!max_data)) {
 		max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
 					       sctp_datachk_len(&asoc->stream));
-		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%Zu)",
+		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%zu)",
 				    __func__, asoc, max_data);
 	}
 
-- 
2.21.0.rc2.261.ga7da99ff1b-goog
