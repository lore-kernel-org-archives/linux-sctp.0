From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 06 Mar 2019 12:03:10 +0000
Subject: Re: general protection fault in sctp_sched_rr_dequeue
Message-Id: <20190306120310.GA6711@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000cc734405836318dc@google.com>
 <CADvbK_fJ8R0WmQaFcz0sOhL_AXH3AdO2zLeqMD38X22izEAMNg@mail.gmail.com>
In-Reply-To: <CADvbK_fJ8R0WmQaFcz0sOhL_AXH3AdO2zLeqMD38X22izEAMNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, Mar 06, 2019 at 06:43:48PM +0800, Xin Long wrote:
> On Wed, Mar 6, 2019 at 9:42 AM syzbot
> <syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    63bdf4284c38 Merge branch 'linus' of git://git.kernel.o=
rg/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=100347cb200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=872be05707464=
aaa
> > dashboard link: https://syzkaller.appspot.com/bug?extidL9934f20522c0efd=
657
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cd9b03200=
000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127de8e7200000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com
> >
> > kauditd_printk_skb: 2 callbacks suppressed
> > audit: type=1400 audit(1551833288.424:35): avc:  denied  { map } for
> > pid=8035 comm=3D"bash" path=3D"/bin/bash" dev=3D"sda1" ino=1457
> > scontext=3Dunconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> > tcontext=3Dsystem_u:object_r:file_t:s0 tclass=3Dfile permissive=3D1
> > audit: type=1400 audit(1551833294.934:36): avc:  denied  { map } for
> > pid=8047 comm=3D"syz-executor778" path=3D"/root/syz-executor778173561"
> > dev=3D"sda1" ino=16484 scontext=3Dunconfined_u:system_r:insmod_t:s0-s0:=
c0.c1023
> > tcontext=3Dunconfined_u:object_r:user_home_t:s0 tclass=3Dfile permissiv=
e=3D1
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 8047 Comm: syz-executor778 Not tainted 5.0.0+ #7
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:sctp_sched_rr_dequeue+0xd3/0x170 net/sctp/stream_sched_rr.c:1=
41
> The panic was caused by sched->init() reset stream->rr_next =3D NULL, even
> if outq->out_chunk_list is not empty.
>=20
> We should remove the sched->init() from sctp_stream_init(), since
> all sched info was moved into sout->ext and sctp_stream_alloc_out()
> will not afffect it.
>=20
I think what you're saying is we can just let sctp_outq_init handle the str=
eam
scheduler initalization, correct?  If so, ACK to that approach
Neil

> > Code: ea 03 80 3c 02 00 0f 85 a2 00 00 00 48 8b 5b 08 e8 62 20 ee fa 48=
 8d
> > 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
75
> > 53 4c 8b 6b 30 4c 89 e7 49 83 ed 18 4c 89 ee e8 b4
> > RSP: 0018:ffff88809eacf040 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8679cd9f
> > RDX: 0000000000000006 RSI: ffffffff8681c41e RDI: 0000000000000030
> > RBP: ffff88809eacf058 R08: ffff8880a12bc300 R09: 0000000000000002
> > R10: ffffed1015d25bcf R11: ffff8880ae92de7b R12: ffff88807cae6ca0
> > R13: ffff88807cae6580 R14: dffffc0000000000 R15: ffff88809eacf198
> > FS:  0000000001865880(0000) GS:ffff8880ae900000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055af2d491150 CR3: 000000008dd7b000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   sctp_outq_dequeue_data net/sctp/outqueue.c:90 [inline]
> >   sctp_outq_flush_data net/sctp/outqueue.c:1079 [inline]
> >   sctp_outq_flush+0xba2/0x2790 net/sctp/outqueue.c:1205
> >   sctp_outq_uncork+0x6c/0x80 net/sctp/outqueue.c:772
> >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
> >   sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> >   sctp_do_sm+0x513/0x5390 net/sctp/sm_sideeffect.c:1191
> >   sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1074
> >   sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
> >   sctp_backlog_rcv+0x189/0xbc0 net/sctp/input.c:354
> >   sk_backlog_rcv include/net/sock.h:937 [inline]
> >   __release_sock+0x12e/0x3a0 net/core/sock.c:2413
> >   release_sock+0x59/0x1c0 net/core/sock.c:2929
> >   sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:8999
> >   sctp_sendmsg_to_asoc+0x13e2/0x17d0 net/sctp/socket.c:1968
> >   sctp_sendmsg+0x10a9/0x17e0 net/sctp/socket.c:2114
> >   inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
> >   sock_sendmsg_nosec net/socket.c:622 [inline]
> >   sock_sendmsg+0xdd/0x130 net/socket.c:632
> >   ___sys_sendmsg+0x806/0x930 net/socket.c:2137
> >   __sys_sendmsg+0x105/0x1d0 net/socket.c:2175
> >   __do_sys_sendmsg net/socket.c:2184 [inline]
> >   __se_sys_sendmsg net/socket.c:2182 [inline]
> >   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2182
> >   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x440159
> > Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89=
 f7
> > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff
> > ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007fff8801fd38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440159
> > RDX: 0000000000000000 RSI: 000000002001afc8 RDI: 0000000000000003
> > RBP: 00000000006ca018 R08: 0000000000000002 R09: 00000000004002c8
> > R10: 0000000000000008 R11: 0000000000000246 R12: 00000000004019e0
> > R13: 0000000000401a70 R14: 0000000000000000 R15: 0000000000000000
> > Modules linked in:
> > ---[ end trace 7cc5803525726c53 ]---
> > RIP: 0010:sctp_sched_rr_dequeue+0xd3/0x170 net/sctp/stream_sched_rr.c:1=
41
> > Code: ea 03 80 3c 02 00 0f 85 a2 00 00 00 48 8b 5b 08 e8 62 20 ee fa 48=
 8d
> > 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
75
> > 53 4c 8b 6b 30 4c 89 e7 49 83 ed 18 4c 89 ee e8 b4
> > RSP: 0018:ffff88809eacf040 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8679cd9f
> > RDX: 0000000000000006 RSI: ffffffff8681c41e RDI: 0000000000000030
> > RBP: ffff88809eacf058 R08: ffff8880a12bc300 R09: 0000000000000002
> > R10: ffffed1015d25bcf R11: ffff8880ae92de7b R12: ffff88807cae6ca0
> > R13: ffff88807cae6580 R14: dffffc0000000000 R15: ffff88809eacf198
> > FS:  0000000001865880(0000) GS:ffff8880ae900000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055af2d491150 CR3: 000000008dd7b000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>=20
