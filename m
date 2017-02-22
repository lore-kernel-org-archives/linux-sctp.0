From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 22 Feb 2017 17:03:59 +0000
Subject: [RFC v2 PATCH 2/2] kernel: Add SELinux SCTP protocol support
Message-Id: <20170222170359.5433-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

Add SELinux support for the SCTP protocol. The SELinux-sctp.txt document
describes how the patch has been implemented.

Patches to assist the testing of this kernel patch are:
1) Support new SCTP portcon statement used by SCTP tests in the
selinux-testsuite [1].
2) Add SCTP tests to the selinux-testsuite [2].

Built and tested on Fedora 25 with linux-4.9.9 kernel.

[1] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-Add-support-for-the-SCTP-portcon-keyword.patch
[2] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-testsuite-Add-SCTP-test-support.patch

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 Documentation/security/SELinux-sctp.txt | 178 ++++++++++++++++++++++++++
 include/net/sctp/structs.h              |   7 ++
 net/sctp/sm_make_chunk.c                |  12 ++
 net/sctp/sm_statefuns.c                 |  20 +++
 net/sctp/socket.c                       |  42 ++++++-
 security/selinux/hooks.c                | 213 ++++++++++++++++++++++++++++++--
 security/selinux/include/classmap.h     |   3 +
 7 files changed, 466 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/security/SELinux-sctp.txt

