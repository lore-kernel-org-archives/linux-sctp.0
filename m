From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Apr 2016 04:06:28 +0000
Subject: [PATCH net-next 3/7] sctp: export some functions for sctp_diag in inet_diag
Message-Id: <d16e3f12f689f28d8c3b62c7c2a15916177bd7c0.1459829123.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1459829123.git.lucien.xin@gmail.com>
 <c507274a984bd1b0a7e7a59d1e825352536efd25.1459829123.git.lucien.xin@gmail.com>
 <c99aafbc687328f783c0777e10df3e207004db10.1459829123.git.lucien.xin@gmail.com>
In-Reply-To: <c99aafbc687328f783c0777e10df3e207004db10.1459829123.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

inet_diag_msg_common_fill is used to fill the diag msg common info,
we need to use it in sctp_diag as well, so export it.

We also add inet_diag_get_handler() to access inet_diag_table in sctp
diag.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/inet_diag.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index bd591eb..29121a6 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -66,7 +66,13 @@ static void inet_diag_unlock_handler(const struct inet_diag_handler *handler)
 	mutex_unlock(&inet_diag_table_mutex);
 }
 
-static void inet_diag_msg_common_fill(struct inet_diag_msg *r, struct sock *sk)
+struct inet_diag_handler *inet_diag_get_handler(int proto)
+{
+	return inet_diag_table[proto];
+}
+EXPORT_SYMBOL_GPL(inet_diag_get_handler);
+
+void inet_diag_msg_common_fill(struct inet_diag_msg *r, struct sock *sk)
 {
 	r->idiag_family = sk->sk_family;
 
@@ -89,6 +95,7 @@ static void inet_diag_msg_common_fill(struct inet_diag_msg *r, struct sock *sk)
 	r->id.idiag_dst[0] = sk->sk_daddr;
 	}
 }
+EXPORT_SYMBOL_GPL(inet_diag_msg_common_fill);
 
 static size_t inet_sk_attr_size(void)
 {
-- 
2.1.0

