From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 02 Dec 2014 14:16:07 +0000
Subject: [RFC-PATCH 3/3] selinux: Add support for the SCTP protocol
Message-Id: <1417529767-2685-1-git-send-email-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org

Support SCTP protocol if enabled in the kernel.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 security/selinux/Makefile               |   2 +
 security/selinux/hooks.c                | 334 +++++++++++++++++++++-----------
 security/selinux/include/classmap.h     |   4 +
 security/selinux/include/sctp.h         |  66 +++++++
 security/selinux/include/sctp_private.h |  46 +++++
 security/selinux/netlabel.c             |  12 +-
 security/selinux/sctp.c                 | 318 ++++++++++++++++++++++++++++++
 7 files changed, 663 insertions(+), 119 deletions(-)
 create mode 100644 security/selinux/include/sctp.h
 create mode 100644 security/selinux/include/sctp_private.h
 create mode 100644 security/selinux/sctp.c

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index ad5cd76..a450c85 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -13,6 +13,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
 
 selinux-$(CONFIG_NETLABEL) += netlabel.o
 
+selinux-$(subst m,y,$(CONFIG_IP_SCTP)) += sctp.o
+
 ccflags-y := -Isecurity/selinux -Isecurity/selinux/include
 
 $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e03bad5..9e5ab56 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -66,6 +66,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/dccp.h>
+#include <linux/sctp.h>
 #include <linux/quota.h>
 #include <linux/un.h>		/* for Unix socket types */
 #include <net/af_unix.h>	/* for Unix socket types */
@@ -94,6 +95,7 @@
 #include "netlabel.h"
 #include "audit.h"
 #include "avc_ss.h"
+#include "sctp.h"
 
 extern struct security_operations *security_ops;
 
@@ -1185,8 +1187,11 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
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
@@ -3726,6 +3731,24 @@ static int selinux_parse_skb_ipv4(struct sk_buff *skb,
 		break;
 	}
 
+#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
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
+
 	default:
 		break;
 	}
@@ -3799,6 +3822,20 @@ static int selinux_parse_skb_ipv6(struct sk_buff *skb,
 		break;
 	}
 
+#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
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
+
 	/* includes fragments */
 	default:
 		break;
@@ -3928,7 +3965,7 @@ static int socket_sockcreate_sid(const struct task_security_struct *tsec,
 				       socksid);
 }
 
