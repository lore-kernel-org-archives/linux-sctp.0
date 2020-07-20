From: Christoph Hellwig <hch@lst.de>
Date: Mon, 20 Jul 2020 12:47:15 +0000
Subject: [PATCH 02/24] bpfilter: fix up a sparse annotation
Message-Id: <20200720124737.118617-3-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200720124737.118617-1-hch@lst.de>
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org

The __user doesn't make sense when casting to an integer type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 977e9dad72ca4f..713b4b3d02005d 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -49,7 +49,7 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
 	req.is_set = is_set;
 	req.pid = current->pid;
 	req.cmd = optname;
-	req.addr = (long __force __user)optval;
+	req.addr = (__force long)optval;
 	req.len = optlen;
 	if (!bpfilter_ops.info.tgid)
 		goto out;
-- 
2.27.0
