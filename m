From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 13 Feb 2018 20:56:24 +0000
Subject: [PATCH V6 3/4] sctp: Add LSM hooks
Message-Id: <20180213205624.4617-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

Add security hooks allowing security modules to exercise access control
over SCTP.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 include/net/sctp/structs.h | 10 ++++++++
 include/uapi/linux/sctp.h  |  1 +
 net/sctp/sm_make_chunk.c   | 12 +++++++++
 net/sctp/sm_statefuns.c    | 18 ++++++++++++++
 net/sctp/socket.c          | 62 +++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index ead5fce..7a23896 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1318,6 +1318,16 @@ struct sctp_endpoint {
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
+
+	/* Security identifiers from incoming (INIT). These are set by
+	 * security_sctp_assoc_request(). These will only be used by
+	 * SCTP TCP type sockets and peeled off connections as they
+	 * cause a new socket to be generated. security_sctp_sk_clone()
+	 * will then plug these into the new socket.
+	 */
+
+	u32 secid;
+	u32 peer_secid;
 };
 
 /* Recover the outter endpoint structure. */
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 4c4db14..64736ed 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -126,6 +126,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_STREAM_SCHEDULER	123
 #define SCTP_STREAM_SCHEDULER_VALUE	124
 #define SCTP_INTERLEAVING_SUPPORTED	125
+#define SCTP_SENDMSG_CONNECT	126
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d01475f..70274ae 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3071,6 +3071,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (af->is_any(&addr))
 			memcpy(&addr, &asconf->source, sizeof(addr));
 
+		if (security_sctp_bind_connect(asoc->ep->base.sk,
+					       SCTP_PARAM_ADD_IP,
+					       (struct sockaddr *)&addr,
+					       af->sockaddr_len))
+			return SCTP_ERROR_REQ_REFUSED;
+
 		/* ADDIP 4.3 D9) If an endpoint receives an ADD IP address
 		 * request and does not have the local resources to add this
 		 * new address to the association, it MUST return an Error
@@ -3137,6 +3143,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (af->is_any(&addr))
 			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
 
+		if (security_sctp_bind_connect(asoc->ep->base.sk,
+					       SCTP_PARAM_SET_PRIMARY,
+					       (struct sockaddr *)&addr,
+					       af->sockaddr_len))
+			return SCTP_ERROR_REQ_REFUSED;
+
 		peer = sctp_assoc_lookup_paddr(asoc, &addr);
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index eb7905f..42659ab 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -321,6 +321,11 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	struct sctp_packet *packet;
 	int len;
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
+					chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
@@ -908,6 +913,9 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
 
+	/* Set peer label for connection. */
+	security_inet_conn_established(ep->base.sk, chunk->skb);
+
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
 	 * E) Upon reception of the COOKIE ACK, endpoint "A" will move
@@ -1436,6 +1444,11 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	struct sctp_packet *packet;
 	int len;
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
+					chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
@@ -2106,6 +2119,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 		}
 	}
 
+	/* Update socket peer label if first association. */
+	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
+					chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Set temp so that it won't be added into hashtable */
 	new_asoc->temp = 1;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8307968..a5519d2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1043,6 +1043,12 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	/* Do the work. */
 	switch (op) {
 	case SCTP_BINDX_ADD_ADDR:
+		/* Allow security module to validate bindx addresses. */
+		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
+						 (struct sockaddr *)kaddrs,
+						 addrs_size);
+		if (err)
+			goto out;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
 		if (err)
 			goto out;
@@ -1252,6 +1258,7 @@ static int __sctp_connect(struct sock *sk,
 
 	if (assoc_id)
 		*assoc_id = asoc->assoc_id;
+
 	err = sctp_wait_for_connect(asoc, &timeo);
 	/* Note: the asoc may be freed after the return of
 	 * sctp_wait_for_connect.
@@ -1347,7 +1354,16 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	if (unlikely(IS_ERR(kaddrs)))
 		return PTR_ERR(kaddrs);
 
+	/* Allow security module to validate connectx addresses. */
+	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_CONNECTX,
+					 (struct sockaddr *)kaddrs,
+					  addrs_size);
+	if (err)
+		goto out_free;
+
 	err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
+
+out_free:
 	kvfree(kaddrs);
 
 	return err;
@@ -1615,6 +1631,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	struct sctp_transport *transport, *chunk_tp;
 	struct sctp_chunk *chunk;
 	union sctp_addr to;
+	struct sctp_af *af;
 	struct sockaddr *msg_name = NULL;
 	struct sctp_sndrcvinfo default_sinfo;
 	struct sctp_sndrcvinfo *sinfo;
@@ -1844,6 +1861,24 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		}
 
 		scope = sctp_scope(&to);
+
+		/* Label connection socket for first association 1-to-many
+		 * style for client sequence socket()->sendmsg(). This
+		 * needs to be done before sctp_assoc_add_peer() as that will
+		 * set up the initial packet that needs to account for any
+		 * security ip options (CIPSO/CALIPSO) added to the packet.
+		 */
+		af = sctp_get_af_specific(to.sa.sa_family);
+		if (!af) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		err = security_sctp_bind_connect(sk, SCTP_SENDMSG_CONNECT,
+						 (struct sockaddr *)&to,
+						 af->sockaddr_len);
+		if (err < 0)
+			goto out_unlock;
+
 		new_asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
 		if (!new_asoc) {
 			err = -ENOMEM;
@@ -2909,6 +2944,8 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 {
 	struct sctp_prim prim;
 	struct sctp_transport *trans;
+	struct sctp_af *af;
+	int err;
 
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
@@ -2916,6 +2953,17 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
 		return -EFAULT;
 
+	/* Allow security module to validate address but need address len. */
+	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	if (!af)
+		return -EINVAL;
+
+	err = security_sctp_bind_connect(sk, SCTP_PRIMARY_ADDR,
+					 (struct sockaddr *)&prim.ssp_addr,
+					 af->sockaddr_len);
+	if (err)
+		return err;
+
 	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
@@ -3248,6 +3296,13 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
 		return -EADDRNOTAVAIL;
 
+	/* Allow security module to validate address. */
+	err = security_sctp_bind_connect(sk, SCTP_SET_PEER_PRIMARY_ADDR,
+					 (struct sockaddr *)&prim.sspp_addr,
+					 af->sockaddr_len);
+	if (err)
+		return err;
+
 	/* Create an ASCONF chunk with SET_PRIMARY parameter	*/
 	chunk = sctp_make_asconf_set_prim(asoc,
 					  (union sctp_addr *)&prim.sspp_addr);
@@ -8347,6 +8402,8 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct inet_sock *newinet;
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_endpoint *ep = sp->ep;
 
 	newsk->sk_type = sk->sk_type;
 	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
@@ -8389,7 +8446,10 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
 		net_enable_timestamp();
 
-	security_sk_clone(sk, newsk);
+	/* Set newsk security attributes from orginal sk and connection
+	 * security attribute from ep.
+	 */
+	security_sctp_sk_clone(ep, sk, newsk);
 }
 
 static inline void sctp_copy_descendant(struct sock *sk_to,
-- 
2.14.3

