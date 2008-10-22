From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 22 Oct 2008 02:08:44 +0000
Subject: [PATCH 1/4] sctp: Drop ICMP packet too big message with MTU larger than current PMTU
Message-Id: <1224641327-11913-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1224641327-11913-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1224641327-11913-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If ICMP packet too big message is received with MTU larger than current
PMTU, SCTP will still accept this ICMP message and sync the PMTU of assoc
with the wrong MTU.

Endpoing A                 Endpoint B
(ESTABLISHED)              (ESTABLISHED)
ICMP         --------->
(packet too big, MTU too larger)
                           sync PMTU

This patch fixed the problem by drop that ICMP message.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index a49fa80..bf612d9 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -369,7 +369,7 @@ static void sctp_add_backlog(struct sock *sk, struct sk_buff *skb)
 void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 			   struct sctp_transport *t, __u32 pmtu)
 {
-	if (!t || (t->pathmtu = pmtu))
+	if (!t || (t->pathmtu <= pmtu))
 		return;
 
 	if (sock_owned_by_user(sk)) {
-- 
1.5.3.5

