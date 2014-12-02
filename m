From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 02 Dec 2014 14:15:30 +0000
Subject: [RFC-PATCH 1/3] security: Extend security get/setsockopt entries
Message-Id: <1417529730-2602-1-git-send-email-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org

Extend security_socket_getsockopt and security_socket_setsockopt to support
optname and optval parameters.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 include/linux/security.h | 24 ++++++++++++++++++------
 security/capability.c    |  6 ++++--
 security/security.c      | 12 ++++++++----
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 623f90e..6e18b0f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -940,6 +940,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@sock contains the socket structure.
  *	@level contains the protocol level to retrieve option from.
  *	@optname contains the name of option to retrieve.
+ *	@optval contains the value(s) retrieved.
+ *	@optlen contains the length of the value(s) retrieved.
  *	Return 0 if permission is granted.
  * @socket_setsockopt:
  *	Check permissions before setting the options associated with socket
@@ -947,6 +949,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@sock contains the socket structure.
  *	@level contains the protocol level to set options for.
  *	@optname contains the name of the option to set.
+ *	@optval contains the value(s) to set.
+ *	@optlen contains the length of the value(s) to be set.
  *	Return 0 if permission is granted.
  * @socket_shutdown:
  *	Checks permission before all or part of a connection on the socket
@@ -1664,8 +1668,10 @@ struct security_operations {
 			       struct msghdr *msg, int size, int flags);
 	int (*socket_getsockname) (struct socket *sock);
 	int (*socket_getpeername) (struct socket *sock);
-	int (*socket_getsockopt) (struct socket *sock, int level, int optname);
-	int (*socket_setsockopt) (struct socket *sock, int level, int optname);
+	int (*socket_getsockopt) (struct socket *sock, int level, int optname,
+				    char __user *optval, int __user *optlen);
+	int (*socket_setsockopt) (struct socket *sock, int level, int optname,
+				    char __user *optval, int optlen);
 	int (*socket_shutdown) (struct socket *sock, int how);
 	int (*socket_sock_rcv_skb) (struct sock *sk, struct sk_buff *skb);
 	int (*socket_getpeersec_stream) (struct socket *sock, char __user *optval, int __user *optlen, unsigned len);
@@ -2648,8 +2654,10 @@ int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags);
 int security_socket_getsockname(struct socket *sock);
 int security_socket_getpeername(struct socket *sock);
-int security_socket_getsockopt(struct socket *sock, int level, int optname);
-int security_socket_setsockopt(struct socket *sock, int level, int optname);
+int security_socket_getsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int __user *optlen);
+int security_socket_setsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int optlen);
 int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
@@ -2756,13 +2764,17 @@ static inline int security_socket_getpeername(struct socket *sock)
 }
 
 static inline int security_socket_getsockopt(struct socket *sock,
-					     int level, int optname)
+					     int level, int optname,
+					     char __user *optval,
+					     int __user *optlen)
 {
 	return 0;
 }
 
 static inline int security_socket_setsockopt(struct socket *sock,
-					     int level, int optname)
+					     int level, int optname,
+					     char __user *optval,
+					     int optlen)
 {
 	return 0;
 }
diff --git a/security/capability.c b/security/capability.c
index a74fde6..cef663e 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -638,12 +638,14 @@ static int cap_socket_getpeername(struct socket *sock)
 	return 0;
 }
 
-static int cap_socket_setsockopt(struct socket *sock, int level, int optname)
+static int cap_socket_setsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int optlen)
 {
 	return 0;
 }
 
-static int cap_socket_getsockopt(struct socket *sock, int level, int optname)
+static int cap_socket_getsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int __user *optlen)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index e41b1a8..e00610c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1197,14 +1197,18 @@ int security_socket_getpeername(struct socket *sock)
 	return security_ops->socket_getpeername(sock);
 }
 
-int security_socket_getsockopt(struct socket *sock, int level, int optname)
+int security_socket_getsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int __user *optlen)
 {
-	return security_ops->socket_getsockopt(sock, level, optname);
+	return security_ops->socket_getsockopt(sock, level, optname,
+				    optval, optlen);
 }
 
-int security_socket_setsockopt(struct socket *sock, int level, int optname)
+int security_socket_setsockopt(struct socket *sock, int level, int optname,
+				    char __user *optval, int optlen)
 {
-	return security_ops->socket_setsockopt(sock, level, optname);
+	return security_ops->socket_setsockopt(sock, level, optname,
+				    optval, optlen);
 }
 
 int security_socket_shutdown(struct socket *sock, int how)
-- 
1.9.3