diff --git a/Documentation/security/SELinux-sctp.txt b/Documentation/security/SELinux-sctp.txt
new file mode 100644
index 0000000..ada666f
--- /dev/null
+++ b/Documentation/security/SELinux-sctp.txt
@@ -0,0 +1,178 @@
+                               SCTP SELinux Support
+                              ===========
+
+Testing - selinux-testsuite
+==============
+There is a patch available that adds SCTP/SELinux tests to the
+selinux-testsuite. This is available from:
+
+http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-testsuite-Add-SCTP-test-support.patch
+
+These tests require libsepol to support the new sctp portcon statement.
+A patch is available from:
+
+http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-Add-support-for-the-SCTP-portcon-keyword.patch
+
+Before running these tests, read the selinux-testsuite/README.sctp as it is
+also possible to run the lksctp-tools/src/func_tests that are available from:
+
+https://github.com/sctp/lksctp-tools
+
+
+Security Hooks
+=======+
+The Documentation/security/LSM-sctp.txt document describes how the following
+sctp security hooks are utilised:
+    security_sctp_assoc_request()
+    security_sctp_accept_conn()
+    security_sctp_sk_clone()
+    security_sctp_addr_list()
+
+
+Policy Statements
+=========
+A new object class "sctp_socket" has been introduced with the following SCTP
+specific permissions: association bindx_add connectx
+
+The permissions are explained in the sections below.
+
+Kernel policy language
+-----------------------
+class sctp_socket
+class sctp_socket inherits socket { node_bind name_connect association
+                                    bindx_add connectx }
+
+CIL policy language
+--------------------
+(classcommon sctp_socket socket)
+(class sctp_socket (node_bind name_connect association bindx_add connectx))
+(classorder (unordered sctp_socket))
+
+If the SELinux userspace tools have been updated, then the portcon statement
+may be used as shown in the following example:
+    (portcon sctp (1024 1035) (system_u object_r sctp_port_t ((s0) (s0))))
+
+Rule validation parameters used when 'network_peer_controls = 1':
+-------------------------------------------------------------------------------
+Rule  Source   Target     Class        Permissions
+-------------------------------------------------------------------------------
+allow socket_t socket_t : sctp_socket { bindx_add connectx }; [1]
+allow socket_t port_t   : sctp_socket { name_bind name_connect }; [2]
+allow socket_t node_t   : sctp_socket { node_bind };
+allow socket_t peer_t   : sctp_socket { association };
+
+[1] setsockcreatecon(3) may be used to create a new labeled socket.
+[2] The port types may differ for name_bind and name_connect.
+
+
+SCTP Bind, Connect and ASCONF Chunk Parameter Permission Checks
+================================
+The hook security_sctp_addr_list() is called by SCTP to check permissions
+required for ipv4/ipv6 addresses based on the @optname as follows:
+
+  ------------------------------------------------------------------
+  |                  BINDX_ADD Permission Check                    |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_SOCKOPT_BINDX_ADD     | One or more ipv4 / ipv6 addresses |
+  ------------------------------------------------------------------
+
+  ------------------------------------------------------------------
+  |                  BIND Permission Checks                        |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_PRIMARY_ADDR          | Single ipv4 or ipv6 address       |
+  | SCTP_SET_PEER_PRIMARY_ADDR | Single ipv4 or ipv6 address       |
+  ------------------------------------------------------------------
+
+  ------------------------------------------------------------------
+  |                 CONNECTX Permission Check                      |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_SOCKOPT_CONNECTX      | One or more ipv4 / ipv6 addresses |
+  ------------------------------------------------------------------
+
+  ------------------------------------------------------------------
+  |                 CONNECT Permission Checks                      |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_PARAM_ADD_IP          | One or more ipv4 / ipv6 addresses |
+  | SCTP_PARAM_SET_PRIMARY     | Single ipv4 or ipv6 address       |
+  ------------------------------------------------------------------
+
+A summary of the @optname entries is as follows:
+
+    SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
+                             associated after (optionally) calling
+                             bind(3).
+                             sctp_bindx(3) adds a set of bind
+	                     addresses on a socket.
+
+    SCTP_SOCKOPT_CONNECTX - Allows the allocation of multiple
+                            addresses for reaching a peer
+                            (multi-homed).
+                            sctp_connectx(3) initiates a connection
+                            on an SCTP socket using multiple
+                            destination addresses.
+
+    SCTP_PRIMARY_ADDR     - Set local primary address.
+
+    SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
+                                 association primary.
+
+Note that to support Dynamic Address Reconfiguration the following
+parameters must be enabled on both endpoints (or the appropriate
+setsockopts):
+    /proc/sys/net/sctp/addip_enable
+    /proc/sys/net/sctp/addip_noauth_enable
+
+then the following *_PARAM_*'s are sent to the peer in an
+ASCONF chunk when the corresponding @optname's are present:
+
+          @optname                ASCONF Parameter
+    SCTP_SOCKOPT_BINDX_ADD     -> SCTP_PARAM_ADD_IP
+    SCTP_SET_PEER_PRIMARY_ADDR -> SCTP_PARAM_SET_PRIMARY
+
+
+SCTP Peer Labeling and Permission Checks
+====================+An SCTP socket will only have one peer label assigned to it. This will be
+assigned during the establishment of the first association. Once the peer
+label has been assigned, the "association" permission will be checked as
+follows:
+
+       allow socket_t peer_t : sctp_socket { association };
+
+This allows policy to decide whether to allow or deny associations from peers,
+as there can be multiple associations on a single socket. These associations
+could come from any of the policy allowed peers, however it could be that
+these are required by other services but sctp associations are not allowed
+from all of them.
+
+NOTES:
+   1) If peer labeling is not enabled, then the peer context will always be
+      SECINITSID_UNLABELED (unlabeled_t in Reference Policy).
+
+   2) If peer labeling is supported, getpeercon(3) may be used by userspace
+      to retrieve the sockets peer context.
+
+   3) If using NetLabel be aware that if a label is assigned to a specific
+      interface, and that interface 'goes down', then the NetLabel service
+      will remove the entry. Therefore ensure that the network startup scripts
+      call netlabelctl(8) to set the required label (see netlabel-config(8)
+      helper script for details).
+
+   4) The NetLabel SCTP peer labeling rules apply as discussed in the following
+      set of posts tagged "netlabel" at: http://www.paul-moore.com/blog/t,
+      except for the following issue that requires further work to resolve:
+
+       a) SCTP does not support "cmsg_type = SCM_SECURITY" in datagrams for
+          ipv4 or ipv6, therefore CIPSO/CALIPSO will fail unless TCP type
+          sockets are used. See the SCTP tests in the selinux-testsuite where
+          pass/fail configurations are noted.
+
+   6) IPSEC is not supported as rfc3554 - sctp/ipsec support has not been
+      implemented in userspace (racoon(8) or ipsec_pluto(8)), although the
+      kernel supports SCTP/IPSEC.
+
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 11c3bf2..d54a767 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1287,6 +1287,13 @@ struct sctp_endpoint {
 	__u16 active_key_id;
 	__u8  auth_enable:1,
 	      prsctp_enable:1;
+
+	/* Security identifiers from incoming (COOKIE-ECHO) connection.
+	 * These are set by security_sctp_accept_conn() and used by
+	 * security_sctp_sk_clone() to set sids on newsock.
+	 */
+	u32 secid;
+	u32 peer_secid;
 };
 
 /* Recover the outter endpoint structure. */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9e9690b..648b63b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3056,6 +3056,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (af->is_any(&addr))
 			memcpy(&addr, &asconf->source, sizeof(addr));
 
