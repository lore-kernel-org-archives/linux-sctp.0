From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Mar 2019 16:29:52 +0000
Subject: Re: general protection fault in sctp_assoc_rwnd_increase
Message-Id: <CADvbK_fVQWugki=RgNT3Di_dDcnRtL1D09AoNTTAW-9pzZ8d_w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000089bb100583e5fe7a@google.com>
In-Reply-To: <00000000000089bb100583e5fe7a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Tue, Mar 12, 2019 at 9:52 PM syzbot
<syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    a089e4fe Merge tag 'linux-watchdog-5.1-rc1' of git://www.=
l..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=144e9ee7200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=B613f0327d980b6b
> dashboard link: https://syzkaller.appspot.com/bug?extid=85e0b422ff140b036=
72a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: amd64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12613b13200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f1884d200000
Not sure why I got this Call Trace with the reproducer, and it's
different, is that expected?

[256577.101170] FAULT_INJECTION: forcing a failure.
[256577.101170] name failslab, interval 1, probability 0, space 0, times 0
[256577.103628] CPU: 0 PID: 2453 Comm: syz-executor Not tainted
5.0.0.test.syz #235
[256577.105201] Hardware name: Red Hat KVM, BIOS seabios-1.7.5-8.el7 04/01/=
2014
[256577.106680] Call Trace:
[256577.107248]  dump_stack+0x7c/0xc0
[256577.107981]  should_fail.cold.4+0x5/0x13
[256577.108853]  ? fault_create_debugfs_attr+0x190/0x190
[256577.109926]  ? lock_downgrade+0x5d0/0x5d0
[256577.110816]  ? selinux_sk_alloc_security+0x72/0x190
[256577.111878]  ? selinux_sk_alloc_security+0x72/0x190
[256577.112931]  should_failslab+0xa/0x20
[256577.113738]  kmem_cache_alloc_trace+0x27a/0x350
[256577.114733]  selinux_sk_alloc_security+0x72/0x190
[256577.115757]  ? kmem_cache_alloc+0x2dc/0x310
[256577.116674]  security_sk_alloc+0x4f/0x90
[256577.117543]  sk_prot_alloc+0x82/0x250
[256577.118362]  sk_alloc+0x35/0xc80
[256577.119100]  inet6_create+0x26e/0xec0
[256577.119924]  __sock_create+0x277/0x550
[256577.120804]  sctp_do_peeloff+0x162/0x3b0 [sctp]
[256577.121795]  ? sched_clock+0x5/0x10
[256577.122596]  ? sctp_copy_sock+0xfa0/0xfa0 [sctp]
[256577.123646]  sctp_getsockopt_peeloff_common.isra.31+0x78/0x2c0 [sctp]
[256577.125064]  ? sctp_do_peeloff+0x3b0/0x3b0 [sctp]
[256577.126129]  sctp_getsockopt.part.32+0x2d76/0x4a90 [sctp]

>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com
>
> RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446679
> RDX: 0000000000000066 RSI: 0000000000000084 RDI: 0000000000000003
> RBP: 00000000006dbc30 R08: 0000000020000140 R09: 0000000000000038
> R10: 0000000020000040 R11: 0000000000000246 R12: 00000000006dbc3c
> R13: 00007f47f49ded90 R14: 0000000000000004 R15: 20c49ba5e353f7cf
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 7680 Comm: syz-executor161 Not tainted 5.0.0+ #18
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:sctp_assoc_rwnd_increase+0x34/0x520 net/sctp/associola.c:1498
> Code: 41 54 49 89 fc 53 89 f3 48 83 ec 10 e8 95 90 f1 fa 49 8d bc 24 60 06
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
> c0 74 08 3c 03 0f 8e 2f 04 00 00 45 8b ac 24 60 06
> RSP: 0018:ffff88808da476f8 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 00000000000000cb RSI: ffffffff867ecd5b RDI: 000000000000065f
> RBP: ffff88808da47730 R08: ffff88808c5d64c0 R09: ffff88808c5d6d88
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffff
> R13: 0000000000000000 R14: ffff88808c4d6f00 R15: 0000000000000000
> FS:  00007f47f49df700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000044 CR3: 0000000097508000 CR4: 00000000001406f0
> Call Trace:
>   sctp_ulpevent_release_data net/sctp/ulpevent.c:1092 [inline]
>   sctp_ulpevent_free+0x21f/0x4e0 net/sctp/ulpevent.c:1129
>   sctp_queue_purge_ulpevents+0xc4/0x110 net/sctp/ulpevent.c:1146
>   sctp_close+0x148/0x860 net/sctp/socket.c:1515
>   inet_release+0x105/0x1f0 net/ipv4/af_inet.c:428
>   inet6_release+0x53/0x80 net/ipv6/af_inet6.c:473
>   __sock_release+0x1fe/0x2b0 net/socket.c:579
>   sock_release+0x18/0x20 net/socket.c:599
>   sctp_do_peeloff+0x38a/0x470 net/sctp/socket.c:5649
>   sctp_getsockopt_peeloff_common.isra.0+0x8e/0x270 net/sctp/socket.c:5665
>   sctp_getsockopt_peeloff net/sctp/socket.c:5707 [inline]
>   sctp_getsockopt net/sctp/socket.c:7802 [inline]
>   sctp_getsockopt+0x1ec1/0x6741 net/sctp/socket.c:7758
>   sock_common_getsockopt+0x9a/0xe0 net/core/sock.c:3079
>   __sys_getsockopt+0x168/0x250 net/socket.c:1960
>   __do_sys_getsockopt net/socket.c:1971 [inline]
>   __se_sys_getsockopt net/socket.c:1968 [inline]
>   __x64_sys_getsockopt+0xbe/0x150 net/socket.c:1968
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x446679
> Code: e8 6c b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 2b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f47f49ded88 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446679
> RDX: 0000000000000066 RSI: 0000000000000084 RDI: 0000000000000003
> RBP: 00000000006dbc30 R08: 0000000020000140 R09: 0000000000000038
> R10: 0000000020000040 R11: 0000000000000246 R12: 00000000006dbc3c
> R13: 00007f47f49ded90 R14: 0000000000000004 R15: 20c49ba5e353f7cf
> Modules linked in:
> ---[ end trace dfa9a15945f164b7 ]---
> RIP: 0010:sctp_assoc_rwnd_increase+0x34/0x520 net/sctp/associola.c:1498
> Code: 41 54 49 89 fc 53 89 f3 48 83 ec 10 e8 95 90 f1 fa 49 8d bc 24 60 06
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
> c0 74 08 3c 03 0f 8e 2f 04 00 00 45 8b ac 24 60 06
> RSP: 0018:ffff88808da476f8 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 00000000000000cb RSI: ffffffff867ecd5b RDI: 000000000000065f
> RBP: ffff88808da47730 R08: ffff88808c5d64c0 R09: ffff88808c5d6d88
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffff
> R13: 0000000000000000 R14: ffff88808c4d6f00 R15: 0000000000000000
> FS:  00007f47f49df700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000044 CR3: 0000000097508000 CR4: 00000000001406f0
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
