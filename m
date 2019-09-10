From: Mao Wenan <maowenan@huawei.com>
Date: Tue, 10 Sep 2019 06:56:41 +0000
Subject: [PATCH net 2/2] sctp: destroy bucket if failed to bind addr
Message-Id: <20190910071343.18808-3-maowenan@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190910071343.18808-1-maowenan@huawei.com>
In-Reply-To: <20190910071343.18808-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Mao Wenan <maowenan@huawei.com>, Hulk Robot <hulkci@huawei.com>

There is one memory leak bug report:
BUG: memory leak
unreferenced object 0xffff8881dc4c5ec0 (size 40):
  comm "syz-executor.0", pid 5673, jiffies 4298198457 (age 27.578s)
  hex dump (first 32 bytes):
    02 00 00 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f8 63 3d c1 81 88 ff ff 00 00 00 00 00 00 00 00  .c=.............
  backtrace:
    [<0000000072006339>] sctp_get_port_local+0x2a1/0xa00 [sctp]
    [<00000000c7b379ec>] sctp_do_bind+0x176/0x2c0 [sctp]
    [<000000005be274a2>] sctp_bind+0x5a/0x80 [sctp]
    [<00000000b66b4044>] inet6_bind+0x59/0xd0 [ipv6]
    [<00000000c68c7f42>] __sys_bind+0x120/0x1f0 net/socket.c:1647
    [<000000004513635b>] __do_sys_bind net/socket.c:1658 [inline]
    [<000000004513635b>] __se_sys_bind net/socket.c:1656 [inline]
    [<000000004513635b>] __x64_sys_bind+0x3e/0x50 net/socket.c:1656
    [<0000000061f2501e>] do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
    [<0000000003d1e05e>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

This is because in sctp_do_bind, if sctp_get_port_local is to
create hash bucket successfully, and sctp_add_bind_addr failed
to bind address, e.g return -ENOMEM, so memory leak found, it
needs to destroy allocated bucket.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/sctp/socket.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 766b68b55ebe..ab37fc1f7bb6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -412,11 +412,13 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	ret = sctp_add_bind_addr(bp, addr, af->sockaddr_len,
 				 SCTP_ADDR_SRC, GFP_ATOMIC);
 
-	/* Copy back into socket for getsockname() use. */
-	if (!ret) {
-		inet_sk(sk)->inet_sport = htons(inet_sk(sk)->inet_num);
-		sp->pf->to_sk_saddr(addr, sk);
+	if (ret) {
+		sctp_put_port(sk);
+		return ret;
 	}
+	/* Copy back into socket for getsockname() use. */
+	inet_sk(sk)->inet_sport = htons(inet_sk(sk)->inet_num);
+	sp->pf->to_sk_saddr(addr, sk);
 
 	return ret;
 }
-- 
2.20.1
