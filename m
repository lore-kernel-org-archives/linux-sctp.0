From: Eric Biggers <ebiggers3@gmail.com>
Date: Sat, 12 May 2018 19:58:02 +0000
Subject: Re: KASAN: use-after-free Read in sctp_packet_transmit
Message-Id: <20180512200004.GA817@sol.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fcf4cf899b405620eaa66@google.com>
In-Reply-To: <94eb2c1fcf4cf899b405620eaa66@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Fri, Jan 05, 2018 at 02:07:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 8a4816cad00bf14642f0ed6043b32d29a05006ce
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> =================================
> BUG: KASAN: use-after-free in sctp_packet_transmit+0x3505/0x3750
> net/sctp/output.c:643
> Read of size 8 at addr ffff8801bda9fb80 by task modprobe/23740
> 
> CPU: 1 PID: 23740 Comm: modprobe Not tainted 4.15.0-rc5+ #175
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>  sctp_packet_transmit+0x3505/0x3750 net/sctp/output.c:643
>  sctp_outq_flush+0x121b/0x4060 net/sctp/outqueue.c:1197
>  sctp_outq_uncork+0x5a/0x70 net/sctp/outqueue.c:776
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1807 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1210 [inline]
>  sctp_do_sm+0x4e0/0x6ed0 net/sctp/sm_sideeffect.c:1181
>  sctp_generate_heartbeat_event+0x292/0x3f0 net/sctp/sm_sideeffect.c:406
>  call_timer_fn+0x228/0x820 kernel/time/timer.c:1320
>  expire_timers kernel/time/timer.c:1357 [inline]
>  __run_timers+0x7ee/0xb70 kernel/time/timer.c:1660
>  run_timer_softirq+0x4c/0xb0 kernel/time/timer.c:1686
>  __do_softirq+0x2d7/0xb85 kernel/softirq.c:285
>  invoke_softirq kernel/softirq.c:365 [inline]
>  irq_exit+0x1cc/0x200 kernel/softirq.c:405
>  exiting_irq arch/x86/include/asm/apic.h:540 [inline]
>  smp_apic_timer_interrupt+0x16b/0x700 arch/x86/kernel/apic/apic.c:1052
>  apic_timer_interrupt+0xa9/0xb0 arch/x86/entry/entry_64.S:904
>  </IRQ>
> RIP: 0010:__preempt_count_add arch/x86/include/asm/preempt.h:76 [inline]
> RIP: 0010:__rcu_read_lock include/linux/rcupdate.h:83 [inline]
> RIP: 0010:rcu_read_lock include/linux/rcupdate.h:629 [inline]
> RIP: 0010:__is_insn_slot_addr+0x8f/0x330 kernel/kprobes.c:303
> RSP: 0018:ffff8801d4937430 EFLAGS: 00000283 ORIG_RAX: ffffffffffffff11
> RAX: ffff8801bf13c000 RBX: ffffffff8656dd00 RCX: ffffffff8170bd88
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8656dd00
> RBP: ffff8801d4937518 R08: 0000000000000000 R09: 1ffff1003a926e67
> R10: ffff8801d4937300 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8801d49374f0 R15: ffff8801dae230c0
>  is_kprobe_insn_slot include/linux/kprobes.h:318 [inline]
>  kernel_text_address+0x132/0x140 kernel/extable.c:150
>  __kernel_text_address+0xd/0x40 kernel/extable.c:107
>  unwind_get_return_address+0x61/0xa0 arch/x86/kernel/unwind_frame.c:18
>  __save_stack_trace+0x7e/0xd0 arch/x86/kernel/stacktrace.c:45
>  save_stack_trace+0x1a/0x20 arch/x86/kernel/stacktrace.c:60
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:489
>  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3544
>  kmem_cache_zalloc include/linux/slab.h:678 [inline]
>  file_alloc_security security/selinux/hooks.c:369 [inline]
>  selinux_file_alloc_security+0xae/0x190 security/selinux/hooks.c:3454
>  security_file_alloc+0x6d/0xa0 security/security.c:873
>  get_empty_filp+0x189/0x4f0 fs/file_table.c:129
>  path_openat+0xed/0x3530 fs/namei.c:3496
>  do_filp_open+0x25b/0x3b0 fs/namei.c:3554
>  do_sys_open+0x502/0x6d0 fs/open.c:1059
>  SYSC_open fs/open.c:1077 [inline]
>  SyS_open+0x2d/0x40 fs/open.c:1072
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> RIP: 0033:0x7efdff1bb120
> RSP: 002b:00007ffde6213c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 000055c34fab4090 RCX: 00007efdff1bb120
> RDX: 00000000000001b6 RSI: 0000000000080000 RDI: 00007ffde6213d20
> RBP: 00007ffde6214d90 R08: 0000000000000008 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000246 R12: 000055c34fab4090
> R13: 00007ffde6215de0 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 23739:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:489
>  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3544
>  kmem_cache_zalloc include/linux/slab.h:678 [inline]
>  sctp_chunkify+0xce/0x3f0 net/sctp/sm_make_chunk.c:1329
>  _sctp_make_chunk+0x13c/0x260 net/sctp/sm_make_chunk.c:1397
>  sctp_make_control+0x39/0x150 net/sctp/sm_make_chunk.c:1433
>  sctp_make_heartbeat+0x90/0x420 net/sctp/sm_make_chunk.c:1151
>  sctp_sf_heartbeat.isra.24+0x26/0x180 net/sctp/sm_statefuns.c:973
>  sctp_sf_do_prm_requestheartbeat+0x27/0x100 net/sctp/sm_statefuns.c:5251
>  sctp_do_sm+0x192/0x6ed0 net/sctp/sm_sideeffect.c:1178
>  sctp_primitive_REQUESTHEARTBEAT+0xa0/0xd0 net/sctp/primitive.c:200
>  sctp_apply_peer_addr_params+0x759/0xf30 net/sctp/socket.c:2462
>  sctp_setsockopt_peer_addr_params+0x36f/0x5f0 net/sctp/socket.c:2658
>  sctp_setsockopt+0x199a/0x61a0 net/sctp/socket.c:4173
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2978
>  SYSC_setsockopt net/socket.c:1821 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1800
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> Freed by task 23739:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3488 [inline]
>  kmem_cache_free+0x83/0x2a0 mm/slab.c:3746
>  sctp_chunk_destroy net/sctp/sm_make_chunk.c:1450 [inline]
>  sctp_chunk_put+0x2fd/0x420 net/sctp/sm_make_chunk.c:1473
>  sctp_chunk_free+0x53/0x60 net/sctp/sm_make_chunk.c:1460
>  sctp_packet_transmit+0xf5d/0x3750 net/sctp/output.c:646
>  sctp_outq_flush+0x121b/0x4060 net/sctp/outqueue.c:1197
>  sctp_outq_uncork+0x5a/0x70 net/sctp/outqueue.c:776
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1807 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1210 [inline]
>  sctp_do_sm+0x4e0/0x6ed0 net/sctp/sm_sideeffect.c:1181
>  sctp_primitive_REQUESTHEARTBEAT+0xa0/0xd0 net/sctp/primitive.c:200
>  sctp_apply_peer_addr_params+0x759/0xf30 net/sctp/socket.c:2462
>  sctp_setsockopt_peer_addr_params+0x36f/0x5f0 net/sctp/socket.c:2658
>  sctp_setsockopt+0x199a/0x61a0 net/sctp/socket.c:4173
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2978
>  SYSC_setsockopt net/socket.c:1821 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1800
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> The buggy address belongs to the object at ffff8801bda9fb80
>  which belongs to the cache sctp_chunk of size 256
> The buggy address is located 0 bytes inside of
>  256-byte region [ffff8801bda9fb80, ffff8801bda9fc80)
> The buggy address belongs to the page:
> page:00000000d1261812 count:1 mapcount:0 mapping:000000003e733284 index:0x0
> flags: 0x2fffc0000000100(slab)
> raw: 02fffc0000000100 ffff8801bda9f040 0000000000000000 000000010000000c
> raw: ffffea000714c9e0 ffffea0006fa8520 ffff8801d3246c80 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801bda9fa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801bda9fb00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> > ffff8801bda9fb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff8801bda9fc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801bda9fc80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> =================================
> 
> 
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.

No reproducer, this only happened once (Jan 5 on net-next), and there have been
a lot of SCTP fixes in the mean time including commit 6910e25de225 ("sctp:
remove sctp_chunk_put from fail_mark err path in sctp_ulpevent_make_rcvmsg")
which may be relevant since it fixed a case of incorrect reference counting of
'struct sctp_chunk', which is the struct in which the use-after-free occurred
here.  So I'm just invalidating this bug:

#syz invalid

- Eric
