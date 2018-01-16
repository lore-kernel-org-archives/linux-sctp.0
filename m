From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Jan 2018 08:21:40 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <CADvbK_f8KVdqWMoFmhOxMxGD8OM5XxoCzMSiyxDv2d+F8sTa_w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com> <001a113f6a6aea72c00562d65d39@google.com>
In-Reply-To: <001a113f6a6aea72c00562d65d39@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>, yoshfuji <yoshfuji@linux-ipv6.org>

On Tue, Jan 16, 2018 at 4:22 AM, syzbot
<syzbot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
wrote:
> syzkaller has found reproducer for the following crash on
> b625c1ff82272e26c76570d3c7123419ec345b20
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
>
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by:
> syzbot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed.
>
> skbuff: skb_under_panic: text:000000001d390b3a len:31 put:24
> head:00000000d8ed776f data:000000008150e823 tail:0x7 end:0xc0 dev:gre0
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:104!
> invalid opcode: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 3670 Comm: syzkaller801466 Not tainted 4.15.0-rc7-next-20180115+
> #97
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:skb_panic+0x162/0x1f0 net/core/skbuff.c:100
> RSP: 0018:ffff8801d9bd7840 EFLAGS: 00010282
> RAX: 0000000000000083 RBX: ffff8801d4f083c0 RCX: 0000000000000000
> RDX: 0000000000000083 RSI: 1ffff1003b37ae92 RDI: ffffed003b37aefc
> RBP: ffff8801d9bd78a8 R08: 1ffff1003b37ae8a R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff86200de0
> R13: ffffffff84a981ad R14: 0000000000000018 R15: ffff8801d2d34180
> FS:  00000000019c4880(0000) GS:ffff8801db300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000208bc000 CR3: 00000001d9111001 CR4: 00000000001606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  skb_under_panic net/core/skbuff.c:114 [inline]
>  skb_push+0xce/0xf0 net/core/skbuff.c:1714
>  ipgre_header+0x6d/0x4e0 net/ipv4/ip_gre.c:879
>  dev_hard_header include/linux/netdevice.h:2723 [inline]
>  pppoe_sendmsg+0x58e/0x8b0 drivers/net/ppp/pppoe.c:890
>  sock_sendmsg_nosec net/socket.c:630 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:640
>  sock_write_iter+0x31a/0x5d0 net/socket.c:909
>  call_write_iter include/linux/fs.h:1775 [inline]
>  do_iter_readv_writev+0x525/0x7f0 fs/read_write.c:653
>  do_iter_write+0x154/0x540 fs/read_write.c:932
>  vfs_writev+0x18a/0x340 fs/read_write.c:977
>  do_writev+0xfc/0x2a0 fs/read_write.c:1012
>  SYSC_writev fs/read_write.c:1085 [inline]
>  SyS_writev+0x27/0x30 fs/read_write.c:1082
>  entry_SYSCALL_64_fastpath+0x29/0xa0
> RIP: 0033:0x445009
> RSP: 002b:00007ffcab0aa648 EFLAGS: 00000217 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 0000000000445009
> RDX: 0000000000000001 RSI: 0000000020211f90 RDI: 0000000000000004
> RBP: 00007ffcab0aa748 R08: 0000000020adffb2 R09: 0000000020adffb2
> R10: 0000000020adffb2 R11: 0000000000000217 R12: 00007ffcab0aa748
> R13: 0000000000402510 R14: 0000000000000000 R15: 0000000000000000
> Code: 04 01 84 c0 74 04 3c 03 7e 23 8b 8b 80 00 00 00 41 57 48 c7 c7 a0 06
> 20 86 52 56 4c 89 ea 41 50 4c 89 e6 45 89 f0 e8 b6 c9 23 fd <0f> 0b 4c 89 4d
> b8 4c 89 45 c0 48 89 75 c8 48 89 55 d0 e8 37 42
> RIP: skb_panic+0x162/0x1f0 net/core/skbuff.c:100 RSP: ffff8801d9bd7840
> ---[ end trace 1478d06428a41d88 ]---
>
ipv4 tunnels don't  really set dev->hard_header_len properly,
we may should fix it in pppoe by using needed_headroom,
as what it doesn't in arp_create.

@@ -860,16 +861,16 @@ static int pppoe_sendmsg(struct socket *sock,
struct msghdr *m,
        if (total_len > (dev->mtu + dev->hard_header_len))
                goto end;

+       rlen = LL_RESERVED_SPACE(dev) + dev->needed_tailroom;

-       skb = sock_wmalloc(sk, total_len + dev->hard_header_len + 32,
-                          0, GFP_KERNEL);
+       skb = sock_wmalloc(sk, total_len + rlen + 32, 0, GFP_KERNEL);
        if (!skb) {
                error = -ENOMEM;
                goto end;
        }

        /* Reserve space for headers. */
-       skb_reserve(skb, dev->hard_header_len);
+       skb_reserve(skb, rlen);
