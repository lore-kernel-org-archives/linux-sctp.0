From: Karl Heiss <kheiss@gmail.com>
Date: Thu, 24 Sep 2015 16:15:06 +0000
Subject: [PATCH net 1/2] sctp: Whitespace fix
Message-Id: <1443111307-16503-2-git-send-email-kheiss@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Fix indentation in sctp_generate_heartbeat_event.

Signed-off-by: Karl Heiss <kheiss@gmail.com>
---
 net/sctp/sm_sideeffect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 35df126..f554b9a 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -388,8 +388,8 @@ void sctp_generate_heartbeat_event(unsigned long data)
 			   asoc->state, asoc->ep, asoc,
 			   transport, GFP_ATOMIC);
 
-	 if (error)
-		 asoc->base.sk->sk_err = -error;
+	if (error)
+		asoc->base.sk->sk_err = -error;
 
 out_unlock:
 	bh_unlock_sock(asoc->base.sk);
-- 
1.7.1

