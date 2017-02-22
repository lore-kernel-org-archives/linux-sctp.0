From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 22 Feb 2017 17:03:30 +0000
Subject: [RFC v2 PATCH 1/2] kernel: Add LSM hooks for SCTP support
Message-Id: <20170222170330.5379-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

Add four new SCTP hooks that are detailed in:
Documentation/security/LSM-sctp.txt

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 Documentation/security/LSM-sctp.txt | 171 ++++++++++++++++++++++++++++++++++++
 include/linux/lsm_hooks.h           |  37 ++++++++
 include/linux/security.h            |  33 +++++++
 security/security.c                 |  34 +++++++
 4 files changed, 275 insertions(+)
 create mode 100644 Documentation/security/LSM-sctp.txt

diff --git a/Documentation/security/LSM-sctp.txt b/Documentation/security/LSM-sctp.txt
new file mode 100644
index 0000000..a96ad0a
--- /dev/null
+++ b/Documentation/security/LSM-sctp.txt
@@ -0,0 +1,171 @@
+                               SCTP LSM Support
+                              =========
+
+For security module support, four new sctp specific hooks have been
+implemented:
+    security_sctp_assoc_request()
+    security_sctp_accept_conn()
+    security_sctp_sk_clone()
+    security_sctp_addr_list()
+
+The usage of these hooks are described below with further information
+available in include/linux/lsm_hooks.h. The SELinux implementation is
+described in Documentation/security/SELinux-sctp.txt
+
+
+security_sctp_assoc_request()
+------------------------------
+This new hook has been added to net/sctp/sm_statefuns.c where it passes the
+@sk and @chunk->skb (the association INIT or INIT ACK packet) to the security
+module. Returns 0 on success, error on failure.
+
+    @sk  - pointer to sock structure.
+    @skb - pointer to skbuff of association packet (INIT or INIT ACK)
+
+The security module performs two operations:
+  1) If this is the first association on @sk, then set the peer sid
+     to that in @skb. This will ensure that there is only one peer sid
+     assigned to @sk that may support multiple associations.
+
+  2) Validate the @sk sid against the @sk peer sid to determine whether the
+     association should be allowed or denied.
+
+
+security_sctp_accept_conn()
+----------------------------
+This new hook has been added to net/sctp/sm_statefuns.c where it sets the
+sctp endpoint @ep->secid to the socket's sid (@ep->base.sk) with the MLS
+portion taken from the COOKIE ECHO packet @skb peer sid. Returns 0 on success,
+error on failure.
+
+    @ep  - pointer to sctp endpoint structure.
+    @skb - pointer to skbuff of the COOKIE ECHO packet.
+
+To support this hook include/net/sctp/structs.h "struct sctp_endpoint" has
+been updated with the following:
+
+	/* Security identifiers from incoming (COOKIE-ECHO) connection.
+	 * These are set by security_sctp_accept_conn() and used by
+	 * security_sctp_sk_clone() to set sids on newsock.
+	 */
+	u32 secid;
+	u32 peer_secid;
+
+
+security_sctp_sk_clone()
+-------------------------
+This new hook has been added to net/sctp/socket.c sctp_sock_migrate() that is
+called whenever a new socket is created for accept(2) (i.e. a TCP type socket)
+or when a socket is 'peeled off' e.g userspace calling sctp_peeloff(3).
+security_sctp_sk_clone() will set the new sockets sid and peer sid to that
+contained in the old @ep sid and peer sid respectively.
+
+    @ep - pointer to old sctp endpoint structure.
+    @sk - pointer to old sock structure.
+    @sk - pointer to new sock structure.
+
+
+security_sctp_addr_list()
+--------------------------
+This new hook has been added to net/sctp/socket.c and net/sctp/sm_make_chunk.c.
+It passes one or more ipv4/ipv6 addresses to the security module for
+validation based on the @optname as shown in the permission check tables below.
+Returns 0 on success, error on failure.
+
+    @sk      - Pointer to sock structure.
+    @optname - Name of the option to validate.
+    @address - One or more ipv4 / ipv6 addresses.
+    @addrlen - The total length of address(s). This is calculated on each
+               ipv4 or ipv6 address using sizeof(struct sockaddr_in) or
+               sizeof(struct sockaddr_in6).
+
+  ------------------------------------------------------------------
+  |                     BIND Type Checks                           |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_SOCKOPT_BINDX_ADD     | One or more ipv4 / ipv6 addresses |
+  | SCTP_PRIMARY_ADDR          | Single ipv4 or ipv6 address       |
+  | SCTP_SET_PEER_PRIMARY_ADDR | Single ipv4 or ipv6 address       |
+  ------------------------------------------------------------------
+
+  ------------------------------------------------------------------
+  |                   CONNECT Type Checks                          |
+  |       @optname             |         @address contains         |
+  |----------------------------|-----------------------------------|
+  | SCTP_SOCKOPT_CONNECTX      | One or more ipv4 / ipv6 addresses |
+  | SCTP_PARAM_ADD_IP          | One or more ipv4 / ipv6 addresses |
+  | SCTP_PARAM_SET_PRIMARY     | Single ipv4 or ipv6 address       |
+  ------------------------------------------------------------------
+
+
+Security Hooks used for Association Establishment
+=========================
+The following diagram shows the use of security_sctp_assoc_request(),
+security_sctp_accept_conn() in net/sctp/sm_statefuns.c and
+security_sctp_sk_clone() in net/sctp/socket.c, when establishing an
+association.
+
+      SCTP endpoint "A"                                SCTP endpoint "Z"
+      =========                                ========+    sctp_sf_do_prm_asoc()
+ Initiate an association to
+ SCTP peer endpoint "Z".
+ Send INIT first as we need to obtain
+ a peer label before checking whether
+ this is allowed or not. This will be
+ checked once the INIT ACK has been
+ received.
+         INIT --------------------------------------------->
+                                                   sctp_sf_do_5_1B_init()
+                                                 Respond to an INIT chunk.
+                                             SCTP peer endpoint "A" is
+                                             asking for an association. Call
+                                             security_sctp_assoc_request()
+                                             to set the peer label if first
+                                             association, then check
+                                             if association is allowed or not.
+                                             IF allowed send:
+          <----------------------------------------------- INIT ACK
+          |                                  ELSE audit event and silently
+          |                                       discard the packet.
+    sctp_sf_do_5_1C_ack
+ Respond to an INIT ACK chunk.
+ SCTP peer endpoint"A" initiated
+ this association to SCTP peer
+ endpoint "Z". The security checks
+ are done now as we have a peer
+ label to check against, so call
+ security_sctp_assoc_request()
+ to set the peer label if first
+ association, then check if
+ association is allowed or not.
+ IF allowed send:
+    COOKIE ECHO ------------------------------------------>
+ ELSE audit event and silently                            |
+      discard the packet.                                 |
+                                                          |
+                                                 sctp_sf_do_5_1D_ce
+                                             Call security_sctp_accept_conn()
+                                             This sets the sctp endpoint sid
+                                             to the socket's sid with the
+                                             MLS portion taken from the
+                                             COOKIE ECHO packet peer sid.
+                                             IF ok send:
+          <------------------------------------------- COOKIE ACK
+          |                                  ELSE silently discard the packet.
+          |                                               |
+          |                                               |
+          |                               net/sctp/socket.c sctp_sock_migrate()
+          |                                   If SCTP_SOCKET_TCP or peeled off
+          |                                   socket security_sctp_sk_clone()
+          |                                   is called to clone the new socket
+          |                                   with the saved endpoint sid and
+          |                                   peer sid.
+          |                                               |
+      ESTABLISHED                                    ESTABLISHED
+          |                                               |
+    ------------------------------------------------------------------
+    |                     Association Established                    |
+    ------------------------------------------------------------------
+
+
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 558adfa..160c952 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -902,6 +902,33 @@
  *	This hook can be used by the module to update any security state
  *	associated with the TUN device's security structure.
  *	@security pointer to the TUN devices's security structure.