-static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
+int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
 {
 	struct sk_security_struct *sksec = sk->sk_security;
 	struct common_audit_data ad;
@@ -3998,6 +4035,93 @@ static int selinux_socket_post_create(struct socket *sock, int family,
    Need to determine whether we should perform a name_bind
    permission check between the socket and the port number. */
 
+int selinux_sk_bind(struct sock *sk, struct sockaddr *address,
+				    int addrlen, u16 family)
+{
+	int err = 0;
+	char *addrp;
+	struct sk_security_struct *sksec = sk->sk_security;
+	struct common_audit_data ad;
+	struct lsm_network_audit net = {0,};
+	struct sockaddr_in *addr4 = NULL;
+	struct sockaddr_in6 *addr6 = NULL;
+	unsigned short snum;
+	u32 sid, node_perm;
+
+	if (family = PF_INET) {
+		addr4 = (struct sockaddr_in *)address;
+		snum = ntohs(addr4->sin_port);
+		addrp = (char *)&addr4->sin_addr.s_addr;
+	} else {
+		addr6 = (struct sockaddr_in6 *)address;
+		snum = ntohs(addr6->sin6_port);
+		addrp = (char *)&addr6->sin6_addr.s6_addr;
+	}
+
+	if (snum) {
+		int low, high;
+
+		inet_get_local_port_range(sock_net(sk), &low, &high);
+
+		if (snum < max(PROT_SOCK, low) || snum > high) {
+			err = sel_netport_sid(sk->sk_protocol,
+					      snum, &sid);
+			if (err)
+				goto out;
+			ad.type = LSM_AUDIT_DATA_NET;
+			ad.u.net = &net;
+			ad.u.net->sport = htons(snum);
+			ad.u.net->family = family;
+			err = avc_has_perm(sksec->sid, sid,
+					   sksec->sclass,
+					   SOCKET__NAME_BIND, &ad);
+			if (err)
+				goto out;
+		}
+	}
+
+	switch (sksec->sclass) {
+	case SECCLASS_TCP_SOCKET:
+		node_perm = TCP_SOCKET__NODE_BIND;
+		break;
+
+	case SECCLASS_UDP_SOCKET:
+		node_perm = UDP_SOCKET__NODE_BIND;
+		break;
+
+	case SECCLASS_DCCP_SOCKET:
+		node_perm = DCCP_SOCKET__NODE_BIND;
+		break;
+
+	case SECCLASS_SCTP_SOCKET:
+		node_perm = SCTP_SOCKET__NODE_BIND;
+		break;
+
+	default:
+		node_perm = RAWIP_SOCKET__NODE_BIND;
+		break;
+	}
+
+	err = sel_netnode_sid(addrp, family, &sid);
+	if (err)
+		goto out;
+
+	ad.type = LSM_AUDIT_DATA_NET;
+	ad.u.net = &net;
+	ad.u.net->sport = htons(snum);
+	ad.u.net->family = family;
+
+	if (family = PF_INET)
+		ad.u.net->v4info.saddr = addr4->sin_addr.s_addr;
+	else
+		ad.u.net->v6info.saddr = addr6->sin6_addr;
+
+	err = avc_has_perm(sksec->sid, sid,
+			   sksec->sclass, node_perm, &ad);
+out:
+	return err;
+}
+
 static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
 {
 	struct sock *sk = sock->sk;
@@ -4006,93 +4130,61 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 
 	err = sock_has_perm(current, sk, SOCKET__BIND);
 	if (err)
-		goto out;
+		return err;
 
 	/*
 	 * If PF_INET or PF_INET6, check name_bind permission for the port.
-	 * Multiple address binding for SCTP is not supported yet: we just
-	 * check the first address now.
+	 * Multiple address binding for SCTP is supported via the
+	 * selinux_sctp_validate_*() functions.
 	 */
 	family = sk->sk_family;
-	if (family = PF_INET || family = PF_INET6) {
-		char *addrp;
-		struct sk_security_struct *sksec = sk->sk_security;
-		struct common_audit_data ad;
-		struct lsm_network_audit net = {0,};
-		struct sockaddr_in *addr4 = NULL;
-		struct sockaddr_in6 *addr6 = NULL;
-		unsigned short snum;
-		u32 sid, node_perm;
-
-		if (family = PF_INET) {
-			addr4 = (struct sockaddr_in *)address;
-			snum = ntohs(addr4->sin_port);
-			addrp = (char *)&addr4->sin_addr.s_addr;
-		} else {
-			addr6 = (struct sockaddr_in6 *)address;
-			snum = ntohs(addr6->sin6_port);
-			addrp = (char *)&addr6->sin6_addr.s6_addr;
-		}
-
-		if (snum) {
-			int low, high;
-
-			inet_get_local_port_range(sock_net(sk), &low, &high);
-
-			if (snum < max(PROT_SOCK, low) || snum > high) {
-				err = sel_netport_sid(sk->sk_protocol,
-						      snum, &sid);
-				if (err)
-					goto out;
-				ad.type = LSM_AUDIT_DATA_NET;
-				ad.u.net = &net;
-				ad.u.net->sport = htons(snum);
-				ad.u.net->family = family;
-				err = avc_has_perm(sksec->sid, sid,
-						   sksec->sclass,
-						   SOCKET__NAME_BIND, &ad);
-				if (err)
-					goto out;
-			}
-		}
-
-		switch (sksec->sclass) {
-		case SECCLASS_TCP_SOCKET:
-			node_perm = TCP_SOCKET__NODE_BIND;
-			break;
-
-		case SECCLASS_UDP_SOCKET:
-			node_perm = UDP_SOCKET__NODE_BIND;
-			break;
+	if (family = PF_INET || family = PF_INET6)
+		err = selinux_sk_bind(sk, address, addrlen, family);
 
-		case SECCLASS_DCCP_SOCKET:
-			node_perm = DCCP_SOCKET__NODE_BIND;
-			break;
+	return err;
+}
 
-		default:
-			node_perm = RAWIP_SOCKET__NODE_BIND;
-			break;
-		}
+int selinux_sk_connect(struct sock *sk, struct sockaddr *address,
+						    int addrlen)
+{
+	struct sk_security_struct *sksec = sk->sk_security;
+	int err;
+	struct common_audit_data ad;
+	struct lsm_network_audit net = {0,};
+	struct sockaddr_in *addr4 = NULL;
+	struct sockaddr_in6 *addr6 = NULL;
+	unsigned short snum;
+	u32 sid, perm;
+
+	if (sk->sk_family = PF_INET) {
+		addr4 = (struct sockaddr_in *)address;
+		if (addrlen < sizeof(struct sockaddr_in))
+			return -EINVAL;
+		snum = ntohs(addr4->sin_port);
+	} else {
+		addr6 = (struct sockaddr_in6 *)address;
+		if (addrlen < SIN6_LEN_RFC2133)
+			return -EINVAL;
+		snum = ntohs(addr6->sin6_port);
+	}
 
-		err = sel_netnode_sid(addrp, family, &sid);
-		if (err)
-			goto out;
+	err = sel_netport_sid(sk->sk_protocol, snum, &sid);
+	if (err)
+		goto out;
 
-		ad.type = LSM_AUDIT_DATA_NET;
-		ad.u.net = &net;
-		ad.u.net->sport = htons(snum);
-		ad.u.net->family = family;
+	if (sksec->sclass = SECCLASS_TCP_SOCKET)
+		perm = TCP_SOCKET__NAME_CONNECT;
+	else if (sksec->sclass = SECCLASS_DCCP_SOCKET)
+		perm = DCCP_SOCKET__NAME_CONNECT;
+	else if (sksec->sclass = SECCLASS_SCTP_SOCKET)
+		perm = SCTP_SOCKET__NAME_CONNECT;
 
-		if (family = PF_INET)
-			ad.u.net->v4info.saddr = addr4->sin_addr.s_addr;
-		else
-			ad.u.net->v6info.saddr = addr6->sin6_addr;
+	ad.type = LSM_AUDIT_DATA_NET;
+	ad.u.net = &net;
+	ad.u.net->dport = htons(snum);
+	ad.u.net->family = sk->sk_family;
+	err = avc_has_perm(sksec->sid, sid, sksec->sclass, perm, &ad);
 
-		err = avc_has_perm(sksec->sid, sid,
-				   sksec->sclass, node_perm, &ad);
-		if (err)
-			goto out;
-	}
 out:
 	return err;
 }
@@ -4108,48 +4200,18 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
 		return err;
 
 	/*
-	 * If a TCP or DCCP socket, check name_connect permission for the port.
+	 * If a TCP, DCCP or SCTP socket, check name_connect permission
+	 * for the port.
 	 */
 	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
-	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
-		struct common_audit_data ad;
-		struct lsm_network_audit net = {0,};
-		struct sockaddr_in *addr4 = NULL;
-		struct sockaddr_in6 *addr6 = NULL;
-		unsigned short snum;
-		u32 sid, perm;
-
-		if (sk->sk_family = PF_INET) {
-			addr4 = (struct sockaddr_in *)address;
-			if (addrlen < sizeof(struct sockaddr_in))
-				return -EINVAL;
-			snum = ntohs(addr4->sin_port);
-		} else {
-			addr6 = (struct sockaddr_in6 *)address;
-			if (addrlen < SIN6_LEN_RFC2133)
-				return -EINVAL;
-			snum = ntohs(addr6->sin6_port);
-		}
-
-		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
-		if (err)
-			goto out;
-
-		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
-		       TCP_SOCKET__NAME_CONNECT : DCCP_SOCKET__NAME_CONNECT;
-
-		ad.type = LSM_AUDIT_DATA_NET;
-		ad.u.net = &net;
-		ad.u.net->dport = htons(snum);
-		ad.u.net->family = sk->sk_family;
-		err = avc_has_perm(sksec->sid, sid, sksec->sclass, perm, &ad);
+	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
+	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
+		err = selinux_sk_connect(sk, address, addrlen);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	err = selinux_netlbl_socket_connect(sk, address);
-
-out:
 	return err;
 }
 
@@ -4200,7 +4262,9 @@ static int selinux_socket_getpeername(struct socket *sock)
 	return sock_has_perm(current, sock->sk, SOCKET__GETATTR);
 }
 
