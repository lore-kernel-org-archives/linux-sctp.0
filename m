From: Henry Ptasinski <hptasinski@google.com>
Date: Fri, 18 Sep 2020 01:56:10 +0000
Subject: [PATCH] net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant
Message-Id: <20200918015610.3596417-1-hptasinski@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Corey Minyard <cminyard@mvista.com>, Henry Ptasinski <hptasinski@google.com>

When calculating ancestor_size with IPv6 enabled, simply using
sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
alignment in the struct sctp6_sock. On x86, there aren't any extra
bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
boundary so there were 4 pad bytes that were omitted from the
ancestor_size calculation.  This would lead to corruption of the
pd_lobby pointers, causing an oops when trying to free the sctp
structure on socket close.

Signed-off-by: Henry Ptasinski <hptasinski@google.com>
---
 net/sctp/socket.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 836615f71a7d..a6358c81f087 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9220,12 +9220,14 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 static inline void sctp_copy_descendant(struct sock *sk_to,
 					const struct sock *sk_from)
 {
-	int ancestor_size = sizeof(struct inet_sock) +
-			    sizeof(struct sctp_sock) -
-			    offsetof(struct sctp_sock, pd_lobby);
+	size_t ancestor_size = sizeof(struct inet_sock);
 
 	if (sk_from->sk_family = PF_INET6)
-		ancestor_size += sizeof(struct ipv6_pinfo);
+		ancestor_size += sizeof(struct sctp6_sock);
+	else
+		ancestor_size += sizeof(struct sctp_sock);
+
+	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
 
 	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
 }
-- 
2.28.0.681.g6f77f65b4e-goog
