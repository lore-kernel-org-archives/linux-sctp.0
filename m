From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 22 Nov 2018 13:13:44 +0000
Subject: Re: KASAN: use-after-free Read in __lock_sock
Message-Id: <20181122131344.GD31918@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000b98a67057ad7158a@google.com>
 <CADvbK_f3CpK=qJFngBGmO3VXFLsJm9=qqZVtxYOeBS8rwE=9Ew@mail.gmail.com>
In-Reply-To: <CADvbK_f3CpK=qJFngBGmO3VXFLsJm9=qqZVtxYOeBS8rwE=9Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Mon, Nov 19, 2018 at 05:57:33PM +0900, Xin Long wrote:
> On Sat, Nov 17, 2018 at 4:18 PM syzbot
> <syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=156cd533400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?xJ0a89f12ca9b0f5
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9276d76e83e3bcd=
e6c99
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> >
> > netlink: 5 bytes leftover after parsing attributes in process
> > `syz-executor5'.
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
> > kernel/locking/lockdep.c:3218
> > Read of size 8 at addr ffff8881d26d60e0 by task syz-executor1/13725
> >
> > CPU: 0 PID: 13725 Comm: syz-executor1 Not tainted 4.20.0-rc2+ #333
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x244/0x39d lib/dump_stack.c:113
> >   print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
> >   kasan_report_error mm/kasan/report.c:354 [inline]
> >   kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
> >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> >   __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
> >   lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
> >   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
> >   _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
> >   spin_lock_bh include/linux/spinlock.h:334 [inline]
> >   __lock_sock+0x203/0x350 net/core/sock.c:2253
> >   lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
> >   lock_sock include/net/sock.h:1492 [inline]
> >   sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
>=20
> static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> {
>         struct sctp_endpoint *ep =3D tsp->asoc->ep;
>         struct sctp_comm_param *commp =3D p;
>         struct sock *sk =3D ep->base.sk; <--- [1]
> ...
>         int err =3D 0;
>=20
>         lock_sock(sk);  <--- [2]
>=20
> Between [1] and [2], an asoc peeloff may happen, still thinking
> how to avoid this.

This race cannot happen more than once for an asoc, so something
like this may be doable:

        struct sctp_comm_param *commp =3D p;
        struct sctp_endpoint *ep;
        struct sock *sk;
...
        int err =3D 0;

again:
	ep =3D tsp->asoc->ep;
	sk =3D ep->base.sk;
        lock_sock(sk);  <--- [2]
	if (sk !=3D tsp->asoc->ep->base.sk) {
		/* Asoc was peeloff'd */
		unlock_sock(sk);
		goto again;
	}

Similarly to what we did on cea0cc80a677 ("sctp: use the right sk
after waking up from wait_buf sleep").

>=20
>=20
>=20
> >   sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
> >   sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
> >   __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
> >   inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
> >   netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
> >   __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
> >   netlink_dump_start include/linux/netlink.h:216 [inline]
> >   inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
> >   __sock_diag_cmd net/core/sock_diag.c:232 [inline]
> >   sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
> >   netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
> >   sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
> >   netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
> >   netlink_unicast+0x5a5/0x760 net/netlink/af_netlink.c:1336
> >   netlink_sendmsg+0xa18/0xfc0 net/netlink/af_netlink.c:1917
> >   sock_sendmsg_nosec net/socket.c:621 [inline]
> >   sock_sendmsg+0xd5/0x120 net/socket.c:631
> >   sock_write_iter+0x35e/0x5c0 net/socket.c:900
> >   call_write_iter include/linux/fs.h:1857 [inline]
> >   do_iter_readv_writev+0x8b0/0xa80 fs/read_write.c:680
> >   do_iter_write+0x185/0x5f0 fs/read_write.c:959
> >   vfs_writev+0x1f1/0x360 fs/read_write.c:1004
> >   do_writev+0x11a/0x310 fs/read_write.c:1039
> >   __do_sys_writev fs/read_write.c:1112 [inline]
> >   __se_sys_writev fs/read_write.c:1109 [inline]
> >   __x64_sys_writev+0x75/0xb0 fs/read_write.c:1109
> >   do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x457569
> > Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89=
 f7
> > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff
> > ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007f2cdabbac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
> > RDX: 0000000000000001 RSI: 000000002051c000 RDI: 000000000000000e
> > RBP: 000000000072c0e0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2cdabbb6d4
> > R13: 00000000004c33b1 R14: 00000000004d97c8 R15: 00000000ffffffff
> >
> > Allocated by task 13672:
> >   save_stack+0x43/0xd0 mm/kasan/kasan.c:448
> >   set_track mm/kasan/kasan.c:460 [inline]
> >   kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
> >   kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
> >   kmem_cache_alloc+0x12e/0x730 mm/slab.c:3554
> >   sk_prot_alloc+0x69/0x2e0 net/core/sock.c:1463
> >   sk_alloc+0x10d/0x1690 net/core/sock.c:1523
> >   inet_create+0x509/0x1070 net/ipv4/af_inet.c:321
> >   __sock_create+0x536/0x930 net/socket.c:1277
> >   sock_create net/socket.c:1317 [inline]
> >   __sys_socket+0x106/0x260 net/socket.c:1347
> >   __do_sys_socket net/socket.c:1356 [inline]
> >   __se_sys_socket net/socket.c:1354 [inline]
> >   __x64_sys_socket+0x73/0xb0 net/socket.c:1354
> >   do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Freed by task 13680:
> >   save_stack+0x43/0xd0 mm/kasan/kasan.c:448
> >   set_track mm/kasan/kasan.c:460 [inline]
> >   __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
> >   kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
> >   __cache_free mm/slab.c:3498 [inline]
> >   kmem_cache_free+0x83/0x290 mm/slab.c:3760
> >   sk_prot_free net/core/sock.c:1504 [inline]
> >   __sk_destruct+0x728/0xa80 net/core/sock.c:1588
> >   sk_destruct+0x78/0x90 net/core/sock.c:1596
> >   __sk_free+0xcf/0x300 net/core/sock.c:1607
> >   sk_free+0x42/0x50 net/core/sock.c:1618
> >   sock_put include/net/sock.h:1693 [inline]
> >   sctp_close+0x8d4/0xad0 net/sctp/socket.c:1569
> >   inet_release+0x104/0x1f0 net/ipv4/af_inet.c:428
> >   __sock_release+0xd7/0x250 net/socket.c:579
> >   sock_close+0x19/0x20 net/socket.c:1141
> >   __fput+0x385/0xa30 fs/file_table.c:278
> >   ____fput+0x15/0x20 fs/file_table.c:309
> >   task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
> >   get_signal+0x1558/0x1980 kernel/signal.c:2347
> >   do_signal+0x9c/0x21c0 arch/x86/kernel/signal.c:816
> >   exit_to_usermode_loop+0x2e5/0x380 arch/x86/entry/common.c:162
> >   prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
> >   syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
> >   do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > The buggy address belongs to the object at ffff8881d26d6040
> >   which belongs to the cache SCTP(33:syz1) of size 1776
> > The buggy address is located 160 bytes inside of
> >   1776-byte region [ffff8881d26d6040, ffff8881d26d6730)
> > The buggy address belongs to the page:
> > page:ffffea000749b580 count:1 mapcount:0 mapping:ffff8881b517f200 index=
:0x0
> > flags: 0x2fffc0000000200(slab)
> > raw: 02fffc0000000200 ffff8881c6685748 ffffea0007538388 ffff8881b517f200
> > raw: 0000000000000000 ffff8881d26d6040 0000000100000002 ffff8881b6b4e7c0
> > page dumped because: kasan: bad access detected
> > page->mem_cgroup:ffff8881b6b4e7c0
> >
> > Memory state around the buggy address:
> >   ffff8881d26d5f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >   ffff8881d26d6000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> > > ffff8881d26d6080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                                                         ^
> >   ffff8881d26d6100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff8881d26d6180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> > syzbot.