-static int selinux_socket_setsockopt(struct socket *sock, int level, int optname)
+static int selinux_socket_setsockopt(struct socket *sock, int level,
+				    int optname, char __user *optval,
+				    int optlen)
 {
 	int err;
 
@@ -4208,13 +4272,26 @@ static int selinux_socket_setsockopt(struct socket *sock, int level, int optname
 	if (err)
 		return err;
 
+	err = selinux_sctp_validate_setsockopt(sock->sk, level, optname,
+							   optval, optlen);
+	if (err)
+		return err;
+
 	return selinux_netlbl_socket_setsockopt(sock, level, optname);
 }
 
 static int selinux_socket_getsockopt(struct socket *sock, int level,
-				     int optname)
+				    int optname, char __user *optval,
+				    int __user *optlen)
 {
-	return sock_has_perm(current, sock->sk, SOCKET__GETOPT);
+	int err;
+
+	err = sock_has_perm(current, sock->sk, SOCKET__GETOPT);
+	if (err)
+		return err;
+
+	return selinux_sctp_validate_getsockopt(sock->sk, level, optname,
+							    optval, optlen);
 }
 
 static int selinux_socket_shutdown(struct socket *sock, int how)
@@ -4385,6 +4462,16 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 			selinux_netlbl_err(skb, err, 0);
 			return err;
 		}
