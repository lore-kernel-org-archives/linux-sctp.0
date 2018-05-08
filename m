From: syzbot <syzbot+e4a5bbd54260c93014f9@syzkaller.appspotmail.com>
Date: Tue, 08 May 2018 07:35:02 +0000
Subject: INFO: rcu detected stall in sctp_generate_heartbeat_event
Message-Id: <000000000000062c1c056bacd39f@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    90278871d4b0 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=119a7237800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=AEa320d3af5ef99d
dashboard link: https://syzkaller.appspot.com/bug?extid=E4a5bbd54260c93014f9
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e4a5bbd54260c93014f9@syzkaller.appspotmail.com

device bridge0 left promiscuous mode
IPVS: set_ctl: invalid protocol: 56 0.0.0.0:20003 fo
IPVS: set_ctl: invalid protocol: 175 224.0.0.2:20003 dh
INFO: rcu_sched self-detected stall on CPU
	0-...!: (119824 ticks this GP) idleK6/1/4611686018427387908 =20
softirq#864/23864 fqs=3D5
	 (t=125000 jiffies g=13072 c=13071 qH0954)
NMI backtrace for cpu 0
CPU: 0 PID: 4547 Comm: udevd Not tainted 4.17.0-rc3+ #34
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =20
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
  rcu_dump_cpu_stacks+0x175/0x1c2 kernel/rcu/tree.c:1376
  print_cpu_stall kernel/rcu/tree.c:1525 [inline]
  check_cpu_stall.isra.61.cold.80+0x36c/0x59a kernel/rcu/tree.c:1593
  __rcu_pending kernel/rcu/tree.c:3356 [inline]
  rcu_pending kernel/rcu/tree.c:3401 [inline]
  rcu_check_callbacks+0x21b/0xad0 kernel/rcu/tree.c:2763
  update_process_times+0x2d/0x70 kernel/time/timer.c:1636
  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:164
  tick_sched_timer+0x45/0x130 kernel/time/tick-sched.c:1274
  __run_hrtimer kernel/time/hrtimer.c:1398 [inline]
  __hrtimer_run_queues+0x3e3/0x10a0 kernel/time/hrtimer.c:1460
  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
RIP: 0010:rep_nop arch/x86/include/asm/processor.h:667 [inline]
RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:672 [inline]
RIP: 0010:virt_spin_lock arch/x86/include/asm/qspinlock.h:69 [inline]
RIP: 0010:native_queued_spin_lock_slowpath+0x204/0xde0 =20
kernel/locking/qspinlock.c:305
RSP: 0018:ffff8801dae07390 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffffed003b5c0e8b RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8801a9e9d088
RBP: ffff8801dae07700 R08: ffffed00353d3a12 R09: ffffed00353d3a11
R10: ffffed00353d3a11 R11: ffff8801a9e9d08b R12: ffff8801a9e9d088
R13: ffff8801dae076d8 R14: 0000000000000001 R15: dffffc0000000000
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:674 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:30 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:90 [inline]
  do_raw_spin_lock+0x1a7/0x200 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x32/0x40 kernel/locking/spinlock.c:144
  spin_lock include/linux/spinlock.h:310 [inline]
  sctp_generate_heartbeat_event+0xa4/0x450 net/sctp/sm_sideeffect.c:386
  call_timer_fn+0x230/0x940 kernel/time/timer.c:1326
  expire_timers kernel/time/timer.c:1363 [inline]
  __run_timers+0x79e/0xc50 kernel/time/timer.c:1666
  run_timer_softirq+0x4c/0x70 kernel/time/timer.c:1692
  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:285
  invoke_softirq kernel/softirq.c:365 [inline]
  irq_exit+0x1d1/0x200 kernel/softirq.c:405
  exiting_irq arch/x86/include/asm/apic.h:525 [inline]
  smp_apic_timer_interrupt+0x17e/0x710 arch/x86/kernel/apic/apic.c:1052
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
  </IRQ>
