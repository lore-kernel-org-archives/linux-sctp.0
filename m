From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 08:35:11 +0000
Subject: [PATCH] sctp: fix to only enable IPv6 address support on PF_INET6
Message-Id: <49DB103F.40106@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If socket is create by PF_INET type, it can not used IPv6 address
to send/recv DATA. So only enable IPv6 address support on PF_INET6
socket.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/associola.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index f4b2304..e7b69a7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -293,7 +293,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	 * told otherwise.
 	 */
 	asoc->peer.ipv4_address = 1;
-	asoc->peer.ipv6_address = 1;
+	if (asoc->base.sk->sk_family = PF_INET6)
+		asoc->peer.ipv6_address = 1;
 	INIT_LIST_HEAD(&asoc->asocs);
 
 	asoc->autoclose = sp->autoclose;
-- 
1.5.3.8




