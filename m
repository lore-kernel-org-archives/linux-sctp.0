From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Apr 2016 21:33:32 +0000
Subject: [PATCH 1/2] skbuff: export skb_gro_receive
Message-Id: <a6c5593e640a07736e094e66ba0e0ee85748ed00.1461965035.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1461965035.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1461965035.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>, Alexander Duyck <alexander.duyck@gmail.com>

sctp GSO requires it and sctp can be compiled as a module, so we need to
export this function.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7a1d48983f81e68b42e8beb664db9aef00440f13..1b05114baeb5e3aa4f333dccd24a97aff86892ec 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3435,6 +3435,7 @@ done:
 	NAPI_GRO_CB(skb)->same_flow = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(skb_gro_receive);
 
 void __init skb_init(void)
 {
-- 
2.5.0