+ * @sctp_assoc_request:
+ *	If first association on @sk, then set the peer sid to that in @skb.
+ *	@sk pointer to sock structure.
+ *	@skb pointer to skbuff of association packet (INIT or INIT ACK)
+ *	being queried.
+ *	Return 0 on success, error on failure.
+ * @sctp_accept_conn:
+ *	Sets the sctp endpoint sid to socket's sid (ep->base.sk) with MLS
+ *	portion taken from peer sid.
+ *	@ep pointer to sctp endpoint structure.
+ *	@skb pointer to skbuff of the COOKIE ECHO packet.
+ *	Return 0 on success, error on failure.
+ * @sctp_sk_clone:
+ *	Sets the new child socket's sid to the old endpoint sid.
+ *	@ep pointer to old sctp endpoint structure.
+ *	@sk pointer to old sock structure.
+ *	@sk pointer to new sock structure.
+ * @sctp_addr_list:
+ *	Check permissions required for each address before setting option
+ *      associated with sock @sk. The @addrlen is calculated on each ipv4
+ *	and ipv6 address using sizeof(struct sockaddr_in) or
+ *	sizeof(struct sockaddr_in6).
+ *	@sk pointer to sock structure.
+ *	@optname name of the option to validate.
+ *	@address list containing one or more ipv4/ipv6 addresses.
+ *	@addrlen total length of address(s).
+ *	Return 0 on success, error on failure.
  *
  * Security hooks for XFRM operations.
  *
