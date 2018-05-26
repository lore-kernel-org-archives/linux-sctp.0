From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 26 May 2018 15:32:47 +0000
Subject: Re: INFO: rcu detected stall in ip_route_output_key_hash
Message-Id: <CACT4Y+ZMdJoT1iRC4aq2e3a0Ta5rc2_KtNV93JrWfduNfLeR5Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000e2e064056c5460e3@google.com>
In-Reply-To: <000000000000e2e064056c5460e3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+769a7ccbbb4b5074f125@syzkaller.appspotmail.com>
Cc: David Miller <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-sctp@vger.kernel.org

On Wed, May 16, 2018 at 5:29 PM, syzbot
<syzbot+769a7ccbbb4b5074f125@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    0b7d9978406f Merge branch 'Microsemi-Ocelot-Ethernet-swit=
c..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1138c477800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=B632d8e2c2ab2c1
> dashboard link: https://syzkaller.appspot.com/bug?extidv9a7ccbbb4b5074f125
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+769a7ccbbb4b5074f125@syzkaller.appspotmail.com
>
> netlink: 4 bytes leftover after parsing attributes in process
> `syz-executor2'.
> random: crng init done
> INFO: rcu_sched self-detected stall on CPU
>         1-...!: (121515 ticks this GP) idle=E7e/1/4611686018427387908
> softirq1362/31362 fqs=3D7
>          (t=125000 jiffies g=16439 c=16438 qf8508)
> rcu_sched kthread starved for 124958 jiffies! g16439 c16438 f0x2
> RCU_GP_WAIT_FQS(3) ->state=3D0x0 ->cpu=3D0
> RCU grace-period kthread stack dump:
> rcu_sched       R  running task    23768     9      2 0x80000000
> Call Trace:
>  context_switch kernel/sched/core.c:2848 [inline]
>  __schedule+0x801/0x1e30 kernel/sched/core.c:3490
>  schedule+0xef/0x430 kernel/sched/core.c:3549
>  schedule_timeout+0x138/0x240 kernel/time/timer.c:1801
>  rcu_gp_kthread+0x6b5/0x1940 kernel/rcu/tree.c:2231
>  kthread+0x345/0x410 kernel/kthread.c:238
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
> NMI backtrace for cpu 1
> CPU: 1 PID: 4488 Comm: syz-fuzzer Not tainted 4.17.0-rc4+ #45
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
>  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
>  rcu_dump_cpu_stacks+0x175/0x1c2 kernel/rcu/tree.c:1376
>  print_cpu_stall kernel/rcu/tree.c:1525 [inline]
>  check_cpu_stall.isra.61.cold.80+0x36c/0x59a kernel/rcu/tree.c:1593
>  __rcu_pending kernel/rcu/tree.c:3356 [inline]
>  rcu_pending kernel/rcu/tree.c:3401 [inline]
>  rcu_check_callbacks+0x21b/0xad0 kernel/rcu/tree.c:2763
>  update_process_times+0x2d/0x70 kernel/time/timer.c:1636
>  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:164
>  tick_sched_timer+0x45/0x130 kernel/time/tick-sched.c:1274
>  __run_hrtimer kernel/time/hrtimer.c:1398 [inline]
>  __hrtimer_run_queues+0x3e3/0x10a0 kernel/time/hrtimer.c:1460
>  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
>  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
> RIP: 0010:rcu_is_watching+0x6/0x140 kernel/rcu/tree.c:1071
> RSP: 0000:ffff8801daf06620 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: ffff8801ad526240 RBX: 0000000000000000 RCX: ffffffff86444456
> RDX: 0000000000000100 RSI: ffffffff864444b8 RDI: 0000000000000001
> RBP: ffff8801daf06628 R08: ffff8801ad526240 R09: 0000000000000002
> R10: ffff8801ad526240 R11: 0000000000000000 R12: 1ffff1003b5e0cca
> R13: ffff88008ff1a100 R14: 0000000000000000 R15: ffff8801daf066d0
>  rcu_read_unlock include/linux/rcupdate.h:684 [inline]
>  ip_route_output_key_hash+0x2cd/0x390 net/ipv4/route.c:2303
>  __ip_route_output_key include/net/route.h:124 [inline]
>  ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2557
>  ip_route_output_key include/net/route.h:134 [inline]
>  sctp_v4_get_dst+0x50e/0x17a0 net/sctp/protocol.c:447
>  sctp_transport_route+0x132/0x360 net/sctp/transport.c:303
>  sctp_packet_config+0x926/0xdd0 net/sctp/output.c:118
>  sctp_outq_select_transport+0x2bb/0x9c0 net/sctp/outqueue.c:877
>  sctp_outq_flush_ctrl.constprop.12+0x2ad/0xe60 net/sctp/outqueue.c:911
>  sctp_outq_flush+0x2ef/0x3430 net/sctp/outqueue.c:1203
>  sctp_outq_uncork+0x6a/0x80 net/sctp/outqueue.c:776
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>  sctp_do_sm+0x596/0x7160 net/sctp/sm_sideeffect.c:1191
>  sctp_generate_heartbeat_event+0x218/0x450 net/sctp/sm_sideeffect.c:406

#syz fix: sctp: not allow to set rto_min with a value below 200 msecs

>  call_timer_fn+0x230/0x940 kernel/time/timer.c:1326
>  expire_timers kernel/time/timer.c:1363 [inline]
>  __run_timers+0x79e/0xc50 kernel/time/timer.c:1666
>  run_timer_softirq+0x4c/0x70 kernel/time/timer.c:1692
>  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:285
>  invoke_softirq kernel/softirq.c:365 [inline]
>  irq_exit+0x1d1/0x200 kernel/softirq.c:405
>  exiting_irq arch/x86/include/asm/apic.h:525 [inline]
>  smp_apic_timer_interrupt+0x17e/0x710 arch/x86/kernel/apic/apic.c:1052
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
>  </IRQ>
> RIP: 0033:0x40b55d
> RSP: 002b:000000c424bedca8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> RAX: 000000c4244e5470 RBX: 000000004d36768c RCX: 0000000000000000
> RDX: 000000c4244e5470 RSI: 000000000000ffff RDI: 0000000000000000
> RBP: 000000c424bedcc0 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000009466f2 R11: 0000000000000004 R12: 0000000000000000
> R13: 0000000000000020 R14: 0000000000000013 R15: 0000000000000034
> BUG: workqueue lockup - pool cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 stuck=
 for 125s!
> BUG: workqueue lockup - pool cpus=3D0-1 flags=3D0x4 nice=3D0 stuck for 12=
5s!
> Showing busy workqueues and worker pools:
> workqueue events: flags=3D0x0
>   pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3/256
>     in-flight: 2104:do_numa_crng_init
>     pending: drbg_async_seed, cache_reap
>   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D9/256
>     pending: defense_work_handler, defense_work_handler,
> defense_work_handler, defense_work_handler, defense_work_handler,
> defense_work_handler, check_corruption, vmstat_shepherd, cache_reap
> workqueue events_power_efficient: flags=3D0x80
>   pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1/256
>     pending: do_cache_clean
>   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2/256
>     pending: check_lifetime, gc_worker
> workqueue writeback: flags=3D0x4e
>   pwq 4: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1/256
>     in-flight: 6:wb_workfn
> workqueue ipv6_addrconf: flags=3D0x40008
>   pwq 0: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1/1
>     pending: addrconf_verify_work
> workqueue krdsd: flags=3D0xe000a
>   pwq 4: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1/1
>     in-flight: 43:rds_connect_worker
> pool 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 hung=3D0s workers=3D4 idle=
: 24 1980 18
> pool 4: cpus=3D0-1 flags=3D0x4 nice=3D0 hung=3D0s workers=3D7 idle: 22 80=
18 287 6751
> 89
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
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e2e064056c54=
60e3%40google.com.
> For more options, visit https://groups.google.com/d/optout.
