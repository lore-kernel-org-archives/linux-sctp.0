From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 03 Nov 2017 11:27:41 +0000
Subject: Re: KASAN: use-after-free Read in refcount_inc_not_zero
Message-Id: <CADvbK_cT92eLmz-tuid21bMudgFUSpj3Hnh1AgF8=gxYsTxszg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fae04669449055d036865@google.com>
In-Reply-To: <94eb2c1fae04669449055d036865@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+9e3011b5e961675e736b38d6fd82ad12723a3fa3@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Fri, Nov 3, 2017 at 1:35 AM, syzbot
<bot+9e3011b5e961675e736b38d6fd82ad12723a3fa3@syzkaller.appspotmail.com>
wrote:
> Hello,
>
> syzkaller hit the following crash on
> 73d3393ada4f70fa3df5639c8d438f2f034c0ecb
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
the log is too log to identify the issue. not sure if it's possible
to make it shorter.

otherwise, let's see if it still exists after fixing the last use-after-free
issue, I feel they are relevant.

thanks.

>
>
>
>
> netlink: 1 bytes leftover after parsing attributes in process
> `syz-executor4'.
> =================================
> BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:276
> [inline]
> BUG: KASAN: use-after-free in atomic_read arch/x86/include/asm/atomic.h:26
> [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero+0x16e/0x180
> lib/refcount.c:119
> Read of size 4 at addr ffff8801c9de8ad8 by task syz-executor6/8757
>
> CPU: 0 PID: 8757 Comm: syz-executor6 Not tainted 4.14.0-rc5+ #138
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:16 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:52
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:429
>  __read_once_size include/linux/compiler.h:276 [inline]
>  atomic_read arch/x86/include/asm/atomic.h:26 [inline]
>  refcount_inc_not_zero+0x16e/0x180 lib/refcount.c:119
>  refcount_inc+0x15/0x50 lib/refcount.c:152
>  sctp_association_hold+0x16/0x20 net/sctp/associola.c:875
>  sctp_generate_timeout_event+0x2b0/0x330 net/sctp/sm_sideeffect.c:297
>  sctp_generate_t1_init_event+0x1a/0x20 net/sctp/sm_sideeffect.c:330
>  call_timer_fn+0x233/0x830 kernel/time/timer.c:1281
>  expire_timers kernel/time/timer.c:1320 [inline]
>  __run_timers+0x7fd/0xb90 kernel/time/timer.c:1620
>  run_timer_softirq+0x4c/0xb0 kernel/time/timer.c:1646
>  __do_softirq+0x2d7/0xb85 kernel/softirq.c:284
>  invoke_softirq kernel/softirq.c:364 [inline]
>  irq_exit+0x1cc/0x200 kernel/softirq.c:405
>  exiting_irq arch/x86/include/asm/apic.h:638 [inline]
>  smp_apic_timer_interrupt+0x177/0x710 arch/x86/kernel/apic/apic.c:1059
>  apic_timer_interrupt+0x9d/0xb0 arch/x86/entry/entry_64.S:770
>  </IRQ>
> RIP: 0010:copy_page+0x7/0x10 arch/x86/lib/copy_page_64.S:17
> RSP: 0018:ffff8801d2656e48 EFLAGS: 00010286 ORIG_RAX: ffffffffffffff10
> RAX: ffff8801905c0100 RBX: 0000000006290080 RCX: 0000000000000140
> RDX: 0000000000000000 RSI: ffff88018a402600 RDI: ffff880172c02600
> RBP: ffff8801d2656f98 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
> R13: ffff880000000000 R14: dffffc0000000000 R15: ffffffffffa20000
>  migrate_page+0x149/0x1f0 mm/migrate.c:751
>  move_to_new_page+0x3e1/0x8c0 mm/migrate.c:916
>  __unmap_and_move+0xad2/0x1190 mm/migrate.c:1087
>  unmap_and_move mm/migrate.c:1170 [inline]
>  migrate_pages+0x956/0x2610 mm/migrate.c:1404
>  do_mbind+0xa98/0xce0 mm/mempolicy.c:1239
>  SYSC_mbind mm/mempolicy.c:1341 [inline]
>  SyS_mbind+0x13b/0x150 mm/mempolicy.c:1323
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
> RIP: 0033:0x452719
> RSP: 002b:00007f37fadc7be8 EFLAGS: 00000212 ORIG_RAX: 00000000000000ed
> RAX: ffffffffffffffda RBX: 00000000007580d8 RCX: 0000000000452719
> RDX: 0000000000000000 RSI: 0000000000800000 RDI: 00000000203b5000
> RBP: 0000000000000082 R08: 0000000000000001 R09: 0000000000000002
> R10: 0000000020001ff8 R11: 0000000000000212 R12: 0000000000000000
> R13: 0000000000a6f7ff R14: 00007f37fadc89c0 R15: 0000000000000011
>
> Allocated by task 8763:
>  save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x136/0x750 mm/slab.c:3627
>  kmalloc include/linux/slab.h:493 [inline]
>  kzalloc include/linux/slab.h:666 [inline]
>  sctp_association_new+0x114/0x21e0 net/sctp/associola.c:309
>  sctp_sendmsg+0x128c/0x31f0 net/sctp/socket.c:1838
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:762
>  sock_sendmsg_nosec net/socket.c:633 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:643
>  SYSC_sendto+0x352/0x5a0 net/socket.c:1750
>  SyS_sendto+0x40/0x50 net/socket.c:1718
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
>
> Freed by task 8776:
>  save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3503 [inline]
>  kfree+0xca/0x250 mm/slab.c:3820
>  sctp_association_destroy net/sctp/associola.c:435 [inline]
>  sctp_association_put+0x21c/0x2f0 net/sctp/associola.c:884
>  sctp_association_free+0x688/0x930 net/sctp/associola.c:413
>  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:919 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1333 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1200 [inline]
>  sctp_do_sm+0x28e7/0x6dd0 net/sctp/sm_sideeffect.c:1171
>  sctp_primitive_SHUTDOWN+0xa0/0xd0 net/sctp/primitive.c:104
>  sctp_close+0x3c6/0x980 net/sctp/socket.c:1532
>  inet_release+0xed/0x1c0 net/ipv4/af_inet.c:425
>  inet6_release+0x50/0x70 net/ipv6/af_inet6.c:433
>  sock_release+0x8d/0x1e0 net/socket.c:597
>  sock_close+0x16/0x20 net/socket.c:1126
>  __fput+0x327/0x7e0 fs/file_table.c:210
>  ____fput+0x15/0x20 fs/file_table.c:244
>  task_work_run+0x199/0x270 kernel/task_work.c:112
>  exit_task_work include/linux/task_work.h:21 [inline]
>  do_exit+0x9b5/0x1ad0 kernel/exit.c:865
>  do_group_exit+0x149/0x400 kernel/exit.c:968
>  get_signal+0x73f/0x16d0 kernel/signal.c:2334
>  do_signal+0x94/0x1ee0 arch/x86/kernel/signal.c:808
>  exit_to_usermode_loop+0x214/0x310 arch/x86/entry/common.c:158
>  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>  syscall_return_slowpath+0x42f/0x510 arch/x86/entry/common.c:266
>  entry_SYSCALL_64_fastpath+0xbc/0xbe
>
> The buggy address belongs to the object at ffff8801c9de8ac0
>  which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 24 bytes inside of
>  4096-byte region [ffff8801c9de8ac0, ffff8801c9de9ac0)
> The buggy address belongs to the page:
> page:ffffea0007277a00 count:1 mapcount:0 mapping:ffff8801c9de8ac0 index:0x0
> compound_mapcount: 0
> flags: 0x200000000008100(slab|head)
> raw: 0200000000008100 ffff8801c9de8ac0 0000000000000000 0000000100000001
> raw: ffffea000727c9a0 ffffea0007290d20 ffff8801dac00dc0 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801c9de8980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8801c9de8a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>
>> ffff8801c9de8a80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>
>                                                     ^
>  ffff8801c9de8b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801c9de8b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =================================
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> Please credit me with: Reported-by: syzbot <syzkaller@googlegroups.com>
>
> syzbot will keep track of this bug report.
> Once a fix for this bug is committed, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line.