+		/* The peer label has been validated. If SCTP class then
+		 * update sksec->peer_sid with the new peer_sid so it can be
+		 * retrieved by getpeercon(3).
+		 * Note: Because SCTP can have associations with multiple
+		 * peers, it is possible that each will have a different
+		 * peer label, therefore getpeercon(3) will only reflect the
+		 * last one processed here. */
+		if (sksec->sclass = SECCLASS_SCTP_SOCKET &&
+		    sksec->peer_sid != peer_sid)
+			sksec->peer_sid = peer_sid;
 	}
 
 	if (secmark_active) {
@@ -4407,7 +4494,12 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 	u32 peer_sid = SECSID_NULL;
 
 	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
-	    sksec->sclass = SECCLASS_TCP_SOCKET)
+	    sksec->sclass = SECCLASS_TCP_SOCKET ||
+	    sksec->sclass = SECCLASS_SCTP_SOCKET)
+		/* Note: Because SCTP can have associations with multiple
+		 * peers, it is possible that each will have a different
+		 * peer label, therefore this will only reflect the last
+		 * one processed by selinux_socket_sock_rcv_skb() */
 		peer_sid = sksec->peer_sid;
 	if (peer_sid = SECSID_NULL)
 		return -ENOPROTOOPT;
@@ -4805,6 +4897,8 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	if (sk) {
 		struct sk_security_struct *sksec;
 
+		/* Note that TCP_LISTEN equates to SCTP_SS_LISTENING
+		 * and DCCP_LISTEN socket states */
 		if (sk->sk_state = TCP_LISTEN)
 			/* if the socket is the listening state then this
 			 * packet is a SYN-ACK packet which means it needs to
@@ -4910,7 +5004,9 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	 *       TCP listening state we cannot wait until the XFRM processing
 	 *       is done as we will miss out on the SA label if we do;
 	 *       unfortunately, this means more work, but it is only once per
-	 *       connection. */
+	 *       connection.
+	 * NOTE: that TCP_LISTEN equates to SCTP_SS_LISTENING and DCCP_LISTEN
+	 * socket states */
 	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL &&
 	    !(sk != NULL && sk->sk_state = TCP_LISTEN))
 		return NF_ACCEPT;