@@ -1609,6 +1636,12 @@ union security_list_options {
 	int (*tun_dev_attach_queue)(void *security);
 	int (*tun_dev_attach)(struct sock *sk, void *security);
 	int (*tun_dev_open)(void *security);
+	int (*sctp_assoc_request)(struct sock *sk, struct sk_buff *skb);
+	int (*sctp_accept_conn)(struct sctp_endpoint *ep, struct sk_buff *skb);
+	void (*sctp_sk_clone)(struct sctp_endpoint *ep, struct sock *sk,
+			      struct sock *newsk);
+	int (*sctp_addr_list)(struct sock *sk, int optname,
+			      struct sockaddr *address, int addrlen);
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
@@ -1840,6 +1873,10 @@ struct security_hook_heads {
 	struct list_head tun_dev_attach_queue;
 	struct list_head tun_dev_attach;
 	struct list_head tun_dev_open;
+	struct list_head sctp_assoc_request;
+	struct list_head sctp_accept_conn;
+	struct list_head sctp_sk_clone;
+	struct list_head sctp_addr_list;
 #endif	/* CONFIG_SECURITY_NETWORK */
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	struct list_head xfrm_policy_alloc_security;
diff --git a/include/linux/security.h b/include/linux/security.h
index c2125e9..37b0032 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -109,6 +109,7 @@ struct xfrm_policy;
 struct xfrm_state;
 struct xfrm_user_sec_ctx;
 struct seq_file;
+struct sctp_endpoint;
 
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
@@ -1199,6 +1200,12 @@ int security_tun_dev_create(void);
 int security_tun_dev_attach_queue(void *security);
 int security_tun_dev_attach(struct sock *sk, void *security);
 int security_tun_dev_open(void *security);
+int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb);
+int security_sctp_accept_conn(struct sctp_endpoint *ep, struct sk_buff *skb);
+void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+			    struct sock *newsk);
+int security_sctp_addr_list(struct sock *sk, int optname,
+			    struct sockaddr *address, int addrlen);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1391,6 +1398,32 @@ static inline int security_tun_dev_open(void *security)
 {
 	return 0;
 }
+
+static inline int security_sctp_assoc_request(struct sock *sk,
+					      struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int security_sctp_accept_conn(struct sctp_endpoint *ep,
+					    struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline void security_sctp_sk_clone(struct sctp_endpoint *ep,
+					  struct sock *sk,
+					  struct sock *newsk)
+{
+	return 0;
+}
+
+static inline int security_sctp_addr_list(struct sock *sk, int optname,
+					  struct sockaddr *address,
+					  int addrlen)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
diff --git a/security/security.c b/security/security.c
index f825304..ab0a1cb 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1439,6 +1439,32 @@ int security_tun_dev_open(void *security)
 }
 EXPORT_SYMBOL(security_tun_dev_open);
 
+int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
+{
+	return call_int_hook(sctp_assoc_request, 0, sk, skb);
+}
+EXPORT_SYMBOL(security_sctp_assoc_request);
+
+int security_sctp_accept_conn(struct sctp_endpoint *ep, struct sk_buff *skb)
+{
+	return call_int_hook(sctp_accept_conn, 0, ep, skb);
+}
+EXPORT_SYMBOL(security_sctp_accept_conn);
+
+void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
+			    struct sock *newsk)
+{
+	call_void_hook(sctp_sk_clone, ep, sk, newsk);
+}
+EXPORT_SYMBOL(security_sctp_sk_clone);
+
+int security_sctp_addr_list(struct sock *sk, int optname,
+			    struct sockaddr *address, int addrlen)
+{
+	return call_int_hook(sctp_addr_list, 0, sk, optname, address, addrlen);
+}
+EXPORT_SYMBOL(security_sctp_addr_list);
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
@@ -1897,6 +1923,14 @@ struct security_hook_heads security_hook_heads = {
 	.tun_dev_attach  		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach),
 	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
+	.sctp_assoc_request +		LIST_HEAD_INIT(security_hook_heads.sctp_assoc_request),
+	.sctp_accept_conn +		LIST_HEAD_INIT(security_hook_heads.sctp_accept_conn),
+	.sctp_sk_clone +		LIST_HEAD_INIT(security_hook_heads.sctp_sk_clone),
+	.sctp_addr_list +		LIST_HEAD_INIT(security_hook_heads.sctp_addr_list),
 #endif	/* CONFIG_SECURITY_NETWORK */
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	.xfrm_policy_alloc_security -- 
2.9.3

