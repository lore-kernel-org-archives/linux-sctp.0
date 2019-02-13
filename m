From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 13 Feb 2019 14:00:37 +0000
Subject: Re: KASAN: use-after-free Read in sctp_outq_tail
Message-Id: <CACT4Y+Zp0qakpN_8DYf23rBWPgcXOdVpgG0pdrTmAMd8Lcwr7A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000002015db0581b71858@google.com> <CADvbK_dndFMxyUZk=k8qEy9=PNbLc81F++2L0fbdtUdbupq4Xg@mail.gmail.com>
 <20190213135157.GJ10665@localhost.localdomain>
In-Reply-To: <20190213135157.GJ10665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, syzbot <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, Feb 13, 2019 at 2:52 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Feb 13, 2019 at 12:35:56PM +0800, Xin Long wrote:
> > On Wed, Feb 13, 2019 at 4:00 AM syzbot
> > <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    d4104460aec1 Add linux-next specific files for 201902=
11
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14140124c00=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=C8a112d3b0d=
6719b
> > > dashboard link: https://syzkaller.appspot.com/bug?extidx23fa3f3e2d693=
41ea8
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the co=
mmit:
> > > Reported-by: syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: use-after-free in list_add_tail include/linux/list.h:93 [=
inline]
> > > BUG: KASAN: use-after-free in sctp_outq_tail_data net/sctp/outqueue.c=
:105
> > > [inline]
> > > BUG: KASAN: use-after-free in sctp_outq_tail+0x816/0x930
> > > net/sctp/outqueue.c:313
> > > Read of size 8 at addr ffff88807b19a7b8 by task syz-executor.0/30745
> > I think https://patchwork.ozlabs.org/patch/1040500/ will fix this.
>
> I don't think so. Seems it will switch from use-after-free to NULL deref
> instead with that patch.

Let's unmark it as fixed for now then so that syzbot does not close it
prematurely

#syz fix: see discussion on the report email thread

