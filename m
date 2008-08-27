From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 27 Aug 2008 08:29:17 +0000
Subject: [PATCH] sctp: Drop ICMP packet too big message with MTU larger than
Message-Id: <48B5105D.7050708@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If ICMP packet too big message is received with MTU larger than current
PMTU, SCTP will still accept this ICMPv6 message and sync the PMTU of
assoc with the wrong MTU.

Endpoing A                 Endpoint B
(ESTABLISHED)              (ESTABLISHED)
ICMP         --------->
(packet too big)
                            sync PMTU

This patch fixed the problem by drop that ICMP message.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
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
1.5.3.8



