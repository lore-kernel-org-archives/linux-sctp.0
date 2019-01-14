From: syzbot <syzbot+ae0c70c0c2d40c51bb92@syzkaller.appspotmail.com>
Date: Mon, 14 Jan 2019 11:08:04 +0000
Subject: KMSAN: kernel-infoleak in sctp_getsockopt (2)
Message-Id: <00000000000013fb5c057f690f53@google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000311344057c4b6cc3@google.com>
In-Reply-To: <000000000000311344057c4b6cc3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, glider@google.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    02f2d5aea531 kmsan: (presumably) fix dma_map_page_attrs()
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=164291d8c00000
kernel config:  https://syzkaller.appspot.com/x/.config?xRc9737ec5618f82
dashboard link: https://syzkaller.appspot.com/bug?extid=AE0c70c0c2d40c51bb92
compiler:       clang version 8.0.0 (trunk 350509)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1753eaf7400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b22a37400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ae0c70c0c2d40c51bb92@syzkaller.appspotmail.com

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
CPU: 1 PID: 10740 Comm: syz-executor064 Not tainted 5.0.0-rc1+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =20
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
  kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:600
  kmsan_internal_check_memory+0x465/0xb10 mm/kmsan/kmsan.c:663
  kmsan_copy_to_user+0xab/0xc0 mm/kmsan/kmsan_hooks.c:601
  _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
  copy_to_user include/linux/uaccess.h:174 [inline]
  sctp_getsockopt_local_addrs net/sctp/socket.c:6056 [inline]
  sctp_getsockopt+0x1309a/0x17f70 net/sctp/socket.c:7566
  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
  __sys_getsockopt+0x489/0x550 net/socket.c:1939
  __do_sys_getsockopt net/socket.c:1950 [inline]
  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x445679
Code: e8 6c b6 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 =
=20
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  =

ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa7633b9db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000006dac38 RCX: 0000000000445679
RDX: 000000000000006d RSI: 0000000000000084 RDI: 0000000000000004
RBP: 00000000006dac30 R08: 00000000200000c0 R09: 0000000000000000
R10: 0000000020000200 R11: 0000000000000246 R12: 00000000006dac3c
R13: 00007ffc3e29873f R14: 00007fa7633ba9c0 R15: 00000000006dad2c

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
  kmsan_memcpy_memmove_metadata+0xcf2/0xf10 mm/kmsan/kmsan.c:304
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
  sctp_copy_laddrs net/sctp/socket.c:5959 [inline]
  sctp_getsockopt_local_addrs net/sctp/socket.c:6025 [inline]
  sctp_getsockopt+0x13887/0x17f70 net/sctp/socket.c:7566
  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
  __sys_getsockopt+0x489/0x550 net/socket.c:1939
  __do_sys_getsockopt net/socket.c:1950 [inline]
  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
  kmsan_memcpy_memmove_metadata+0xcf2/0xf10 mm/kmsan/kmsan.c:304
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
  sctp_copy_laddrs net/sctp/socket.c:5948 [inline]
  sctp_getsockopt_local_addrs net/sctp/socket.c:6025 [inline]
  sctp_getsockopt+0x13733/0x17f70 net/sctp/socket.c:7566
  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
  __sys_getsockopt+0x489/0x550 net/socket.c:1939
  __do_sys_getsockopt net/socket.c:1950 [inline]
  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
  kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:159
  kmsan_kmalloc+0xa6/0x130 mm/kmsan/kmsan_hooks.c:176
  kmem_cache_alloc_trace+0x55d/0xb40 mm/slub.c:2784
  kmalloc include/linux/slab.h:545 [inline]
  sctp_inetaddr_event+0x47b/0xa90 net/sctp/protocol.c:779
  notifier_call_chain kernel/notifier.c:93 [inline]
  __blocking_notifier_call_chain kernel/notifier.c:317 [inline]
  blocking_notifier_call_chain+0x1a5/0x2f0 kernel/notifier.c:328
  __inet_insert_ifa+0xfaa/0x1200 net/ipv4/devinet.c:529
  inet_insert_ifa net/ipv4/devinet.c:536 [inline]
  inetdev_event+0x1ced/0x1d80 net/ipv4/devinet.c:1520
  notifier_call_chain kernel/notifier.c:93 [inline]
  __raw_notifier_call_chain kernel/notifier.c:394 [inline]
  raw_notifier_call_chain+0x13d/0x240 kernel/notifier.c:401
  __dev_notify_flags+0x3d3/0x830 net/core/dev.c:1739
  dev_change_flags+0x1d6/0x260 net/core/dev.c:7643
  do_setlink+0x16a4/0x5df0 net/core/rtnetlink.c:2492
  __rtnl_newlink net/core/rtnetlink.c:3115 [inline]
  rtnl_newlink+0x2d68/0x37a0 net/core/rtnetlink.c:3240
  rtnetlink_rcv_msg+0x115b/0x1550 net/core/rtnetlink.c:5130
  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5148
  netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
  netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0x127f/0x1300 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:621 [inline]
  sock_sendmsg net/socket.c:631 [inline]
  ___sys_sendmsg+0xdb9/0x11b0 net/socket.c:2116
  __sys_sendmsg net/socket.c:2154 [inline]
  __do_sys_sendmsg net/socket.c:2163 [inline]
  __se_sys_sendmsg+0x305/0x460 net/socket.c:2161
  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2161
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Bytes 8-15 of 32 are uninitialized
Memory access of size 32 starts at ffff88810b2dac00
Data copied to user address 0000000020000208
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with =20
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
