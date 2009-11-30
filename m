From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Mon, 30 Nov 2009 09:52:50 +0000
Subject: [PATCH] sctp: fix sctp_setsockopt_autoclose compile warning
Message-Id: <20091130095250.GZ10897@shell.iptel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au> <20091130094929.GY10897@shell.iptel.org>
In-Reply-To: <20091130094929.GY10897@shell.iptel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org

Fix the following warning, when building on 64 bits:

net/sctp/socket.c:2091: warning: large integer implicitly
                        truncated to unsigned type

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 net/sctp/socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 71513b3..8961863 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2088,7 +2088,7 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EFAULT;
 	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
 	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
-		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
+		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
 
 	return 0;
 }
-- 
1.6.5.3

