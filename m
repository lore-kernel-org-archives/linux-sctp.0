From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 27 Feb 2013 19:43:51 +0000
Subject: [PATCH] net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS control message
Message-Id: <1361994231-5355-1-git-send-email-linux@roeck-us.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Guenter Roeck <linux@roeck-us.net>

Building sctp may fail with:

In function ‘copy_from_user’,
    inlined from ‘sctp_getsockopt_assoc_stats’ at
    net/sctp/socket.c:5656:20:
arch/x86/include/asm/uaccess_32.h:211:26: error: call to
    ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
    buffer size is not provably correct

if built with W=1 due to a missing parameter size validation.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 net/sctp/socket.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cedd9bf..0a5f2bf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5652,6 +5652,8 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 	/* User must provide at least the assoc id */
 	if (len < sizeof(sctp_assoc_t))
 		return -EINVAL;
+	if (len > sizeof(struct sctp_assoc_stats))
+		len = sizeof(struct sctp_assoc_stats);
 
 	if (copy_from_user(&sas, optval, len))
 		return -EFAULT;
-- 
1.7.9.7

