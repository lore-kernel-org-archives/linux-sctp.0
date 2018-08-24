From: syzbot <syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com>
Date: Fri, 24 Aug 2018 07:40:03 +0000
Subject: KASAN: use-after-free Read in sctp_transport_get_next
Message-Id: <000000000000ccaf1d0574297b6b@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    815f0ddb346c include/linux/compiler*.h: make compiler-*.h ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14adfea6400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=E408e8a7bf8306cb
dashboard link: https://syzkaller.appspot.com/bug?extid=FE62a0c9aa6a85c6de16
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
userspace arch: i386
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=130da896400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in sctp_transport_get_next+0x11c/0x140 =20
net/sctp/socket.c:5008
Read of size 8 at addr ffff8801d97c84e0 by task syz-executor0/12694

CPU: 1 PID: 12694 Comm: syz-executor0 Not tainted 4.18.0+ #107
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =20
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  sctp_transport_get_next+0x11c/0x140 net/sctp/socket.c:5008
  sctp_transport_get_idx net/sctp/socket.c:5022 [inline]
  sctp_for_each_transport+0x152/0x370 net/sctp/socket.c:5083
  sctp_diag_dump+0x3a7/0x620 net/sctp/diag.c:527
  __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
  inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
  netlink_dump+0x519/0xd50 net/netlink/af_netlink.c:2233
  __netlink_dump_start+0x4f1/0x6f0 net/netlink/af_netlink.c:2329
  netlink_dump_start include/linux/netlink.h:213 [inline]
  inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2454
  sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
  netlink_unicast+0x5a0/0x760 net/netlink/af_netlink.c:1343
  netlink_sendmsg+0xa18/0xfc0 net/netlink/af_netlink.c:1908
  sock_sendmsg_nosec net/socket.c:621 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:631
  sock_write_iter+0x362/0x5c0 net/socket.c:900
  call_write_iter include/linux/fs.h:1805 [inline]
  do_iter_readv_writev+0x8b0/0xa80 fs/read_write.c:680
  do_iter_write+0x185/0x5f0 fs/read_write.c:959
  compat_writev+0x234/0x420 fs/read_write.c:1273
  do_compat_writev+0x128/0x260 fs/read_write.c:1294
  __do_compat_sys_writev fs/read_write.c:1305 [inline]
  __se_compat_sys_writev fs/read_write.c:1301 [inline]
  __ia32_compat_sys_writev+0x74/0xb0 fs/read_write.c:1301
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x34d/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f6aca9
Code: 55 08 8b 88 64 cd ff ff 8b 98 68 cd ff ff 89 c8 85 d2 74 02 89 0a 5b =
=20
5d c3 8b 04 24 c3 8b 1c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  =

90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f7f660cc EFLAGS: 00000296 ORIG_RAX: 0000000000000092
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 0000000020000000
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 12694:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x730 mm/slab.c:3620
  kmalloc include/linux/slab.h:513 [inline]
  kzalloc include/linux/slab.h:707 [inline]
  sctp_association_new+0x127/0x2290 net/sctp/associola.c:311
  sctp_unpack_cookie+0x7b4/0x1160 net/sctp/sm_make_chunk.c:1829
  sctp_sf_do_5_1D_ce+0x451/0x14c0 net/sctp/sm_statefuns.c:743
  sctp_do_sm+0x1c1/0x71e0 net/sctp/sm_sideeffect.c:1188
  sctp_endpoint_bh_rcv+0x465/0x960 net/sctp/endpointola.c:456
  sctp_inq_push+0x272/0x340 net/sctp/inqueue.c:95
  sctp_rcv+0x2cb2/0x3ab0 net/sctp/input.c:268
  sctp6_rcv+0x15/0x30 net/sctp/ipv6.c:1061
  ip6_input_finish+0x407/0x1a40 net/ipv6/ip6_input.c:383
  NF_HOOK include/linux/netfilter.h:287 [inline]
  ip6_input+0xe9/0x600 net/ipv6/ip6_input.c:426
  dst_input include/net/dst.h:450 [inline]
  ip6_rcv_finish+0x17a/0x330 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:287 [inline]
  ipv6_rcv+0x11e/0x650 net/ipv6/ip6_input.c:271
  __netif_receive_skb_one_core+0x14d/0x200 net/core/dev.c:4892
  __netif_receive_skb+0x2c/0x1e0 net/core/dev.c:5002
  process_backlog+0x219/0x760 net/core/dev.c:5808
  napi_poll net/core/dev.c:6228 [inline]
  net_rx_action+0x799/0x1900 net/core/dev.c:6294
  __do_softirq+0x2eb/0xa74 kernel/softirq.c:292

Freed by task 12693:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x210 mm/slab.c:3813
  sctp_association_destroy net/sctp/associola.c:437 [inline]
  sctp_association_put+0x264/0x350 net/sctp/associola.c:885
  sctp_association_free+0x6c9/0x972 net/sctp/associola.c:415
  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:939 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1353 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
  sctp_do_sm+0x4a5c/0x71e0 net/sctp/sm_sideeffect.c:1191
  sctp_primitive_ABORT+0xa0/0xd0 net/sctp/primitive.c:119
  sctp_close+0x279/0xa80 net/sctp/socket.c:1559
  inet_release+0x104/0x1f0 net/ipv4/af_inet.c:428
  inet6_release+0x50/0x70 net/ipv6/af_inet6.c:457
  __sock_release+0xd7/0x250 net/socket.c:579
  sock_close+0x19/0x20 net/socket.c:1139
  __fput+0x36e/0x8c0 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:341 [inline]
  do_fast_syscall_32+0xcd5/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff8801d97c84c0
  which belongs to the cache kmalloc-4096 of size 4096
The buggy address is located 32 bytes inside of
  4096-byte region [ffff8801d97c84c0, ffff8801d97c94c0)
The buggy address belongs to the page:
page:ffffea000765f200 count:1 mapcount:0 mapping:ffff8801dac00dc0 index:0x0=
 =20
compound_mapcount: 0
flags: 0x2fffc0000008100(slab|head)
raw: 02fffc0000008100 ffffea0007628888 ffffea0007620608 ffff8801dac00dc0
raw: 0000000000000000 ffff8801d97c84c0 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d97c8380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8801d97c8400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8801d97c8480: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                        ^
  ffff8801d97c8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d97c8580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