RIP: 0010:rcu_is_watching+0x41/0x140 kernel/rcu/tree.c:1071
RSP: 0018:ffff8801ad457848 EFLAGS: 00000296 ORIG_RAX: ffffffffffffff13
RAX: ffffed0035a8af0a RBX: 1ffff10035a8af0a RCX: ffff8801ad4578f0
RDX: 0000000000000000 RSI: ffff8801ad457f58 RDI: ffffffff897bf004
RBP: ffff8801ad4578d8 R08: ffff8801ad457978 R09: ffff8801ad53e040
R10: ffffed0035a8af32 R11: ffff8801ad457997 R12: ffff8801ad457988
R13: 0000000000000000 R14: ffff8801ad4578b0 R15: dffffc0000000000
syz-executor3 (7657) used greatest stack depth: 15968 bytes left
  kernel_text_address+0x61/0xf0 kernel/extable.c:140
  __kernel_text_address+0xd/0x40 kernel/extable.c:107
  unwind_get_return_address+0x61/0xa0 arch/x86/kernel/unwind_frame.c:18
  __save_stack_trace+0x7e/0xd0 arch/x86/kernel/stacktrace.c:45
  save_stack_trace+0x1a/0x20 arch/x86/kernel/stacktrace.c:60
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
  getname_flags+0xd0/0x5a0 fs/namei.c:140
  getname+0x19/0x20 fs/namei.c:211
  do_sys_open+0x39a/0x740 fs/open.c:1087
  __do_sys_open fs/open.c:1111 [inline]
  __se_sys_open fs/open.c:1106 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1106
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f7621c19120
RSP: 002b:00007fff6a9646f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7621c19120
RDX: 0000000000000124 RSI: 0000000000080000 RDI: 00007fff6a9647a0
RBP: 0000000000ddd744 R08: 0000000000ddd744 R09: 00007f7621c6ec20
R10: 7269762f73656369 R11: 0000000000000246 R12: 0000000000dc3810
R13: 0000000000dc3900 R14: 0000000000dc3250 R15: 0000000000dc8e10
device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
device bridge_slave_1 left promiscuous mode
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
IPVS: ftp: loaded support on port[0] =3D 21
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): Releasing backup interface bond_slave_1
bond0 (unregistering): Releasing backup interface bond_slave_0
bond0 (unregistering): Released all slaves
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): Releasing backup interface bond_slave_1
bond0 (unregistering): Releasing backup interface bond_slave_0
bond0 (unregistering): Released all slaves
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): Releasing backup interface bond_slave_1
bond0 (unregistering): Releasing backup interface bond_slave_0
bond0 (unregistering): Released all slaves
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): Releasing backup interface bond_slave_1
bond0 (unregistering): Releasing backup interface bond_slave_0
bond0 (unregistering): Released all slaves
bridge0: port 1(bridge_slave_0) entered blocking state
bridge0: port 1(bridge_slave_0) entered disabled state
device bridge_slave_0 entered promiscuous mode
bridge0: port 2(bridge_slave_1) entered blocking state
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_1 entered promiscuous mode
IPv6: ADDRCONF(NETDEV_UP): veth0_to_bridge: link is not ready
IPv6: ADDRCONF(NETDEV_UP): veth1_to_bridge: link is not ready
bond0: Enslaving bond_slave_0 as an active interface with an up link
bond0: Enslaving bond_slave_1 as an active interface with an up link
IPv6: ADDRCONF(NETDEV_UP): veth1_to_bond: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_bond: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): team_slave_0: link is not ready
team0: Port device team_slave_0 added
IPv6: ADDRCONF(NETDEV_UP): team_slave_1: link is not ready
team0: Port device team_slave_1 added
IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_1: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): bridge_slave_0: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_bridge: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): bridge_slave_1: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_1: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_bridge: link becomes ready
bridge0: port 2(bridge_slave_1) entered blocking state
bridge0: port 2(bridge_slave_1) entered forwarding state
bridge0: port 1(bridge_slave_0) entered blocking state
bridge0: port 1(bridge_slave_0) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): bridge0: link is not ready
IPv6: ADDRCONF(NETDEV_CHANGE): bridge0: link becomes ready


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is =20
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug =20
report.
Note: all commands must start from beginning of the line in the email body.