+		if (security_sctp_addr_list(asoc->ep->base.sk,
+					    SCTP_PARAM_ADD_IP,
+					    (struct sockaddr *)&addr,
+					    af->sockaddr_len))
+			return SCTP_ERROR_REQ_REFUSED;
+
 		/* ADDIP 4.3 D9) If an endpoint receives an ADD IP address
 		 * request and does not have the local resources to add this
 		 * new address to the association, it MUST return an Error
@@ -3122,6 +3128,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (af->is_any(&addr))
 			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
 
+		if (security_sctp_addr_list(asoc->ep->base.sk,
+					    SCTP_PARAM_SET_PRIMARY,
+					    (struct sockaddr *)&addr,
+					    af->sockaddr_len))
+			return SCTP_ERROR_REQ_REFUSED;
+
 		peer = sctp_assoc_lookup_paddr(asoc, &addr);
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8ec20a6..363793c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -315,6 +315,13 @@ sctp_disposition_t sctp_sf_do_5_1B_init(struct net *net,
 	sctp_unrecognized_param_t *unk_param;
 	int len;
 
+	/* Update socket peer label if first association then check
+	 * whether association allowed.
+	 * See Documentation/security/LSM-sctp.txt for details.
+	 */
+	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 6.10 Bundling
 	 * An endpoint MUST NOT bundle INIT, INIT ACK or
 	 * SHUTDOWN COMPLETE with any other chunks.
