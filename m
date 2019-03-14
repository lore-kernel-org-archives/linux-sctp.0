From: syzbot <syzbot+3d357cc384ddccdc2fff@syzkaller.appspotmail.com>
Date: Thu, 14 Mar 2019 21:02:05 +0000
Subject: general protection fault in sctp_sched_dequeue_common (2)
Message-Id: <0000000000000e839b0584143c8c@google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000014c430057b252d70@google.com>
In-Reply-To: <00000000000014c430057b252d70@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    d9862cfb Merge tag 'mips_5.1' of git://git.kernel.org/pub/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x2308f7200000
kernel config:  https://syzkaller.appspot.com/x/.config?xsd88a42238825ad
dashboard link: https://syzkaller.appspot.com/bug?extid=357cc384ddccdc2fff
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: amd64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?xf95493200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x3be2cf200000

The crash was bisected to:

commit 7efba10d6bd22030fb5931e50bf97496f932f00e
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jan 28 07:08:46 2019 +0000

     sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for  
SCTP_STREAM_SCHEDULER sockopt

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x67361b200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x67361b200000
console output: https://syzkaller.appspot.com/x/log.txt?x67361b200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3d357cc384ddccdc2fff@syzkaller.appspotmail.com
Fixes: 7efba10d ("sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for  
SCTP_STREAM_SCHEDULER sockopt")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7793 Comm: syz-executor452 Not tainted 5.0.0+ #97
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
Code: 0f 84 e1 00 00 00 48 b8 00 02 00 00 00 00 ad de 49 39 c4 0f 84 e2 00  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75  
53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
RSP: 0018:ffff88809e8c6fd8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88808fdd6d10 RCX: ffffffff86799d9f
RDX: 0000000000000000 RSI: ffffffff86815d20 RDI: ffff88808fdd6d18
RBP: ffff88809e8c6ff0 R08: ffff888091bc0080 R09: 0000000000000002
R10: ffffed1015d25bcf R11: ffff8880ae92de7b R12: 0000000000000006
R13: 0000000100000000 R14: ffff88808fdd6d10 R15: ffff88809e8c7198
FS:  0000000000fad880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 00000000a1385000 CR4: 00000000001406e0
Call Trace:
  __list_del_entry include/linux/list.h:117 [inline]
  list_del_init include/linux/list.h:159 [inline]
  sctp_sched_dequeue_common+0x28/0x340 net/sctp/stream_sched.c:267
  sctp_sched_prio_dequeue+0xec/0x1a0 net/sctp/stream_sched_prio.c:283
  sctp_outq_dequeue_data net/sctp/outqueue.c:90 [inline]
  sctp_outq_flush_data net/sctp/outqueue.c:1079 [inline]
  sctp_outq_flush+0xba2/0x2790 net/sctp/outqueue.c:1205
  sctp_outq_uncork+0x6c/0x80 net/sctp/outqueue.c:772
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
  sctp_do_sm+0x513/0x5390 net/sctp/sm_sideeffect.c:1191
  sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1074
  sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
  sctp_backlog_rcv+0x189/0xbc0 net/sctp/input.c:354
  sk_backlog_rcv include/net/sock.h:937 [inline]
  __release_sock+0x12e/0x3a0 net/core/sock.c:2413
  release_sock+0x59/0x1c0 net/core/sock.c:2929
  sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:8999
  sctp_sendmsg_to_asoc+0x13e2/0x17d0 net/sctp/socket.c:1968
  sctp_sendmsg+0x10a9/0x17e0 net/sctp/socket.c:2114
  inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:622 [inline]
  sock_sendmsg+0xdd/0x130 net/socket.c:632
  ___sys_sendmsg+0x806/0x930 net/socket.c:2137
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2175
  __do_sys_sendmsg net/socket.c:2184 [inline]
  __se_sys_sendmsg net/socket.c:2182 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2182
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff60414978 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402a9
RDX: 0000000000000000 RSI: 000000002001afc8 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000401b30
R13: 0000000000401bc0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 8121cdb67bdbbfc9 ]---
RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
Code: 0f 84 e1 00 00 00 48 b8 00 02 00 00 00 00 ad de 49 39 c4 0f 84 e2 00  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75  
53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
RSP: 0018:ffff88809e8c6fd8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88808fdd6d10 RCX: ffffffff86799d9f
RDX: 0000000000000000 RSI: ffffffff86815d20 RDI: ffff88808fdd6d18
RBP: ffff88809e8c6ff0 R08: ffff888091bc0080 R09: 0000000000000002
R10: ffffed1015d25bcf R11: ffff8880ae92de7b R12: 0000000000000006
R13: 0000000100000000 R14: ffff88808fdd6d10 R15: ffff88809e8c7198
FS:  0000000000fad880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 00000000a1385000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