> > > CPU: 1 PID: 30745 Comm: syz-executor.0 Not tainted 5.0.0-rc5-next-201=
90211
> > > #32
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS
> > > Google 01/01/2011
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > >   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
> > >   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
> > >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> > >   list_add_tail include/linux/list.h:93 [inline]
> > >   sctp_outq_tail_data net/sctp/outqueue.c:105 [inline]
> > >   sctp_outq_tail+0x816/0x930 net/sctp/outqueue.c:313
> > >   sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1109 [inline]
> > >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1784 [inline]
> > >   sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > >   sctp_do_sm+0x68e/0x5380 net/sctp/sm_sideeffect.c:1191
> > >   sctp_primitive_SEND+0xa0/0xd0 net/sctp/primitive.c:178
> > >   sctp_sendmsg_to_asoc+0xa63/0x17b0 net/sctp/socket.c:1955
>
> sctp_sendmsg_to_asoc()
> ...
>         if (sinfo->sinfo_stream >=3D asoc->stream.outcnt) {
>                 err =3D -EINVAL;
>                 goto err;
>         }
>
>         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
> ...
>
> It should have aborted even if an old ->ext was still there because
> outcnt is correctly updated. So somehow outcnt was wrong here.
>
> sctp_stream_init()
> ...
>         /* Filter out chunks queued on streams that won't exist anymore */
>         sched->unsched_all(stream);
>         sctp_stream_outq_migrate(stream, NULL, outcnt);   <--- [A]
>         sched->sched_all(stream);
>
>         ret =3D sctp_stream_alloc_out(stream, outcnt, gfp); <--- [B]
>         if (ret)
>                 goto out;
>
>         stream->outcnt =3D outcnt;                          <--- [C]
> ...
>
> We have a problem here because [A] is freeing ->ext, but [B] can fail (EN=
OMEM),
> which would lead it to not update outcnt in [C] even after the
> changes already performed in [A].
>
> It should handle the freeing of ->ext in sctp_stream_alloc_out()
> instead, or allocate the flexarray earlier (so it can bail out before
> freeing stuff).
>
> > >   sctp_sendmsg+0x10a9/0x17e0 net/sctp/socket.c:2113
> > >   inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg+0xdd/0x130 net/socket.c:631
> > >   ___sys_sendmsg+0x806/0x930 net/socket.c:2136
> > >   __sys_sendmsg+0x105/0x1d0 net/socket.c:2174
> > >   __do_sys_sendmsg net/socket.c:2183 [inline]
> > >   __se_sys_sendmsg net/socket.c:2181 [inline]
> > >   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2181
> > >   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > RIP: 0033:0x457e39
> > > Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 =
89 f7
> > > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff
> > > ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > > RSP: 002b:00007fa9b8630c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457e39
> > > RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
> > > RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa9b86316d4
> > > R13: 00000000004c4e2b R14: 00000000004d8ab8 R15: 00000000ffffffff
> > >
> > > Allocated by task 30745:
> > >   save_stack+0x45/0xd0 mm/kasan/common.c:75
> > >   set_track mm/kasan/common.c:87 [inline]
> > >   __kasan_kmalloc mm/kasan/common.c:498 [inline]
> > >   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:471
> > >   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:506
> > >   kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3615
> > >   kmalloc include/linux/slab.h:548 [inline]
> > >   kzalloc include/linux/slab.h:743 [inline]
> > >   sctp_stream_init_ext+0x51/0x110 net/sctp/stream.c:172
> > >   sctp_sendmsg_to_asoc+0x1273/0x17b0 net/sctp/socket.c:1896
> > >   sctp_sendmsg+0x10a9/0x17e0 net/sctp/socket.c:2113
> > >   inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg+0xdd/0x130 net/socket.c:631
> > >   ___sys_sendmsg+0x806/0x930 net/socket.c:2136
> > >   __sys_sendmsg+0x105/0x1d0 net/socket.c:2174
> > >   __do_sys_sendmsg net/socket.c:2183 [inline]
> > >   __se_sys_sendmsg net/socket.c:2181 [inline]
> > >   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2181
> > >   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Freed by task 30745:
> > >   save_stack+0x45/0xd0 mm/kasan/common.c:75
> > >   set_track mm/kasan/common.c:87 [inline]
> > >   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:460
> > >   kasan_slab_free+0xe/0x10 mm/kasan/common.c:468
> > >   __cache_free mm/slab.c:3491 [inline]
> > >   kfree+0xcf/0x230 mm/slab.c:3816
> > >   sctp_stream_outq_migrate+0x3e6/0x540 net/sctp/stream.c:88
> > >   sctp_stream_init+0xbc/0x410 net/sctp/stream.c:139
> > >   sctp_process_init+0x21c3/0x2b20 net/sctp/sm_make_chunk.c:2466
> > >   sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
> > >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]
> > >   sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > >   sctp_do_sm+0x3145/0x5380 net/sctp/sm_sideeffect.c:1191
> > >   sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1074
> > >   sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
> > >   sctp_backlog_rcv+0x196/0xbe0 net/sctp/input.c:354
> > >   sk_backlog_rcv include/net/sock.h:937 [inline]
> > >   __release_sock+0x12e/0x3a0 net/core/sock.c:2379
> > >   release_sock+0x59/0x1c0 net/core/sock.c:2895
> > >   sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:8998
> > >   sctp_sendmsg_to_asoc+0x13e3/0x17b0 net/sctp/socket.c:1967
> > >   sctp_sendmsg+0x10a9/0x17e0 net/sctp/socket.c:2113
> > >   inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg+0xdd/0x130 net/socket.c:631
> > >   ___sys_sendmsg+0x806/0x930 net/socket.c:2136
> > >   __sys_sendmsg+0x105/0x1d0 net/socket.c:2174
> > >   __do_sys_sendmsg net/socket.c:2183 [inline]
> > >   __se_sys_sendmsg net/socket.c:2181 [inline]
> > >   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2181
> > >   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > The buggy address belongs to the object at ffff88807b19a780
> > >   which belongs to the cache kmalloc-96 of size 96
> > > The buggy address is located 56 bytes inside of
> > >   96-byte region [ffff88807b19a780, ffff88807b19a7e0)
> > > The buggy address belongs to the page:
> > > page:ffffea0001ec6680 count:1 mapcount:0 mapping:ffff88812c3f04c0
> > > index:0xffff88807b19a800
> > > flags: 0x1fffc0000000200(slab)
> > > raw: 01fffc0000000200 ffffea000262acc8 ffffea0001448348 ffff88812c3f0=
4c0
> > > raw: ffff88807b19a800 ffff88807b19a000 000000010000001d 0000000000000=
000
> > > page dumped because: kasan: bad access detected
> > >
> > > Memory state around the buggy address:
> > >   ffff88807b19a680: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> > >   ffff88807b19a700: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> > > > ffff88807b19a780: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> > >                                          ^
> > >   ffff88807b19a800: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> > >   ffff88807b19a880: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > >
> > > ---
> > > This bug is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this bug report. See:
> > > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> > > syzbot.
> >
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/20190213135157.GJ10665%40localhost.localdomain.
> For more options, visit https://groups.google.com/d/optout.
