From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 14 Mar 2018 11:05:33 +0000
Subject: [PATCH net-next 4/5] sctp: add SCTP_AUTH_FREE_KEY type for AUTHENTICATION_EVENT
Message-Id: <22218ceee8900508e30833758b613173d02031eb.1521025473.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
 <6b9a82f18f69682fea668026d33b937c1702a09a.1521025473.git.lucien.xin@gmail.com>
 <68816b668678174bdd44abeef7ed63a8260268c2.1521025473.git.lucien.xin@gmail.com>
 <e958480a6da52ad0947e319a2890fb034a473570.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <e958480a6da52ad0947e319a2890fb034a473570.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to add SCTP_AUTH_FREE_KEY type for AUTHENTICATION_EVENT,
as described in section 6.1.8 of RFC6458.

      SCTP_AUTH_FREE_KEY:  This report indicates that the SCTP
         implementation will no longer use the key identifier specified
         in auth_keynumber.

After deactivating a key, it would never be used again, which means
it's refcnt can't be held/increased by new chunks. But there may be
some chunks in out queue still using it. So only when refcnt is 1,
which means no chunk in outqueue is using/holding this key either,
this EVENT would be sent.

When users receive this notification, they could do DEL_KEY sockopt to
remove this shkey, and also tell the peer that this key won't be used
in any chunk thoroughly from now on, then the peer can remove it as
well safely.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  6 +++++-
 net/sctp/auth.c           | 14 ++++++++++++++
 net/sctp/sm_make_chunk.c  | 20 +++++++++++++++++++-
 net/sctp/sm_statefuns.c   |  2 +-
 net/sctp/socket.c         | 19 ++++++++++++++++++-
 5 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 08fc313..18ebbfe 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -518,7 +518,11 @@ struct sctp_authkey_event {
 	sctp_assoc_t auth_assoc_id;
 };
 
-enum { SCTP_AUTH_NEWKEY = 0, };
+enum {
+	SCTP_AUTH_NEW_KEY,
+#define	SCTP_AUTH_NEWKEY	SCTP_AUTH_NEW_KEY /* compatible with before */
+	SCTP_AUTH_FREE_KEY,
+};
 
 /*
  * 6.1.9. SCTP_SENDER_DRY_EVENT
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index a073123..e64630c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -992,6 +992,20 @@ int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
 	if (!found)
 		return -EINVAL;
 
+	/* refcnt = 1 and !list_empty mean it's not being used anywhere
+	 * and deactivated will be set, so it's time to notify userland
+	 * that this shkey can be freed.
+	 */
+	if (asoc && !list_empty(&key->key_list) &&
+	    refcount_read(&key->refcnt) = 1) {
+		struct sctp_ulpevent *ev;
+
+		ev = sctp_ulpevent_make_authkey(asoc, key->key_id,
+						SCTP_AUTH_FREE_KEY, GFP_KERNEL);
+		if (ev)
+			asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
+	}
+
 	key->deactivated = 1;
 
 	return 0;
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 10f071c..cc20bc3 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -89,8 +89,26 @@ static void sctp_control_release_owner(struct sk_buff *skb)
 {
 	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
 
-	if (chunk->shkey)
+	if (chunk->shkey) {
+		struct sctp_shared_key *shkey = chunk->shkey;
+		struct sctp_association *asoc = chunk->asoc;
+
+		/* refcnt = 2 and !list_empty mean after this release, it's
+		 * not being used anywhere, and it's time to notify userland
+		 * that this shkey can be freed if it's been deactivated.
+		 */
+		if (shkey->deactivated && !list_empty(&shkey->key_list) &&
+		    refcount_read(&shkey->refcnt) = 2) {
+			struct sctp_ulpevent *ev;
+
+			ev = sctp_ulpevent_make_authkey(asoc, shkey->key_id,
+							SCTP_AUTH_FREE_KEY,
+							GFP_KERNEL);
+			if (ev)
+				asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
+		}
 		sctp_auth_shkey_release(chunk->shkey);
+	}
 }
 
 static void sctp_control_set_owner_w(struct sctp_chunk *chunk)
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 792e0e2..1e41dee 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4246,7 +4246,7 @@ enum sctp_disposition sctp_sf_eat_auth(struct net *net,
 		struct sctp_ulpevent *ev;
 
 		ev = sctp_ulpevent_make_authkey(asoc, ntohs(auth_hdr->shkey_id),
-				    SCTP_AUTH_NEWKEY, GFP_ATOMIC);
+				    SCTP_AUTH_NEW_KEY, GFP_ATOMIC);
 
 		if (!ev)
 			return -ENOMEM;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 65cc354..aeecdd6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8166,8 +8166,25 @@ static void sctp_wfree(struct sk_buff *skb)
 	sk->sk_wmem_queued   -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
 
-	if (chunk->shkey)
+	if (chunk->shkey) {
+		struct sctp_shared_key *shkey = chunk->shkey;
+
+		/* refcnt = 2 and !list_empty mean after this release, it's
+		 * not being used anywhere, and it's time to notify userland
+		 * that this shkey can be freed if it's been deactivated.
+		 */
+		if (shkey->deactivated && !list_empty(&shkey->key_list) &&
+		    refcount_read(&shkey->refcnt) = 2) {
+			struct sctp_ulpevent *ev;
+
+			ev = sctp_ulpevent_make_authkey(asoc, shkey->key_id,
+							SCTP_AUTH_FREE_KEY,
+							GFP_KERNEL);
+			if (ev)
+				asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
+		}
 		sctp_auth_shkey_release(chunk->shkey);
+	}
 
 	sock_wfree(skb);
 	sctp_wake_up_waiters(sk, asoc);
-- 
2.1.0

