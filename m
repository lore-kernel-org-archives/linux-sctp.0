From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 May 2018 18:04:12 +0000
Subject: Re: INFO: rcu detected stall in kfree_skbmem
Message-Id: <CADvbK_crGBk-q_910r-xdh2p=xnxiV=1EExLSX-ecddFwMag6w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000a9b0e3056b14bfb2@google.com> <CACT4Y+Z_+=VLbELVW69B7WEVqvri1xBMM5RMnMQynec_XgaE=w@mail.gmail.com>
 <20180514133439.GA6743@hmswarspite.think-freely.org>
In-Reply-To: <20180514133439.GA6743@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+fc78715ba3b3257caf6a@syzkaller.appspotmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, Andrei Vagin <avagin@virtuozzo.com>, David Miller <davem@davemloft.net>, Kirill Tkhai <ktkhai@virtuozzo.com>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Mon, May 14, 2018 at 9:34 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, May 11, 2018 at 12:00:38PM +0200, Dmitry Vyukov wrote:
>> On Mon, Apr 30, 2018 at 8:09 PM, syzbot
>> <syzbot+fc78715ba3b3257caf6a@syzkaller.appspotmail.com> wrote:
>> > Hello,
>> >
>> > syzbot found the following crash on:
>> >
>> > HEAD commit:    5d1365940a68 Merge
>> > git://git.kernel.org/pub/scm/linux/kerne...
>> > git tree:       net-next
>> > console output: https://syzkaller.appspot.com/x/log.txt?idV67997129637=
888
>> > kernel config:
>> > https://syzkaller.appspot.com/x/.config?id=3D-5947642240294114534
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=FC78715ba3b325=
7caf6a
>> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> >
>> > Unfortunately, I don't have any reproducer for this crash yet.
>>
>> This looks sctp-related, +sctp maintainers.
>>
> Looking at the entire trace, it appears that we are getting caught in the
> kfree_skb that is getting triggered in enqueue_to_backlog which occurs wh=
en our
> rx backlog list grows over netdev_max_backlog packets.  That suggests to =
me that
It might be a long skb->frag_list that made kfree_skb slow when packing
lots of small chunks to go through lo device?

