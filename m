From: Christoph Hellwig <hch@lst.de>
Date: Fri, 17 Jul 2020 06:23:11 +0000
Subject: [PATCH 02/22] net: streamline __sys_setsockopt
Message-Id: <20200717062331.691152-3-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200717062331.691152-1-hch@lst.de>
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Chas Williams <3chas3@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, mptcp@lists.01.org

Return early when sockfd_lookup_light fails to reduce a level of
indentation for most of the function body.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/socket.c | 57 +++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 770503c4ca76c9..49a6daf0293b83 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2107,43 +2107,40 @@ static int __sys_setsockopt(int fd, int level, int optname,
 		return -EINVAL;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock != NULL) {
-		err = security_socket_setsockopt(sock, level, optname);
-		if (err)
-			goto out_put;
+	if (!sock)
+		return err;
 
-		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level,
-						     &optname, optval, &optlen,
-						     &kernel_optval);
+	err = security_socket_setsockopt(sock, level, optname);
+	if (err)
+		goto out_put;
 
-		if (err < 0) {
-			goto out_put;
-		} else if (err > 0) {
-			err = 0;
-			goto out_put;
-		}
+	err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
+					     optval, &optlen, &kernel_optval);
+	if (err < 0)
+		goto out_put;
+	if (err > 0) {
+		err = 0;
+		goto out_put;
+	}
 
-		if (kernel_optval) {
-			set_fs(KERNEL_DS);
-			optval = (char __user __force *)kernel_optval;
-		}
+	if (kernel_optval) {
+		set_fs(KERNEL_DS);
+		optval = (char __user __force *)kernel_optval;
+	}
 
-		if (level = SOL_SOCKET && !sock_use_custom_sol_socket(sock))
-			err -			    sock_setsockopt(sock, level, optname, optval,
+	if (level = SOL_SOCKET && !sock_use_custom_sol_socket(sock))
+		err = sock_setsockopt(sock, level, optname, optval, optlen);
+	else
+		err = sock->ops->setsockopt(sock, level, optname, optval,
 					    optlen);
-		else
-			err -			    sock->ops->setsockopt(sock, level, optname, optval,
-						  optlen);
 
-		if (kernel_optval) {
-			set_fs(oldfs);
-			kfree(kernel_optval);
-		}
-out_put:
-		fput_light(sock->file, fput_needed);
+	if (kernel_optval) {
+		set_fs(oldfs);
+		kfree(kernel_optval);
 	}
+
+out_put:
+	fput_light(sock->file, fput_needed);
 	return err;
 }
 
-- 
2.27.0
