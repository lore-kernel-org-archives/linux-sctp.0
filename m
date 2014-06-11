From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 11 Jun 2014 14:34:57 +0000
Subject: [PATCH net-next 5/5] net: sctp: fix incorrect type in gfp initializer
Message-Id: <1402497297-27100-6-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1402497297-27100-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1402497297-27100-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

This fixes the following sparse warning:

  net/sctp/associola.c:1556:29: warning: incorrect type in initializer (different base types)
  net/sctp/associola.c:1556:29:    expected bool [unsigned] [usertype] preload
  net/sctp/associola.c:1556:29:    got restricted gfp_t

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 58bbb73..9e0509c 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1591,7 +1591,7 @@ int sctp_assoc_lookup_laddr(struct sctp_association *asoc,
 /* Set an association id for a given association */
 int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 {
-	bool preload = gfp & __GFP_WAIT;
+	bool preload = !!(gfp & __GFP_WAIT);
 	int ret;
 
 	/* If the id is already assigned, keep it. */
-- 
1.7.11.7

