From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 10 Dec 2018 12:24:36 +0000
Subject: Re: [PATCH net] sctp: initialize sin6_flowinfo for ipv6 addrs in sctp_inet6addr_event
Message-Id: <20181210122436.GA4499@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4c3dc15beee77a541042f79f35702574347dffc9.1544436052.git.lucien.xin@gmail.com>
In-Reply-To: <4c3dc15beee77a541042f79f35702574347dffc9.1544436052.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Dec 10, 2018 at 06:00:52PM +0800, Xin Long wrote:
> syzbot reported a kernel-infoleak, which is caused by an uninitialized
> field(sin6_flowinfo) of addr->a.v6 in sctp_inet6addr_event().
> The call trace is as below:
> 
>   BUG: KMSAN: kernel-infoleak in _copy_to_user+0x19a/0x230 lib/usercopy.c:33
>   CPU: 1 PID: 8164 Comm: syz-executor2 Not tainted 4.20.0-rc3+ #95
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>   Google 01/01/2011
>   Call Trace:
>     __dump_stack lib/dump_stack.c:77 [inline]
>     dump_stack+0x32d/0x480 lib/dump_stack.c:113
>     kmsan_report+0x12c/0x290 mm/kmsan/kmsan.c:683
>     kmsan_internal_check_memory+0x32a/0xa50 mm/kmsan/kmsan.c:743
>     kmsan_copy_to_user+0x78/0xd0 mm/kmsan/kmsan_hooks.c:634
>     _copy_to_user+0x19a/0x230 lib/usercopy.c:33
>     copy_to_user include/linux/uaccess.h:183 [inline]
>     sctp_getsockopt_local_addrs net/sctp/socket.c:5998 [inline]
>     sctp_getsockopt+0x15248/0x186f0 net/sctp/socket.c:7477
>     sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2937
>     __sys_getsockopt+0x489/0x550 net/socket.c:1939
>     __do_sys_getsockopt net/socket.c:1950 [inline]
>     __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
>     __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
>     do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
>     entry_SYSCALL_64_after_hwframe+0x63/0xe7
> 
> sin6_flowinfo is not really used by SCTP, so it will be fixed by simply
> setting it to 0.
> 
> The issue exists since very beginning.
> Thanks Alexander for the reproducer provided.
> 
> Reported-by: syzbot+ad5d327e6936a2e284be@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/ipv6.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index fc6c5e4..7f0539d 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -101,6 +101,7 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
>  		if (addr) {
>  			addr->a.v6.sin6_family = AF_INET6;
>  			addr->a.v6.sin6_port = 0;
> +			addr->a.v6.sin6_flowinfo = 0;
>  			addr->a.v6.sin6_addr = ifa->addr;
>  			addr->a.v6.sin6_scope_id = ifa->idev->dev->ifindex;
>  			addr->valid = 1;
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
