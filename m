From: syzbot <syzbot+5aab5972d41ebaa03f25@syzkaller.appspotmail.com>
Date: Tue, 19 Mar 2019 09:22:05 +0000
Subject: general protection fault in sctp_v6_get_dst (2)
Message-Id: <000000000000e8335605846f099f@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    3b319ee2 Merge tag 'acpi-5.1-rc1-2' of git://git.kernel.or..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17aa922b200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=F05902bca21d8935
dashboard link: https://syzkaller.appspot.com/bug?extidZab5972d41ebaa03f25
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5aab5972d41ebaa03f25@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7466 Comm: syz-executor.1 Not tainted 5.0.0+ #98
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =20
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:193 [inline]
RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:260 [inline]
RIP: 0010:sctp_v6_get_dst+0x8ae/0x1d80 net/sctp/ipv6.c:378
Code: fa 84 db 0f 84 15 10 00 00 e8 4e 39 e5 fa 48 8b 85 10 ff ff ff 48 8d =
=20
78 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  =

85 48 13 00 00 48 8b 85 10 ff ff ff 4c 8b 60 70 e8
RSP: 0018:ffff8880ae906f50 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffffff868b2ad5
RDX: 0000000000000aa6 RSI: ffffffff868b2ae2 RDI: 0000000000005530
RBP: ffff8880ae9070a0 R08: ffff88806f550240 R09: ffffed1015d25bc8
R10: ffffed1015d25bc7 R11: ffff8880ae92de3b R12: ffff888099202e48
R13: dffffc0000000000 R14: 000000000000000a R15: 000000000000234e
FS:  00007f32d267b700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000073c000 CR3: 0000000093391000 CR4: 00000000001406e0
Call Trace:
  <IRQ>
  sctp_transport_route+0x132/0x370 net/sctp/transport.c:312
  sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:678
  sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
  sctp_process_init+0x249f/0x2b20 net/sctp/sm_make_chunk.c:2361
  sctp_sf_do_5_1B_init+0x8ba/0xe50 net/sctp/sm_statefuns.c:416
  sctp_do_sm+0x124/0x53e0 net/sctp/sm_sideeffect.c:1188
  sctp_endpoint_bh_rcv+0x451/0x950 net/sctp/endpointola.c:458
  sctp_inq_push+0x1ea/0x290 net/sctp/inqueue.c:95
  sctp_rcv+0x27e0/0x3530 net/sctp/input.c:271
  sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1063
  ip6_protocol_deliver_rcu+0x303/0x16c0 net/ipv6/ip6_input.c:394
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:434
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:443
  dst_input include/net/dst.h:450 [inline]
  ip6_rcv_finish+0x1e7/0x320 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
  __netif_receive_skb_one_core+0x115/0x1a0 net/core/dev.c:4973
  __netif_receive_skb+0x2c/0x1c0 net/core/dev.c:5083
  process_backlog+0x206/0x750 net/core/dev.c:5923
  napi_poll net/core/dev.c:6346 [inline]
  net_rx_action+0x4fa/0x1070 net/core/dev.c:6412
  __do_softirq+0x266/0x95a kernel/softirq.c:293
  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1027
  </IRQ>
  do_softirq.part.0+0x11a/0x170 kernel/softirq.c:338
  do_softirq kernel/softirq.c:330 [inline]
  __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:190
  local_bh_enable include/linux/bottom_half.h:32 [inline]
  rcu_read_unlock_bh include/linux/rcupdate.h:684 [inline]
  ip6_finish_output2+0xbcf/0x2550 net/ipv6/ip6_output.c:121
  ip6_finish_output+0x577/0xc30 net/ipv6/ip6_output.c:154
  NF_HOOK_COND include/linux/netfilter.h:278 [inline]
  ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:171
  dst_output include/net/dst.h:444 [inline]
  NF_HOOK include/linux/netfilter.h:289 [inline]
  NF_HOOK include/linux/netfilter.h:283 [inline]
  ip6_xmit+0xe41/0x20c0 net/ipv6/ip6_output.c:275
  sctp_v6_xmit+0x313/0x660 net/sctp/ipv6.c:232
  sctp_packet_transmit+0x1bba/0x3650 net/sctp/output.c:641
  sctp_packet_singleton net/sctp/outqueue.c:787 [inline]
  sctp_outq_flush_ctrl.constprop.0+0x6d4/0xd50 net/sctp/outqueue.c:918
  sctp_outq_flush+0xe8/0x2780 net/sctp/outqueue.c:1200
  sctp_outq_uncork+0x6c/0x80 net/sctp/outqueue.c:772
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
  sctp_do_sm+0x559/0x53e0 net/sctp/sm_sideeffect.c:1191
  sctp_primitive_ASSOCIATE+0x9d/0xd0 net/sctp/primitive.c:88
  __sctp_connect+0x8cd/0xce0 net/sctp/socket.c:1226
  __sctp_setsockopt_connectx+0x133/0x1a0 net/sctp/socket.c:1349
  sctp_setsockopt_connectx_old net/sctp/socket.c:1365 [inline]
  sctp_setsockopt net/sctp/socket.c:4617 [inline]
  sctp_setsockopt+0x22cc/0x68a0 net/sctp/socket.c:4581
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3120
  __sys_setsockopt+0x180/0x280 net/socket.c:1923
  __do_sys_setsockopt net/socket.c:1934 [inline]
  __se_sys_setsockopt net/socket.c:1931 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1931
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458079
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 =
=20
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  =

ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f32d267ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000458079
RDX: 000000000000006b RSI: 0000000000000084 RDI: 0000000000000004
RBP: 000000000073bf00 R08: 000000000000001c R09: 0000000000000000
R10: 000000002055bfe4 R11: 0000000000000246 R12: 00007f32d267b6d4
R13: 00000000004ccb98 R14: 00000000004da940 R15: 00000000ffffffff
Modules linked in:
---[ end trace 333b929024b335c7 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:193 [inline]
RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:260 [inline]
RIP: 0010:sctp_v6_get_dst+0x8ae/0x1d80 net/sctp/ipv6.c:378
Code: fa 84 db 0f 84 15 10 00 00 e8 4e 39 e5 fa 48 8b 85 10 ff ff ff 48 8d =
=20
78 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  =

85 48 13 00 00 48 8b 85 10 ff ff ff 4c 8b 60 70 e8
RSP: 0018:ffff8880ae906f50 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffffff868b2ad5
RDX: 0000000000000aa6 RSI: ffffffff868b2ae2 RDI: 0000000000005530
RBP: ffff8880ae9070a0 R08: ffff88806f550240 R09: ffffed1015d25bc8
R10: ffffed1015d25bc7 R11: ffff8880ae92de3b R12: ffff888099202e48
R13: dffffc0000000000 R14: 000000000000000a R15: 000000000000234e
FS:  00007f32d267b700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000073c000 CR3: 0000000093391000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with =20
syzbot.