@@ -508,6 +515,13 @@ sctp_disposition_t sctp_sf_do_5_1C_ack(struct net *net,
 	struct sctp_chunk *err_chunk;
 	struct sctp_packet *packet;
 
+	/* Update socket peer label if first association then check
+	 * whether association allowed.
+	 * See Documentation/security/LSM-sctp.txt for details.
+	 */
+	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
@@ -812,6 +826,12 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(struct net *net,
 			goto nomem_aiev;
 	}
 
+	/* Received COOKIE-ECHO so store security info in ep.
+	 * See Documentation/security/LSM-sctp.txt for details.
+	 */
+	if (security_sctp_accept_conn((struct sctp_endpoint *)ep, chunk->skb))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Add all the state machine commands now since we've created
 	 * everything.  This way we don't introduce memory corruptions
 	 * during side-effect processing and correclty count established
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6cbe5bd..995de4b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1009,6 +1009,12 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	/* Do the work. */
 	switch (op) {
 	case SCTP_BINDX_ADD_ADDR:
+		/* Allow security module to validate bindx addresses. */
+		err = security_sctp_addr_list(sk, SCTP_SOCKOPT_BINDX_ADD,
+					      (struct sockaddr *)kaddrs,
+					      addrs_size);
+		if (err)
+			goto out;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
 		if (err)
 			goto out;
@@ -1329,9 +1335,17 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
 		err = -EFAULT;
 	} else {
+		/* Allow security module to validate connectx addresses. */
+		err = security_sctp_addr_list(sk, SCTP_SOCKOPT_CONNECTX,
+					      (struct sockaddr *)kaddrs,
+					      addrs_size);
+		if (err)
+			goto out_free;
+
 		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
 	}
 
+out_free:
 	kfree(kaddrs);
 
 	return err;
@@ -2858,6 +2872,8 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 {
 	struct sctp_prim prim;
 	struct sctp_transport *trans;
+	struct sctp_af *af;
+	int err;
 
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
@@ -2865,6 +2881,17 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
 		return -EFAULT;
 
+	/* Allow security module to validate address but need address len. */
+	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	if (!af)
+		return -EINVAL;
+
+	err = security_sctp_addr_list(sk, SCTP_PRIMARY_ADDR,
+				      (struct sockaddr *)&prim.ssp_addr,
+				      af->sockaddr_len);
+	if (err)
+		return err;
+
 	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
@@ -3184,6 +3211,13 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
 		return -EADDRNOTAVAIL;
 
+	/* Allow security module to validate address. */
+	err = security_sctp_addr_list(sk, SCTP_SET_PEER_PRIMARY_ADDR,
+				      (struct sockaddr *)&prim.sspp_addr,
+				      af->sockaddr_len);
+	if (err)
+		return err;
+
 	/* Create an ASCONF chunk with SET_PRIMARY parameter	*/
 	chunk = sctp_make_asconf_set_prim(asoc,
 					  (union sctp_addr *)&prim.sspp_addr);
@@ -7683,8 +7717,6 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 
 	if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
 		net_enable_timestamp();
-
-	security_sk_clone(sk, newsk);
 }
 
 static inline void sctp_copy_descendant(struct sock *sk_to,
@@ -7714,6 +7746,7 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	struct sk_buff *skb, *tmp;
 	struct sctp_ulpevent *event;
 	struct sctp_bind_hashbucket *head;
+	struct sctp_endpoint *oldep = oldsp->ep;
 
 	/* Migrate socket buffer sizes and all the socket level options to the
 	 * new socket.
@@ -7829,6 +7862,11 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 		newsk->sk_state = SCTP_SS_ESTABLISHED;
 	}
 
+	/* Set newsk security attributes from oldsk and connection
+	 * security attribute from ep as described in
+	 * Documentation/security/LSM-sctp.txt
+	 */
+	security_sctp_sk_clone(oldep, oldsk, newsk);
 	release_sock(newsk);
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7f4387f..c0be892 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -65,6 +65,8 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/dccp.h>
+#include <linux/sctp.h>
+#include <net/sctp/structs.h>
 #include <linux/quota.h>
 #include <linux/un.h>		/* for Unix socket types */
 #include <net/af_unix.h>	/* for Unix socket types */
@@ -1284,8 +1286,11 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 	case PF_INET6:
 		switch (type) {
 		case SOCK_STREAM:
+		case SOCK_SEQPACKET:
 			if (default_protocol_stream(protocol))
 				return SECCLASS_TCP_SOCKET;
+			else if (protocol = IPPROTO_SCTP)
+				return SECCLASS_SCTP_SOCKET;
 			else
 				return SECCLASS_RAWIP_SOCKET;
 		case SOCK_DGRAM:
@@ -4033,6 +4038,23 @@ static int selinux_parse_skb_ipv4(struct sk_buff *skb,
 		break;
 	}
 
+#if IS_ENABLED(CONFIG_IP_SCTP)
+	case IPPROTO_SCTP: {
+		struct sctphdr _sctph, *sh;
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		offset += ihlen;
+		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
+		if (sh = NULL)
+			break;
+
+		ad->u.net->sport = sh->source;
+		ad->u.net->dport = sh->dest;
+		break;
+	}
+#endif
 	default:
 		break;
 	}
@@ -4106,6 +4128,19 @@ static int selinux_parse_skb_ipv6(struct sk_buff *skb,
 		break;
 	}
 
+#if IS_ENABLED(CONFIG_IP_SCTP)
+	case IPPROTO_SCTP: {
+		struct sctphdr _sctph, *sh;
+
+		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
+		if (sh = NULL)
+			break;
+
+		ad->u.net->sport = sh->source;
+		ad->u.net->dport = sh->dest;
+		break;
+	}
+#endif
 	/* includes fragments */
 	default:
 		break;
@@ -4317,8 +4352,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 
 	/*
 	 * If PF_INET or PF_INET6, check name_bind permission for the port.
-	 * Multiple address binding for SCTP is not supported yet: we just
-	 * check the first address now.
+	 * Multiple address binding for SCTP is supported via
+	 * selinux_sctp_addr_list().
 	 */
 	family = sk->sk_family;
 	if (family = PF_INET || family = PF_INET6) {
@@ -4376,6 +4411,10 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 			node_perm = DCCP_SOCKET__NODE_BIND;
 			break;
 
+		case SECCLASS_SCTP_SOCKET:
+			node_perm = SCTP_SOCKET__NODE_BIND;
+			break;
+
 		default:
 			node_perm = RAWIP_SOCKET__NODE_BIND;
 			break;
@@ -4415,10 +4454,12 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
 		return err;
 
 	/*
-	 * If a TCP or DCCP socket, check name_connect permission for the port.
+	 * If a TCP, DCCP or SCTP socket, check name_connect permission
+	 * for the port.
 	 */
 	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
-	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
+	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
+	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
 		struct common_audit_data ad;
 		struct lsm_network_audit net = {0,};
 		struct sockaddr_in *addr4 = NULL;
@@ -4439,11 +4480,21 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
 		}
 
 		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
+
 		if (err)
 			goto out;
 
-		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
-		       TCP_SOCKET__NAME_CONNECT : DCCP_SOCKET__NAME_CONNECT;
+		switch (sksec->sclass) {
+		case SECCLASS_TCP_SOCKET:
+			perm = TCP_SOCKET__NAME_CONNECT;
+			break;
+		case SECCLASS_DCCP_SOCKET:
+			perm = DCCP_SOCKET__NAME_CONNECT;
+			break;
+		case SECCLASS_SCTP_SOCKET:
+			perm = SCTP_SOCKET__NAME_CONNECT;
+			break;
+		}
 
 		ad.type = LSM_AUDIT_DATA_NET;
 		ad.u.net = &net;
@@ -4714,7 +4765,8 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 	u32 peer_sid = SECSID_NULL;
 
 	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
-	    sksec->sclass = SECCLASS_TCP_SOCKET)
+	    sksec->sclass = SECCLASS_TCP_SOCKET ||
+	    sksec->sclass = SECCLASS_SCTP_SOCKET)
 		peer_sid = sksec->peer_sid;
 	if (peer_sid = SECSID_NULL)
 		return -ENOPROTOOPT;
