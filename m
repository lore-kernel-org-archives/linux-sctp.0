From: Christoph Hellwig <hch@lst.de>
Date: Thu, 23 Jul 2020 06:08:45 +0000
Subject: [PATCH 03/26] bpfilter: reject kernel addresses
Message-Id: <20200723060908.50081-4-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200723060908.50081-1-hch@lst.de>
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org

The bpfilter user mode helper processes the optval address using
process_vm_readv.  Don't send it kernel addresses fed under
set_fs(KERNEL_DS) as that won't work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 78d561f2c54da7..00540457e5f4d3 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -70,6 +70,10 @@ static int bpfilter_process_sockopt(struct sock *sk, int optname,
 		.addr		= (uintptr_t)optval,
 		.len		= optlen,
 	};
+	if (uaccess_kernel()) {
+		pr_err("kernel access not supported\n");
+		return -EFAULT;
+	}
 	return bpfilter_send_req(&req);
 }
 
-- 
2.27.0
