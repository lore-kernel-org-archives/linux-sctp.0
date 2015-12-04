From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 04 Dec 2015 17:14:05 +0000
Subject: [PATCH net 3/3] sctp: also copy sk_tsflags when copying the socket
Message-Id: <ff20b0d68e8652db4406e4b19c93404f9c32637a.1449249050.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20151203184316.GF4164@mrl.redhat.com> <cover.1449249050.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1449249050.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Eric Dumazet <eric.dumazet@gmail.com>, syzkaller <syzkaller@googlegroups.com>, linux-sctp@vger.kernel.org, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>, Dmitry Vyukov <dvyukov@google.com>

As we are keeping timestamps on when copying the socket, we also have to
copy sk_tsflags.

This is needed since b9f40e21ef42 ("net-timestamp: move timestamp flags
out of sk_flags").

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4c9282bdd06790a0cca7f7c33986e7eb6c541398..1a32ecdb8bae98de2e76591f0f5ffee1441ff04d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7167,6 +7167,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	newsk->sk_type = sk->sk_type;
 	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
 	newsk->sk_flags = sk->sk_flags;
+	newsk->sk_tsflags = sk->sk_tsflags;
 	newsk->sk_no_check_tx = sk->sk_no_check_tx;
 	newsk->sk_no_check_rx = sk->sk_no_check_rx;
 	newsk->sk_reuse = sk->sk_reuse;
-- 
2.5.0

