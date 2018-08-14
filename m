From: syzbot <syzbot+6a15c8ad0f0632ccd7f3@syzkaller.appspotmail.com>
Date: Tue, 14 Aug 2018 00:55:02 +0000
Subject: WARNING: refcount bug in sctp_transport_put
Message-Id: <000000000000fb3b1605735aa815@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    112cbae26d18 Merge branch 'linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x401622400000
kernel config:  https://syzkaller.appspot.com/x/.config?x2cb8ccd35b1f70
dashboard link: https://syzkaller.appspot.com/bug?extidj15c8ad0f0632ccd7f3
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6a15c8ad0f0632ccd7f3@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 7203 at lib/refcount.c:187  
refcount_sub_and_test+0x2e7/0x350 lib/refcount.c:187
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 7203 Comm: udevd Not tainted 4.18.0-rc8+ #182
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  panic+0x238/0x4e7 kernel/panic.c:184
  __warn.cold.8+0x163/0x1ba kernel/panic.c:536
  report_bug+0x252/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x1fc/0x4d0 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:316
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
RIP: 0010:refcount_sub_and_test+0x2e7/0x350 lib/refcount.c:187
Code: 89 de e8 fc b4 1c fe 84 db 74 07 31 db e9 46 ff ff ff e8 1c b4 1c fe  
48 c7 c7 80 48 3a 87 c6 05 82 f2 25 05 01 e8 f9 cc e7 fd <0f> 0b 31 db e9  
25 ff ff ff 48 8b bd 28 ff ff ff 89 85 34 ff ff ff
RSP: 0018:ffff8801db107598 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff81632481 RDI: ffff8801db107270
RBP: ffff8801db107680 R08: ffff8801b9a22780 R09: 0000000000000002
R10: ffff8801b9a22780 R11: 0000000000000000 R12: 00000000ffffffff
R13: ffff8801db107658 R14: 0000000000000001 R15: ffff8801aefee088
  refcount_dec_and_test+0x1a/0x20 lib/refcount.c:212
  sctp_transport_put+0x76/0x200 net/sctp/transport.c:331
  sctp_generate_heartbeat_event+0x2d7/0x450 net/sctp/sm_sideeffect.c:416
  call_timer_fn+0x242/0x970 kernel/time/timer.c:1326
  expire_timers kernel/time/timer.c:1363 [inline]
  __run_timers+0x7a6/0xc70 kernel/time/timer.c:1666
  run_timer_softirq+0x4c/0x70 kernel/time/timer.c:1692
  __do_softirq+0x2e8/0xb17 kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:372 [inline]
  irq_exit+0x1d4/0x210 kernel/softirq.c:412
  exiting_irq arch/x86/include/asm/apic.h:527 [inline]
  smp_apic_timer_interrupt+0x186/0x730 arch/x86/kernel/apic/apic.c:1055
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
  </IRQ>
RIP: 0010:update_stack_state+0xcc/0x690 arch/x86/kernel/unwind_frame.c:215
Code: 06 49 8d 7e 50 48 89 fa 89 85 24 ff ff ff 48 c1 ea 03 48 b8 00 00 00  
00 00 fc ff df 80 3c 02 00 0f 85 04 05 00 00 49 8b 46 50 <48> 85 c0 0f 84  
66 03 00 00 48 05 a8 00 00 00 48 89 85 10 ff ff ff
RSP: 0018:ffff88018d816a60 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff88018d816cc8 RCX: ffff88018d816c40
RDX: 1ffff10031b02da3 RSI: ffff88018d816d48 RDI: ffff88018d816d18
RBP: ffff88018d816b68 R08: ffff88018d816d00 R09: ffff8801b9a22780
R10: ffffed0031b02da3 R11: ffff88018d816d1f R12: 1ffff10031b02d54
R13: ffff88018d816d48 R14: ffff88018d816cc8 R15: ffff88018d816d18
  unwind_next_frame.part.7+0x1ae/0x9e0 arch/x86/kernel/unwind_frame.c:329
  unwind_next_frame arch/x86/include/asm/unwind.h:40 [inline]
  __unwind_start+0x166/0x330 arch/x86/kernel/unwind_frame.c:414
  unwind_start arch/x86/include/asm/unwind.h:54 [inline]
  __save_stack_trace+0x59/0xf0 arch/x86/kernel/stacktrace.c:43
  save_stack_trace+0x1a/0x20 arch/x86/kernel/stacktrace.c:60
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  slab_post_alloc_hook mm/slab.h:444 [inline]
  slab_alloc mm/slab.c:3392 [inline]
  kmem_cache_alloc+0x11b/0x760 mm/slab.c:3552
  anon_vma_chain_alloc mm/rmap.c:129 [inline]
  anon_vma_clone+0x140/0x740 mm/rmap.c:269
  anon_vma_fork+0xf0/0x960 mm/rmap.c:332
  dup_mmap kernel/fork.c:498 [inline]
  dup_mm kernel/fork.c:1266 [inline]
  copy_mm kernel/fork.c:1320 [inline]
  copy_process.part.39+0x4e53/0x70b0 kernel/fork.c:1826
  copy_process kernel/fork.c:1639 [inline]
  _do_fork+0x291/0x12a0 kernel/fork.c:2122
  __do_sys_clone kernel/fork.c:2229 [inline]
  __se_sys_clone kernel/fork.c:2223 [inline]
  __x64_sys_clone+0xbf/0x150 kernel/fork.c:2223
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f1b0bf66f46
Code: f7 d8 64 89 04 25 d4 02 00 00 64 4c 8b 14 25 10 00 00 00 31 d2 49 81  
c2 d0 02 00 00 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff  
ff 0f 87 31 01 00 00 85 c0 41 89 c4 0f 85 3b 01 00
RSP: 002b:00007ffc9eb9ddb0 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ffc9eb9ddb0 RCX: 00007f1b0bf66f46
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007ffc9eb9de10 R08: 0000000000001c23 R09: 0000000000001c23
R10: 00007f1b0c883a70 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9eb9ddd0 R14: 0000000000000005 R15: 0000000000000005
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
