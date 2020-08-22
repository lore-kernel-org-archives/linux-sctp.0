From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:15:56 +0000
Subject: [PATCH 2/7] net: sctp: auth.c: delete duplicated words
Message-Id: <20200822231601.32125-3-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated word "the" and "now".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/auth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/sctp/auth.c
+++ linux-next-20200731/net/sctp/auth.c
@@ -445,7 +445,7 @@ struct sctp_shared_key *sctp_auth_get_sh
 }
 
 /*
- * Initialize all the possible digest transforms that we can use.  Right now
+ * Initialize all the possible digest transforms that we can use.  Right
  * now, the supported digests are SHA1 and SHA256.  We do this here once
  * because of the restrictiong that transforms may only be allocated in
  * user context.  This forces us to pre-allocated all possible transforms
@@ -810,7 +810,7 @@ int sctp_auth_ep_set_hmacs(struct sctp_e
 }
 
 /* Set a new shared key on either endpoint or association.  If the
- * the key with a same ID already exists, replace the key (remove the
+ * key with a same ID already exists, replace the key (remove the
  * old key and add a new one).
  */
 int sctp_auth_set_key(struct sctp_endpoint *ep,
