From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Mar 2019 09:54:54 +0000
Subject: [PATCH net 2/3] sctp: move up sctp_auth_init_hmacs() in sctp_endpoint_init()
Message-Id: <408620556c373e59442bf68f97cba3a03ac3267a.1551606805.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
 <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

sctp_auth_init_hmacs() is called only when ep->auth_enable is set.
It better to move up sctp_auth_init_hmacs() and remove auth_enable
check in it and check auth_enable only once in sctp_endpoint_init().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/auth.c        |  6 ------
 net/sctp/endpointola.c | 18 ++++++++++--------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 5b53761..39d72e5 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -471,12 +471,6 @@ int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp)
 	struct crypto_shash *tfm = NULL;
 	__u16   id;
 
-	/* If AUTH extension is disabled, we are done */
-	if (!ep->auth_enable) {
-		ep->auth_hmacs = NULL;
-		return 0;
-	}
-
 	/* If the transforms are already allocated, we are done */
 	if (ep->auth_hmacs)
 		return 0;
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 40c7eb9..0448b68 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -107,6 +107,13 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 			auth_chunks->param_hdr.length  					htons(sizeof(struct sctp_paramhdr) + 2);
 		}
+
+		/* Allocate and initialize transorms arrays for supported
+		 * HMACs.
+		 */
+		err = sctp_auth_init_hmacs(ep, gfp);
+		if (err)
+			goto nomem;
 	}
 
 	/* Initialize the base structure. */
@@ -150,15 +157,10 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	INIT_LIST_HEAD(&ep->endpoint_shared_keys);
 	null_key = sctp_auth_shkey_create(0, gfp);
 	if (!null_key)
-		goto nomem;
+		goto nomem_shkey;
 
 	list_add(&null_key->key_list, &ep->endpoint_shared_keys);
 
-	/* Allocate and initialize transorms arrays for supported HMACs. */
-	err = sctp_auth_init_hmacs(ep, gfp);
-	if (err)
-		goto nomem_hmacs;
-
 	/* Add the null key to the endpoint shared keys list and
 	 * set the hmcas and chunks pointers.
 	 */
@@ -169,8 +171,8 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 
 	return ep;
 
-nomem_hmacs:
-	sctp_auth_destroy_keys(&ep->endpoint_shared_keys);
+nomem_shkey:
+	sctp_auth_destroy_hmacs(ep->auth_hmacs);
 nomem:
 	/* Free all allocations */
 	kfree(auth_hmacs);
-- 
2.1.0
