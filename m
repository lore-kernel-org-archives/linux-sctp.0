From: Javier Martinez Canillas <javier@osg.samsung.com>
Date: Fri, 09 Sep 2016 12:43:19 +0000
Subject: [PATCH 7/8] sctp: use IS_ENABLED() instead of checking for built-in or module
Message-Id: <1473425000-9782-8-git-send-email-javier@osg.samsung.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1473425000-9782-1-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1473425000-9782-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>

The IS_ENABLED() macro checks if a Kconfig symbol has been enabled either
built-in or as a module, use that macro instead of open coding the same.

Using the macro makes the code more readable by helping abstract away some
of the Kconfig built-in and module enable details.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 912eb1685a5d..f99d4855d3de 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -48,7 +48,7 @@ static struct sctp_hmac sctp_hmac_list[SCTP_AUTH_NUM_HMACS] = {
 		/* id 2 is reserved as well */
 		.hmac_id = SCTP_AUTH_HMAC_ID_RESERVED_2,
 	},
-#if defined (CONFIG_CRYPTO_SHA256) || defined (CONFIG_CRYPTO_SHA256_MODULE)
+#if IS_ENABLED(CONFIG_CRYPTO_SHA256)
 	{
 		.hmac_id = SCTP_AUTH_HMAC_ID_SHA256,
 		.hmac_name = "hmac(sha256)",
-- 
2.7.4