@@ -4827,6 +4879,149 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 	sksec->sclass = isec->sclass;
 }
 
+static int selinux_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = sk->sk_security;
+	struct common_audit_data ad;
+	struct lsm_network_audit net = {0,};
+	u8 peerlbl_active;
+	int err;
+
+	peerlbl_active = selinux_peerlbl_enabled();
+
+	if (sksec->peer_sid = SECINITSID_UNLABELED && peerlbl_active) {
+		/* Here because this is the first association on this
+		 * socket that is always unlabeled, therefore set
+		 * sksec->peer_sid to new peer ctx. For further info see:
+		 * Documentation/security/SELinux-sctp.txt
+		 */
+		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
+					      &sksec->peer_sid);
+		if (err)
+			return err;
+	}
+
+	ad.type = LSM_AUDIT_DATA_NET;
+	ad.u.net = &net;
+	ad.u.net->sk = sk;
+
+	err = avc_has_perm(sksec->sid, sksec->peer_sid, sksec->sclass,
+			   SCTP_SOCKET__ASSOCIATION, &ad);
+	return err;
+}
+
+static int selinux_sctp_accept_conn(struct sctp_endpoint *ep,
+				    struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = ep->base.sk->sk_security;
+	int err;
+	u32 connsid;
+	u32 peersid;
+
+	/* Have COOKIE ECHO so compute the MLS component for the connection
+	 * and store the information in ep. This will only be used by
+	 * TCP/peeloff connections as they cause a new socket to be generated.
+	 * selinux_sctp_sk_clone() will then plug this into the new socket
+	 * as described in Documentation/security/LSM-sctp.txt
+	 */
+	err = selinux_skb_peerlbl_sid(skb, ep->base.sk->sk_family, &peersid);
+	if (err)
+		return err;
+
+	err = selinux_conn_sid(sksec->sid, peersid, &connsid);
+	if (err)
+		return err;
+
+	ep->secid = connsid;
+	ep->peer_secid = peersid;
+
+	return 0;
+}
+
+static void selinux_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+				  struct sock *newsk)
+{
+	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *newsksec = newsk->sk_security;
+
+	newsksec->sid = ep->secid;
+	newsksec->peer_sid = ep->peer_secid;
+	newsksec->sclass = sksec->sclass;
+	selinux_netlbl_sk_security_reset(newsksec);
+}
+
+/* Check if sctp IPv4/IPv6 addresses are valid for binding or connecting based
+ * on their @optname.
+ */
+static int selinux_sctp_addr_list(struct sock *sk, int optname,
+				  struct sockaddr *address, int addrlen)
+{
+	int len, err = 0, walk_size = 0;
+	void *addr_buf;
+	struct sockaddr *addr;
+	struct socket *sock;
+
+	switch (optname) {
+	case SCTP_SOCKOPT_BINDX_ADD:
+		err = sock_has_perm(current, sk, SCTP_SOCKET__BINDX_ADD);
+		break;
+	case SCTP_SOCKOPT_CONNECTX:
+		err = sock_has_perm(current, sk, SCTP_SOCKET__CONNECTX);
+		break;
+	/* These need just BIND or CONNECT permissions. */
+	case SCTP_PRIMARY_ADDR:
+	case SCTP_SET_PEER_PRIMARY_ADDR:
+	case SCTP_PARAM_SET_PRIMARY:
+	case SCTP_PARAM_ADD_IP:
+		break;
+	default:
+		err = -EINVAL;
+	}
+	if (err)
+		return err;
+
+	/* Process one or more addresses that may be IPv4 or IPv6 */
+	sock = sk->sk_socket;
+	addr_buf = address;
+
+	while (walk_size < addrlen) {
+		addr = addr_buf;
+		switch (addr->sa_family) {
+		case PF_INET:
+			len = sizeof(struct sockaddr_in);
+			break;
+		case PF_INET6:
+			len = sizeof(struct sockaddr_in6);
+			break;
+		default:
+			return -EPROTONOSUPPORT;
+		}
+
+		err = -EINVAL;
+		switch (optname) {
+		/* Bind checks */
+		case SCTP_PRIMARY_ADDR:
+		case SCTP_SET_PEER_PRIMARY_ADDR:
+		case SCTP_SOCKOPT_BINDX_ADD:
+			err = selinux_socket_bind(sock, addr, len);
+			break;
+		/* Connect checks */
+		case SCTP_SOCKOPT_CONNECTX:
+		case SCTP_PARAM_SET_PRIMARY:
+		case SCTP_PARAM_ADD_IP:
+			err = selinux_socket_connect(sock, addr, len);
+			break;
+		}
+
+		if (err)
+			return err;
+
+		addr_buf += len;
+		walk_size += len;
+	}
+	return 0;
+}
+
 static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 				     struct request_sock *req)
 {
@@ -6252,6 +6447,10 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(sk_clone_security, selinux_sk_clone_security),
 	LSM_HOOK_INIT(sk_getsecid, selinux_sk_getsecid),
 	LSM_HOOK_INIT(sock_graft, selinux_sock_graft),
+	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
+	LSM_HOOK_INIT(sctp_accept_conn, selinux_sctp_accept_conn),
+	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
+	LSM_HOOK_INIT(sctp_addr_list, selinux_sctp_addr_list),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 1f1f4b2..b76ed42 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -165,5 +165,8 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_CAP_PERMS, NULL } },
 	{ "cap2_userns",
 	  { COMMON_CAP2_PERMS, NULL } },
+	{ "sctp_socket",
+	  { COMMON_SOCK_PERMS, "node_bind", "name_connect", "association",
+	    "bindx_add", "connectx", NULL } },
 	{ NULL }
   };
-- 
2.9.3

