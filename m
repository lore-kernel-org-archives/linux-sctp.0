From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 24 Dec 2013 13:19:42 +0000
Subject: [RFC PATCH net-next 2/3] net: sock: add sk_copy_sanitize for use in modules
Message-Id: <1387891183-21169-3-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Combine socket copy and sanitise routines and export them, so that
it can be used in modules such as SCTP.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sock.h |  1 +
 net/core/sock.c    | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2ef3c3e..1789690 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1532,6 +1532,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 void sk_free(struct sock *sk);
 void sk_release_kernel(struct sock *sk);
 struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority);
+struct sock *sk_copy_sanitize(struct sock *nsk, const struct sock *osk);
 
 struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
 			     gfp_t priority);
diff --git a/net/core/sock.c b/net/core/sock.c
index 68a4251..46920a3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1520,6 +1520,13 @@ void sk_release_kernel(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_release_kernel);
 
+struct sock *sk_copy_sanitize(struct sock *nsk, const struct sock *osk)
+{
+	sock_copy(nsk, osk);
+	return sock_sanitize(nsk, osk);
+}
+EXPORT_SYMBOL_GPL(sk_copy_sanitize);
+
 /**
  *	sk_clone_lock - clone a socket, and lock its clone
  *	@sk: the socket to clone
@@ -1532,12 +1539,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	struct sock *newsk;
 
 	newsk = sk_prot_alloc(sk->sk_prot, priority, sk->sk_family);
-	if (newsk = NULL)
+	if (unlikely(newsk = NULL))
 		return NULL;
-
-	sock_copy(newsk, sk);
-
-	return sock_sanitize(newsk, sk);
+	else
+		return sk_copy_sanitize(newsk, sk);
 }
 EXPORT_SYMBOL_GPL(sk_clone_lock);
 
-- 
1.8.3.1

