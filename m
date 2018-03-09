From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 09 Mar 2018 22:08:23 +0000
Subject: Re: KASAN: use-after-free Read in sctp_association_free (2)
Message-Id: <20180309220823.GA24848@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000017dfe905670110cf@google.com>
In-Reply-To: <00000000000017dfe905670110cf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+a4e4112c3aff00c8cfd8@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Fri, Mar 09, 2018 at 12:59:06PM -0800, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on net-next commit
> fd372a7a9e5e9d8011a0222d10edd3523abcd3b1 (Thu Mar 8 19:43:48 2018 +0000)
> Merge tag 'mlx5-updates-2018-02-28-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
> 
> So far this crash happened 2 times on net-next.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a4e4112c3aff00c8cfd8@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: ftp: loaded support on port[0] = 21
> =================================
> BUG: KASAN: use-after-free in sctp_association_free+0x7b7/0x930
> net/sctp/associola.c:332
> Read of size 8 at addr ffff8801d8006ae0 by task syzkaller914861/4202
> 
> CPU: 1 PID: 4202 Comm: syzkaller914861 Not tainted 4.16.0-rc4+ #258
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report+0x23c/0x360 mm/kasan/report.c:412
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>  sctp_association_free+0x7b7/0x930 net/sctp/associola.c:332
>  sctp_sendmsg+0xc67/0x1a80 net/sctp/socket.c:2075
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:763
>  sock_sendmsg_nosec net/socket.c:629 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:639
>  SYSC_sendto+0x361/0x5c0 net/socket.c:1748
>  SyS_sendto+0x40/0x50 net/socket.c:1716
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x446d09
> RSP: 002b:00007f5dbac21da8 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00000000006e29fc RCX: 0000000000446d09
> RDX: 0000000000000001 RSI: 0000000020000340 RDI: 0000000000000003
> RBP: 00000000006e29f8 R08: 00000000204d9000 R09: 000000000000001c
> R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000000
> R13: 00007fff7b26fb1f R14: 00007f5dbac229c0 R15: 00000000006e2b60
> 
I think we have a corner case with a0ff660058b88d12625a783ce9e5c1371c87951f
here.  If a peeloff event happens during a wait for sendbuf space, EPIPE will be
returned, and the code path appears to call sctp_association_put twice, leading
to the use after free situation.  I'll write a patch this weekend

Neil