> whatever test(s) is/are causing this trace are queuing up a large number =
of
> frames to be sent over the loopback interface, and are never/rarely getti=
ng
> received.  Looking up higher in the stack, in the sctp_generate_heartbeat=
_event
> function, we (in addition to the rcu_read_lock in sctp_v6_xmit) we also h=
old the
> socket lock during the entirety of the xmit operaion.  Is it possible tha=
t we
> are just enqueuing so many frames for xmit that we are blocking progress =
of
> other threads using the same socket that we cross the RCU self detected s=
tall
> boundary?  While its not a fix per se, it might be a worthwhile test to l=
imit
> the number of frames we flush in a single pass.
>
> Neil
>
>> > IMPORTANT: if you fix the bug, please add the following tag to the com=
mit:
>> > Reported-by: syzbot+fc78715ba3b3257caf6a@syzkaller.appspotmail.com
>> >
>> > INFO: rcu_sched self-detected stall on CPU
>> >         1-...!: (1 GPs behind) idle=A3e/1/4611686018427387908
>> > softirqq980/71983 fqs3
>> >          (t=125000 jiffies g9438 c9437 q=958)
>> > rcu_sched kthread starved for 124829 jiffies! g39438 c39437 f0x0
>> > RCU_GP_WAIT_FQS(3) ->state=3D0x0 ->cpu=3D0
>> > RCU grace-period kthread stack dump:
>> > rcu_sched       R  running task    23768     9      2 0x80000000
>> > Call Trace:
>> >  context_switch kernel/sched/core.c:2848 [inline]
>> >  __schedule+0x801/0x1e30 kernel/sched/core.c:3490
>> >  schedule+0xef/0x430 kernel/sched/core.c:3549
>> >  schedule_timeout+0x138/0x240 kernel/time/timer.c:1801
>> >  rcu_gp_kthread+0x6b5/0x1940 kernel/rcu/tree.c:2231
>> >  kthread+0x345/0x410 kernel/kthread.c:238
>> >  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:411
>> > NMI backtrace for cpu 1
>> > CPU: 1 PID: 20560 Comm: syz-executor4 Not tainted 4.16.0+ #1
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> > Google 01/01/2011
>> > Call Trace:
>> >  <IRQ>
>> >  __dump_stack lib/dump_stack.c:77 [inline]
>> >  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>> >  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
>> >  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>> >  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.=
c:38
>> >  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
>> >  rcu_dump_cpu_stacks+0x175/0x1c2 kernel/rcu/tree.c:1376
>> >  print_cpu_stall kernel/rcu/tree.c:1525 [inline]
>> >  check_cpu_stall.isra.61.cold.80+0x36c/0x59a kernel/rcu/tree.c:1593
>> >  __rcu_pending kernel/rcu/tree.c:3356 [inline]
>> >  rcu_pending kernel/rcu/tree.c:3401 [inline]
>> >  rcu_check_callbacks+0x21b/0xad0 kernel/rcu/tree.c:2763
>> >  update_process_times+0x2d/0x70 kernel/time/timer.c:1636
>> >  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:173
>> >  tick_sched_timer+0x45/0x130 kernel/time/tick-sched.c:1283
>> >  __run_hrtimer kernel/time/hrtimer.c:1386 [inline]
>> >  __hrtimer_run_queues+0x3e3/0x10a0 kernel/time/hrtimer.c:1448
>> >  hrtimer_interrupt+0x286/0x650 kernel/time/hrtimer.c:1506
>> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
>> >  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
>> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:862
>> > RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783
>> > [inline]
>> > RIP: 0010:kmem_cache_free+0xb3/0x2d0 mm/slab.c:3757
>> > RSP: 0018:ffff8801db105228 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
>> > RAX: 0000000000000007 RBX: ffff8800b055c940 RCX: 1ffff1003b2345a5
>> > RDX: 0000000000000000 RSI: ffff8801d91a2d80 RDI: 0000000000000282
>> > RBP: ffff8801db105248 R08: ffff8801d91a2cb8 R09: 0000000000000002
>> > R10: ffff8801d91a2480 R11: 0000000000000000 R12: ffff8801d9848e40
>> > R13: 0000000000000282 R14: ffffffff85b7f27c R15: 0000000000000000
>> >  kfree_skbmem+0x13c/0x210 net/core/skbuff.c:582
>> >  __kfree_skb net/core/skbuff.c:642 [inline]
>> >  kfree_skb+0x19d/0x560 net/core/skbuff.c:659
>> >  enqueue_to_backlog+0x2fc/0xc90 net/core/dev.c:3968
>> >  netif_rx_internal+0x14d/0xae0 net/core/dev.c:4181
>> >  netif_rx+0xba/0x400 net/core/dev.c:4206
>> >  loopback_xmit+0x283/0x741 drivers/net/loopback.c:91
>> >  __netdev_start_xmit include/linux/netdevice.h:4087 [inline]
>> >  netdev_start_xmit include/linux/netdevice.h:4096 [inline]
>> >  xmit_one net/core/dev.c:3053 [inline]
>> >  dev_hard_start_xmit+0x264/0xc10 net/core/dev.c:3069
>> >  __dev_queue_xmit+0x2724/0x34c0 net/core/dev.c:3584
>> >  dev_queue_xmit+0x17/0x20 net/core/dev.c:3617
>> >  neigh_hh_output include/net/neighbour.h:472 [inline]
>> >  neigh_output include/net/neighbour.h:480 [inline]
>> >  ip6_finish_output2+0x134e/0x2810 net/ipv6/ip6_output.c:120
>> >  ip6_finish_output+0x5fe/0xbc0 net/ipv6/ip6_output.c:154
>> >  NF_HOOK_COND include/linux/netfilter.h:277 [inline]
>> >  ip6_output+0x227/0x9b0 net/ipv6/ip6_output.c:171
>> >  dst_output include/net/dst.h:444 [inline]
>> >  NF_HOOK include/linux/netfilter.h:288 [inline]
>> >  ip6_xmit+0xf51/0x23f0 net/ipv6/ip6_output.c:277
>> >  sctp_v6_xmit+0x4a5/0x6b0 net/sctp/ipv6.c:225
>> >  sctp_packet_transmit+0x26f6/0x3ba0 net/sctp/output.c:650
>> >  sctp_outq_flush+0x1373/0x4370 net/sctp/outqueue.c:1197
>> >  sctp_outq_uncork+0x6a/0x80 net/sctp/outqueue.c:776
>> >  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
>> >  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>> >  sctp_do_sm+0x596/0x7160 net/sctp/sm_sideeffect.c:1191
>> >  sctp_generate_heartbeat_event+0x218/0x450 net/sctp/sm_sideeffect.c:406
>> >  call_timer_fn+0x230/0x940 kernel/time/timer.c:1326
>> >  expire_timers kernel/time/timer.c:1363 [inline]
>> >  __run_timers+0x79e/0xc50 kernel/time/timer.c:1666
>> >  run_timer_softirq+0x4c/0x70 kernel/time/timer.c:1692
>> >  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:285
>> >  invoke_softirq kernel/softirq.c:365 [inline]
>> >  irq_exit+0x1d1/0x200 kernel/softirq.c:405
>> >  exiting_irq arch/x86/include/asm/apic.h:525 [inline]
>> >  smp_apic_timer_interrupt+0x17e/0x710 arch/x86/kernel/apic/apic.c:1052
>> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:862
>> >  </IRQ>
>> > RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783
>> > [inline]
>> > RIP: 0010:lock_release+0x4d4/0xa10 kernel/locking/lockdep.c:3942
>> > RSP: 0018:ffff8801971ce7b0 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
>> > RAX: dffffc0000000000 RBX: 1ffff10032e39cfb RCX: 1ffff1003b234595
>> > RDX: 1ffffffff11630ed RSI: 0000000000000002 RDI: 0000000000000282
>> > RBP: ffff8801971ce8e0 R08: 1ffff10032e39cff R09: ffffed003b6246c2
>> > R10: 0000000000000003 R11: 0000000000000001 R12: ffff8801d91a2480
>> > R13: ffffffff88b8df60 R14: ffff8801d91a2480 R15: ffff8801971ce7f8
>> >  rcu_lock_release include/linux/rcupdate.h:251 [inline]
>> >  rcu_read_unlock include/linux/rcupdate.h:688 [inline]
>> >  __unlock_page_memcg+0x72/0x100 mm/memcontrol.c:1654
>> >  unlock_page_memcg+0x2c/0x40 mm/memcontrol.c:1663
>> >  page_remove_file_rmap mm/rmap.c:1248 [inline]
>> >  page_remove_rmap+0x6f2/0x1250 mm/rmap.c:1299
>> >  zap_pte_range mm/memory.c:1337 [inline]
>> >  zap_pmd_range mm/memory.c:1441 [inline]
>> >  zap_pud_range mm/memory.c:1470 [inline]
>> >  zap_p4d_range mm/memory.c:1491 [inline]
>> >  unmap_page_range+0xeb4/0x2200 mm/memory.c:1512
>> >  unmap_single_vma+0x1a0/0x310 mm/memory.c:1557
>> >  unmap_vmas+0x120/0x1f0 mm/memory.c:1587
>> >  exit_mmap+0x265/0x570 mm/mmap.c:3038
>> >  __mmput kernel/fork.c:962 [inline]
>> >  mmput+0x251/0x610 kernel/fork.c:983
>> >  exit_mm kernel/exit.c:544 [inline]
>> >  do_exit+0xe98/0x2730 kernel/exit.c:852
>> >  do_group_exit+0x16f/0x430 kernel/exit.c:968
>> >  get_signal+0x886/0x1960 kernel/signal.c:2469
>> >  do_signal+0x98/0x2040 arch/x86/kernel/signal.c:810
>> >  exit_to_usermode_loop+0x28a/0x310 arch/x86/entry/common.c:162
>> >  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>> >  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>> >  do_syscall_64+0x792/0x9d0 arch/x86/entry/common.c:292
>> >  entry_SYSCALL_64_after_hwframe+0x42/0xb7
>> > RIP: 0033:0x455319
>> > RSP: 002b:00007fa346e81ce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
>> > RAX: fffffffffffffe00 RBX: 000000000072bf80 RCX: 0000000000455319
>> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000072bf80
>> > RBP: 000000000072bf80 R08: 0000000000000000 R09: 000000000072bf58
>> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> > R13: 0000000000a3e81f R14: 00007fa346e829c0 R15: 0000000000000001
>> >
>> >
>> > ---
>> > This bug is generated by a bot. It may contain errors.
>> > See https://goo.gl/tpsmEJ for more information about syzbot.
>> > syzbot engineers can be reached at syzkaller@googlegroups.com.
>> >
>> > syzbot will keep track of this bug report.
>> > If you forgot to add the Reported-by tag, once the fix for this bug is
>> > merged
>> > into any tree, please reply to this email with:
>> > #syz fix: exact-commit-title
>> > To mark this as a duplicate of another syzbot report, please reply wit=
h:
>> > #syz dup: exact-subject-of-another-report
>> > If it's a one-off invalid bug report, please reply with:
>> > #syz invalid
>> > Note: if the crash happens again, it will cause creation of a new bug
>> > report.
>> > Note: all commands must start from beginning of the line in the email =
body.
>> >
>> > --
>> > You received this message because you are subscribed to the Google Gro=
ups
>> > "syzkaller-bugs" group.
>> > To unsubscribe from this group and stop receiving emails from it, send=
 an
>> > email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> > To view this discussion on the web visit
>> > https://groups.google.com/d/msgid/syzkaller-bugs/000000000000a9b0e3056=
b14bfb2%40google.com.
>> > For more options, visit https://groups.google.com/d/optout.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
