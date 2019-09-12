From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 12 Sep 2019 14:52:18 +0000
Subject: Re: [PATCH v2 net 3/3] sctp: destroy bucket if failed to bind addr
Message-Id: <20190912145218.GT3431@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-4-maowenan@huawei.com>
In-Reply-To: <20190912040219.67517-4-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mao Wenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>

On Thu, Sep 12, 2019 at 12:02:19PM +0800, Mao Wenan wrote:
> There is one memory leak bug report:
> BUG: memory leak
> unreferenced object 0xffff8881dc4c5ec0 (size 40):
>   comm "syz-executor.0", pid 5673, jiffies 4298198457 (age 27.578s)
>   hex dump (first 32 bytes):
>     02 00 00 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>     f8 63 3d c1 81 88 ff ff 00 00 00 00 00 00 00 00  .c=.............
>   backtrace:
>     [<0000000072006339>] sctp_get_port_local+0x2a1/0xa00 [sctp]
>     [<00000000c7b379ec>] sctp_do_bind+0x176/0x2c0 [sctp]
>     [<000000005be274a2>] sctp_bind+0x5a/0x80 [sctp]
>     [<00000000b66b4044>] inet6_bind+0x59/0xd0 [ipv6]
>     [<00000000c68c7f42>] __sys_bind+0x120/0x1f0 net/socket.c:1647
>     [<000000004513635b>] __do_sys_bind net/socket.c:1658 [inline]
>     [<000000004513635b>] __se_sys_bind net/socket.c:1656 [inline]
>     [<000000004513635b>] __x64_sys_bind+0x3e/0x50 net/socket.c:1656
>     [<0000000061f2501e>] do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
>     [<0000000003d1e05e>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This is because in sctp_do_bind, if sctp_get_port_local is to
> create hash bucket successfully, and sctp_add_bind_addr failed
> to bind address, e.g return -ENOMEM, so memory leak found, it
> needs to destroy allocated bucket.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