@@ -4929,6 +5025,8 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 			secmark_perm = PACKET__SEND;
 			peer_sid = SECINITSID_KERNEL;
 		}
+	/* Note that TCP_LISTEN equates to SCTP_SS_LISTENING and DCCP_LISTEN
+	 * socket states */
 	} else if (sk->sk_state = TCP_LISTEN) {
 		/* Locally generated packet but the associated socket is in the
 		 * listening state which means this is a SYN-ACK packet.  In
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index be491a7..8ab388a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -151,5 +151,9 @@ struct security_class_mapping secclass_map[] = {
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
+	{ "sctp_socket",
+	  { COMMON_SOCK_PERMS, "node_bind", "name_connect", "bindx_add",
+	    "bindx_rem", "connectx", "peeloff", "set_addr", "set_params",
+	    NULL } },
 	{ NULL }
   };
diff --git a/security/selinux/include/sctp.h b/security/selinux/include/sctp.h
new file mode 100644
index 0000000..e5c5de2
--- /dev/null
+++ b/security/selinux/include/sctp.h
@@ -0,0 +1,66 @@
+/*
+ * SELinux SCTP Support
+ *
+ * Provides SCTP function refs for getsockopt/setsockopt in selinux/hooks.c.
+ *
+ * Author: Richard Haines <richard_c_haines@btinternet.com>
+ *
+ */
+
+/*
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#ifndef _SELINUX_SCTP_H_
+#define _SELINUX_SCTP_H_
+
+#include <linux/types.h>
+#include <linux/net.h>
+#include <net/sock.h>
+
+#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
+int selinux_sctp_validate_setsockopt(struct sock *sk,
+				    int level,
+				    int optname,
+				    char __user *optval,
+				    int optlen);
+
+int selinux_sctp_validate_getsockopt(struct sock *sk,
+				    int level,
+				    int optname,
+				    char __user *optval,
+				    int __user *optlen);
+#else
+static inline int selinux_sctp_validate_setsockopt(struct sock *sk,
+				    int level,
+				    int optname,
+				    char __user *optval,
+				    int optlen)
+{
+	return 0;
+}
+
+static inline int selinux_sctp_validate_getsockopt(struct sock *sk,
+				    int level,
+				    int optname,
+				    char __user *optval,
+				    int __user *optlen)
+{
+	return 0;
+}
+#endif  /* CONFIG_IP_SCTP */
+
+#endif
diff --git a/security/selinux/include/sctp_private.h b/security/selinux/include/sctp_private.h
new file mode 100644
index 0000000..25dbaa3
--- /dev/null
+++ b/security/selinux/include/sctp_private.h
@@ -0,0 +1,46 @@
+/*
+ * SELinux SCTP Support
+ *
+ * Provides headers + extern selinux/hooks.c functions for selinux/sctp.c.
+ *
+ * Author: Richard Haines <richard_c_haines@btinternet.com>
+ *
+ */
+
+/*
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <linux/sctp.h>
+#include <uapi/linux/sctp.h>	/* For bindx setsocket option checks */
+
+#include "security.h"
+#include "avc.h"
+
+extern int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms);
+
+extern int selinux_sk_bind(struct sock *sk, struct sockaddr *address,
+				    int addrlen, u16 family);
+
+extern int selinux_sk_connect(struct sock *sk, struct sockaddr *address,
+						    int addrlen);
+
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 0364120..0b04c8a 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -396,13 +396,23 @@ int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
 	case SECCLASS_TCP_SOCKET:
 		perm = TCP_SOCKET__RECVFROM;
 		break;
