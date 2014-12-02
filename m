From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 02 Dec 2014 14:15:47 +0000
Subject: [RFC-PATCH 2/3] net: Extend security get/setsockopt entries
Message-Id: <1417529747-2643-1-git-send-email-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org

Extend security_socket_getsockopt and security_socket_setsockopt to support
optname and optval parameters.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 net/compat.c | 6 ++++--
 net/socket.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index bc8aeef..6341f04 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -392,7 +392,8 @@ COMPAT_SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 	struct socket *sock = sockfd_lookup(fd, &err);
 
 	if (sock) {
-		err = security_socket_setsockopt(sock, level, optname);
+		err = security_socket_setsockopt(sock, level, optname, optval,
+					    optlen);
 		if (err) {
 			sockfd_put(sock);
 			return err;
@@ -512,7 +513,8 @@ COMPAT_SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 	struct socket *sock = sockfd_lookup(fd, &err);
 
 	if (sock) {
-		err = security_socket_getsockopt(sock, level, optname);
+		err = security_socket_getsockopt(sock, level, optname,
+					optval, optlen);
 		if (err) {
 			sockfd_put(sock);
 			return err;
diff --git a/net/socket.c b/net/socket.c
index 4cdbc10..12ee18e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1910,7 +1910,8 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_setsockopt(sock, level, optname);
+		err = security_socket_setsockopt(sock, level, optname, optval,
+					    optlen);
 		if (err)
 			goto out_put;
 
@@ -1941,7 +1942,8 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_getsockopt(sock, level, optname);
+		err = security_socket_getsockopt(sock, level, optname, optval,
+						  optlen);
 		if (err)
 			goto out_put;
 
-- 
1.9.3

