From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:47 +0000
Subject: [PATCH net-next 5/8] sctp: use ep and asoc auth_enable properly
Message-Id: <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp has per endpoint auth flag and per asoc auth flag, and
the asoc one should be checked when coming to asoc and the
endpoint one should be checked when coming to endpoint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/auth.c   | 32 +++++++++++++++++++++++++-------
 net/sctp/socket.c | 45 +++++++++++++++++++--------------------------
 2 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index de4c78d..61b0090 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -389,7 +389,7 @@ int sctp_auth_asoc_init_active_key(struct sctp_association *asoc, gfp_t gfp)
 	/* If we don't support AUTH, or peer is not capable
 	 * we don't need to do anything.
 	 */
-	if (!asoc->ep->auth_enable || !asoc->peer.auth_capable)
+	if (!asoc->peer.auth_capable)
 		return 0;
 
 	/* If the key_id is non-zero and we couldn't find an
@@ -675,7 +675,7 @@ int sctp_auth_send_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
 	if (!asoc)
 		return 0;
 
-	if (!asoc->ep->auth_enable || !asoc->peer.auth_capable)
+	if (!asoc->peer.auth_capable)
 		return 0;
 
 	return __sctp_auth_cid(chunk, asoc->peer.peer_chunks);
@@ -687,7 +687,7 @@ int sctp_auth_recv_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
 	if (!asoc)
 		return 0;
 
-	if (!asoc->ep->auth_enable)
+	if (!asoc->peer.auth_capable)
 		return 0;
 
 	return __sctp_auth_cid(chunk,
@@ -831,10 +831,15 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	/* Try to find the given key id to see if
 	 * we are doing a replace, or adding a new key
 	 */
-	if (asoc)
+	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
 		sh_keys = &asoc->endpoint_shared_keys;
-	else
+	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
 		sh_keys = &ep->endpoint_shared_keys;
+	}
 
 	key_for_each(shkey, sh_keys) {
 		if (shkey->key_id = auth_key->sca_keynumber) {
@@ -875,10 +880,15 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
 	int found = 0;
 
 	/* The key identifier MUST correst to an existing key */
-	if (asoc)
+	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
 		sh_keys = &asoc->endpoint_shared_keys;
-	else
+	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
 		sh_keys = &ep->endpoint_shared_keys;
+	}
 
 	key_for_each(key, sh_keys) {
 		if (key->key_id = key_id) {
@@ -911,11 +921,15 @@ int sctp_auth_del_key_id(struct sctp_endpoint *ep,
 	 * The key identifier MUST correst to an existing key
 	 */
 	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
 		if (asoc->active_key_id = key_id)
 			return -EINVAL;
 
 		sh_keys = &asoc->endpoint_shared_keys;
 	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
 		if (ep->active_key_id = key_id)
 			return -EINVAL;
 
@@ -950,11 +964,15 @@ int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
 	 * The key identifier MUST correst to an existing key
 	 */
 	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
 		if (asoc->active_key_id = key_id)
 			return -EINVAL;
 
 		sh_keys = &asoc->endpoint_shared_keys;
 	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
 		if (ep->active_key_id = key_id)
 			return -EINVAL;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b21a707..dcde8d9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3687,9 +3687,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	struct sctp_association *asoc;
 	int ret = -EINVAL;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (optlen <= sizeof(struct sctp_authkey))
 		return -EINVAL;
 	/* authkey->sca_keylength is u16, so optlen can't be bigger than
@@ -3756,9 +3753,6 @@ static int sctp_setsockopt_active_key(struct sock *sk,
 	struct sctp_authkeyid val;
 	int ret = 0;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 	if (copy_from_user(&val, optval, optlen))
@@ -3810,9 +3804,6 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 	struct sctp_authkeyid val;
 	int ret = 0;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 	if (copy_from_user(&val, optval, optlen))
@@ -3863,9 +3854,6 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
 	struct sctp_authkeyid val;
 	int ret = 0;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 	if (copy_from_user(&val, optval, optlen))
@@ -6872,9 +6860,6 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (len < sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 
@@ -6886,10 +6871,15 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
-	if (asoc)
+	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
 		val.scact_keynumber = asoc->active_key_id;
-	else
+	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
 		val.scact_keynumber = ep->active_key_id;
+	}
 
 	if (put_user(len, optlen))
 		return -EFAULT;
@@ -6902,7 +6892,6 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
-	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
 	struct sctp_association *asoc;
@@ -6910,9 +6899,6 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 	u32    num_chunks = 0;
 	char __user *to;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
@@ -6924,6 +6910,9 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 	if (!asoc)
 		return -EINVAL;
 
+	if (!asoc->peer.auth_capable)
+		return -EACCES;
+
 	ch = asoc->peer.peer_chunks;
 	if (!ch)
 		goto num;
@@ -6955,9 +6944,6 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	u32    num_chunks = 0;
 	char __user *to;
 
-	if (!ep->auth_enable)
-		return -EACCES;
-
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
@@ -6970,8 +6956,15 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	ch = asoc ? (struct sctp_chunks_param *)asoc->c.auth_chunks
-		  : ep->auth_chunk_list;
+	if (asoc) {
+		if (!asoc->peer.auth_capable)
+			return -EACCES;
+		ch = (struct sctp_chunks_param *)asoc->c.auth_chunks;
+	} else {
+		if (!ep->auth_enable)
+			return -EACCES;
+		ch = ep->auth_chunk_list;
+	}
 	if (!ch)
 		goto num;
 
-- 
2.1.0