+	case SECCLASS_SCTP_SOCKET:
+		perm = SCTP_SOCKET__RECVFROM;
+		break;
 	default:
 		perm = RAWIP_SOCKET__RECVFROM;
 	}
 
 	rc = avc_has_perm(sksec->sid, nlbl_sid, sksec->sclass, perm, ad);
-	if (rc = 0)
+	if (rc = 0) {
+		/* The peer label has been validated in compat mode.
+		 * If SCTP class then update sksec->peer_sid with the
+		 * nlbl_sid so it can be retrieved by getpeercon(3). */
+		if (sksec->sclass = SECCLASS_SCTP_SOCKET &&
+		    sksec->peer_sid != nlbl_sid)
+			sksec->peer_sid = nlbl_sid;
 		return 0;
+	}
 
 	if (nlbl_sid != SECINITSID_UNLABELED)
 		netlbl_skbuff_err(skb, rc, 0);
diff --git a/security/selinux/sctp.c b/security/selinux/sctp.c
new file mode 100644
index 0000000..1bd98a2
--- /dev/null
+++ b/security/selinux/sctp.c
@@ -0,0 +1,318 @@
+/*
+ * SELinux SCTP Support
+ *
+ * Provides security checks for the SCTP protocol.
+ *
+ * Author: Richard Haines <richard_c_haines@btinternet.com>
+ *
+ */
+
+/*
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include "sctp_private.h"	/* #include files + extern functions. */
+
+/**
+ * validate_sctp_addrs - Validate bindx and connectx addresses.
+ * @sk: the socket
+ * @optname: contains the name of the option to validate
+ * @addrs: structure containing one or more SCTP addresses
+ * @len: contains the length of the structure
+ *
+ * Description:
+ * This function will copy down the SCTP bindx and connectx addresses then
+ * check the appropriate permissions on each one via selinux_sk_bind() or
+ * selinux_sk_connect(). The code is a modified version from
+ * net/sctp/socket.c.
+ * Returns zero on success, negative values on failure.
+*/
+static int validate_sctp_addrs(struct sock *sk, int optname,
+				    struct sockaddr *addrs,
+				    int len)
+{
+	struct sockaddr *kaddrs;
+	int addrlen, err;
+	void *addr_buf;
+	struct sockaddr *address;
+	int walk_size = 0;
+
+	/* Copy down the address information to process. */
+	if (unlikely(len <= 0))
+		return -EINVAL;
+
+	/* Check the user passed a healthy pointer.  */
+	if (unlikely(!access_ok(VERIFY_READ, addrs, (unsigned int)len)))
+		return -EFAULT;
+
+	/* Alloc space for the info in kernel memory.  */
+	kaddrs = kmalloc((unsigned int)len, GFP_KERNEL);
+	if (unlikely(!kaddrs))
+		return -ENOMEM;
+
+	if (__copy_from_user(kaddrs, addrs, (unsigned int)len)) {
+		kfree(kaddrs);
+		return -EFAULT;
+	}
+
+	addr_buf = kaddrs;
+	/* Process list - may contain IPv4 or IPv6 addr's */
+	while (walk_size < (unsigned int)len) {
+		address = addr_buf;
+
+		switch (address->sa_family) {
+		case PF_INET:
+			addrlen = sizeof(struct sockaddr_in);
+			break;
+		case PF_INET6:
+			addrlen = sizeof(struct sockaddr_in6);
+			break;
+		default:
+			kfree(kaddrs);
+			return -EINVAL;
+		}
+
+		err = -EINVAL;
+		if (optname = SCTP_SOCKOPT_BINDX_ADD) {
+			pr_info("SELinux: bindx addr: %pISpc\n", address);
+			err = selinux_sk_bind(sk, address,
+				    addrlen,
+				    address->sa_family);
+		} else if (optname = SCTP_SOCKOPT_CONNECTX ||
+			   optname = SCTP_SOCKOPT_CONNECTX3 ||
+			   optname = SCTP_SOCKOPT_CONNECTX_OLD) {
+			pr_info("SELinux: connectx addr: %pISpc\n", address);
+			err = selinux_sk_connect(sk, address,
+				    addrlen);
+		}
+		if (err) {
+			kfree(kaddrs);
+			return err;
+		}
+		addr_buf += addrlen;
+		walk_size += addrlen;
+	}
+	kfree(kaddrs);
+	return 0;
+}
+
+/**
+ * selinux_sctp_validate_setsockopt - Check setsockopt values.
+ * @sk: the socket
+ * @level: contains the protocol level to validate
+ * @optname: contains the name of the option to validate
+ * @optval: contains the value(s) to set
+ * @optlen: contains the length of the value(s) to be set
+ *
+ * Description:
+ * Check whether SCTP socket options are allowed or not. Returns zero on
+ * success, negative values on failure.
+ *
+ * Supports the following socket options:
+ *
+ *    SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
+ *    associated after (optionally) calling bind(3).
+ *    sctp_bindx(3) - adds or removes a set of bind addresses on a socket.
+ *
+ *    SCTP_SOCKOPT_CONNECTX/_OLD - Allows the allocation of multiple
+ *    addresses for reaching a peer (multi-homed).
+ *    sctp_connectx(3) - initiate a connection on an SCTP socket using
+ *    multiple destination addresses.
+ *    NOTE: SCTP_SOCKOPT_CONNECTX3 is handled by the
+ *    selinux_sctp_validate_getsockopt() function is it may return an
+ *    association id.
+ *
+ *  Together they form SCTP associations with the address(s) passed over the
+ *  link to inform peer of any changes. As these two options can support
+ *  multiple addresses, each address is checked via selinux_sk_bind() or
+ *  selinux_sk_connect() to determine whether they have the correct
+ *  permissions:
+ *     bindx_add: name_bind, node_bind + node SID + port SID via
+ *                (portcon sctp port ctx) policy statement.
+ *     connectx:  name_connect + port SID via (portcon sctp port ctx)
+ *
+ *    SCTP_SOCKOPT_BINDX_REM - As the addresses have already been
+ *    allowed, only the bindx_rem permission is checked.
+ *
+ *    SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max
+ *    retransmissions.
+ *    SCTP_PEER_ADDR_THLDS - Alter the thresholds.
+ *  These require the set_params permission.
+ *
+ *    SCTP_PRIMARY_ADDR - Set local primary address.
+ *    SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
+ *    association primary.
+ *  These require the set_addr permission.
+*/
+int selinux_sctp_validate_setsockopt(struct sock *sk, int level, int optname,
+				    char __user *optval, int optlen)
+{
+	int err;
+
+	if (level = SOL_SCTP) {
+		switch (optname) {
+		/* Allows additional addresses to be associated or removed
+		 * with an endpoint after (optionally) calling bind(). */
+		case SCTP_SOCKOPT_BINDX_ADD:
+			err = sock_has_perm(current, sk,
+			    SCTP_SOCKET__BINDX_ADD);
+			if (err)
+				return err;
+
+			err = validate_sctp_addrs(sk, optname,
+				    (struct sockaddr __user *)optval, optlen);
+			if (err)
+				return err;
+			break;
+
+		case SCTP_SOCKOPT_BINDX_REM:
+			/* The addresses have been checked as they were
+			 * added, so just see if allowed to be removed. */
+			err = sock_has_perm(current, sk,
+			    SCTP_SOCKET__BINDX_REM);
+			if (err)
+				return err;
+			break;
+
+		/* Allows the allocation of multiple addresses for reaching
+		 * a peer (multi-homed). They form an SCTP "association".
+		 * Note: CONNECTX3 requests go via getsockoption as it can
+		 * return an association id if required. */
+		case SCTP_SOCKOPT_CONNECTX:	/* CONNECTX requests. */
+		case SCTP_SOCKOPT_CONNECTX_OLD:	/* CONNECTX old requests. */
+			err = sock_has_perm(current, sk,
+			    SCTP_SOCKET__CONNECTX);
+			if (err)
+				return err;
+
+			err = validate_sctp_addrs(sk, optname,
+				    (struct sockaddr __user *)optval, optlen);
+			if (err)
+				return err;
+			break;
+
+		/* Alter heartbeats and address max retransmissions. */
+		case SCTP_PEER_ADDR_PARAMS:
+		/* Alter the thresholds. */
+		case SCTP_PEER_ADDR_THLDS:
+			err = sock_has_perm(current, sk,
+				    SCTP_SOCKET__SET_PARAMS);
+			if (err)
+				return err;
+			break;
+
+		/* Set local primary address. */
+		case SCTP_PRIMARY_ADDR:
+		/* Request peer sets address as association primary. */
+		case SCTP_SET_PEER_PRIMARY_ADDR:
+			err = sock_has_perm(current, sk,
+				    SCTP_SOCKET__SET_ADDR);
+			if (err)
+				return err;
+			break;
+
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
+/**
+ * selinux_sctp_validate_getsockopt - Check getsockopt values.
+ * @sk: the socket
+ * @level: contains the protocol level to validate
+ * @optname: contains the name of the option to validate
+ * @optval: contains the value(s) to get
+ * @optlen: contains the length of the value(s) to get
+ *
+ * Description:
+ * Check whether SCTP socket options are allowed or not. Returns zero on
+ * success, negative values on failure.
+ *
+ * Supports the following socket options:
+ *
+ *    SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket
+ *    that will be a one-to-one style socket. As SELinux already handles
+ *    the creation of new sockets, only the peeloff permission is checked.
+ *
+ *    SCTP_SOCKOPT_CONNECTX3 - Allows the allocation of multiple
+ *    addresses for reaching a peer (multi-homed).
+ *    sctp_connectx(3) - initiate a connection on an SCTP socket using
+ *    multiple destination addresses. See comments in
+ *    selinux_sctp_validate_setsockopt() for more detail.
+ *    NOTES: 1) This option is a 'getsockopt' as it may also return an
+ *              association id.
+ *           2) This option requires some manipulation as the address
+ *              location and size are contained in 'struct sctp_getaddrs_old'
+ *              These need to be extracted and passed to the common
+ *              validate_sctp_addrs() function.
+*/
+int selinux_sctp_validate_getsockopt(struct sock *sk,
+				    int level,
+				    int optname,
+				    char __user *optval,
+				    int __user *optlen)
+{
+	int err;
+
+	if (level = SOL_SCTP) {
+		struct sctp_getaddrs_old param;
+		int len;
+
+		switch (optname) {
+		/* Branch off an association into a new socket. */
+		case SCTP_SOCKOPT_PEELOFF:
+			err = sock_has_perm(current, sk,
+			    SCTP_SOCKET__PEELOFF);
+			if (err)
+				return err;
+			break;
+
+		case SCTP_SOCKOPT_CONNECTX3:
+			err = sock_has_perm(current, sk,
+			    SCTP_SOCKET__CONNECTX);
+			if (err)
+				return err;
+
+			/* The optval contains struct sctp_getaddrs_old that
+			 * is then used to reference the addresses to be
+			 * validated. */
+			/* TODO net/sctp/socket.c sctp_getsockopt_connectx3()
+			 * has #ifdef CONFIG_COMPAT with different code.
+			 * Need to determine if needed here as not currently
+			 * implemented. */
+
+			if (get_user(len, optlen))
+				return -EFAULT;
+			if (len < sizeof(param))
+				return -EINVAL;
+			if (copy_from_user(&param, optval, sizeof(param)))
+				return -EFAULT;
+
+			len = param.addr_num;
+			err = validate_sctp_addrs(sk, optname,
+			    (struct sockaddr __user *)param.addrs, len);
+			if (err)
+				return err;
+			break;
+
+		default:
+			break;
+		}
+	}
+	return 0;
+}
-- 
1.9.3

