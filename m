From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 16 May 2018 12:12:29 +0000
Subject: Re: INFO: rcu detected stall in sctp_packet_transmit
Message-Id: <CACT4Y+aG0CdZOe8+Y5+OWsghV2o36UpgAXFE4cCm-Mmv6Cq0oA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000008149ec056c4e4289@google.com> <CADvbK_dj5nLyzZGUmqfiZuoEwDjNxTy_e-VXsEGrWYoGP4m6PA@mail.gmail.com>
 <CACT4Y+YD7KebCZujCW90iSNxPn5GJ2pg=1f7nARA9tphrY_1JQ@mail.gmail.com> <CADvbK_ffAG5GC-UBX+615P9nz43aBHsy3s0rH3NYs+FhHEwT9w@mail.gmail.com>
In-Reply-To: <CADvbK_ffAG5GC-UBX+615P9nz43aBHsy3s0rH3NYs+FhHEwT9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+ff0b569fb5111dcd1a36@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, May 16, 2018 at 1:02 PM, Xin Long <lucien.xin@gmail.com> wrote:
>>> <syzbot+ff0b569fb5111dcd1a36@syzkaller.appspotmail.com> wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    961423f9fcbc Merge branch 'sctp-Introduce-sctp_flush_c=
tx'
>>>> git tree:       net-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1366aea78000=
00
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?xQfb0a6913f757=
db
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=FF0b569fb5111d=
cd1a36
>>>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>>>
>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the com=
mit:
>>>> Reported-by: syzbot+ff0b569fb5111dcd1a36@syzkaller.appspotmail.com
>>>>
>>>> INFO: rcu_sched self-detected stall on CPU
>>>>         0-....: (1 GPs behind) idle=DAe/1/4611686018427387908
>>>> softirq=93090/93091 fqs0902
>>>>          (t=125000 jiffies gQ107 cQ106 q=972)
>>>> NMI backtrace for cpu 0
>>>> CPU: 0 PID: 24668 Comm: syz-executor6 Not tainted 4.17.0-rc4+ #44
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>>>> Google 01/01/2011
>>>> Call Trace:
>>>>  <IRQ>
>>>>  __dump_stack lib/dump_stack.c:77 [inline]
>>>>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>>>>  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
>>>>  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>>>>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.=
c:38
>>>>  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
>>>>  rcu_dump_cpu_stacks+0x175/0x1c2 kernel/rcu/tree.c:1376
>>>>  print_cpu_stall kernel/rcu/tree.c:1525 [inline]
>>>>  check_cpu_stall.isra.61.cold.80+0x36c/0x59a kernel/rcu/tree.c:1593
>>>>  __rcu_pending kernel/rcu/tree.c:3356 [inline]
>>>>  rcu_pending kernel/rcu/tree.c:3401 [inline]
>>>>  rcu_check_callbacks+0x21b/0xad0 kernel/rcu/tree.c:2763
>>>>  update_process_times+0x2d/0x70 kernel/time/timer.c:1636
>>>>  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:164
>>>>  tick_sched_timer+0x45/0x130 kernel/time/tick-sched.c:1274
>>>>  __run_hrtimer kernel/time/hrtimer.c:1398 [inline]
>>>>  __hrtimer_run_queues+0x3e3/0x10a0 kernel/time/hrtimer.c:1460
>>>>  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
>>>>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
>>>>  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
>>>>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
>>>> RIP: 0010:sctp_v6_xmit+0x259/0x6b0 net/sctp/ipv6.c:219
>>>> RSP: 0018:ffff8801dae068e8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
>>>> RAX: 0000000000000007 RBX: ffff8801bb7ec800 RCX: ffffffff86f1b345
>>>> RDX: 0000000000000000 RSI: ffffffff86f1b381 RDI: ffff8801b73d97c4
>>>> RBP: ffff8801dae06988 R08: ffff88019505c300 R09: ffffed003b5c46c2
>>>> R10: ffffed003b5c46c2 R11: ffff8801dae23613 R12: ffff88011fd57300
>>>> R13: ffff8801bb7ecec8 R14: 0000000000000029 R15: 0000000000000002
>>>>  sctp_packet_transmit+0x26f6/0x3ba0 net/sctp/output.c:642
>>>>  sctp_outq_flush_transports net/sctp/outqueue.c:1164 [inline]
>>>>  sctp_outq_flush+0x5f5/0x3430 net/sctp/outqueue.c:1212
>>>>  sctp_outq_uncork+0x6a/0x80 net/sctp/outqueue.c:776
>>>>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1820 [inline]
>>>>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>>>>  sctp_do_sm+0x596/0x7160 net/sctp/sm_sideeffect.c:1191
>>>>  sctp_generate_heartbeat_event+0x218/0x450 net/sctp/sm_sideeffect.c:406
>>> Shocks, this timer event again. Can we try to minimize the repo.syz and
>>> get a short script, not neccessary to reproduce the issue 100%. we need
>>> to know what it was doing when this happened.
>>>
>>> Thanks.
>>
>> It's possible to reply the whole log from console output following
>> these instructions:
>> https://github.com/google/syzkaller/blob/master/docs/executing_syzkaller=
_programs.md
> Thanks, it's running now.
> Usually how long will it take to finish running this 5000-line log?

If you run with -repeat=3D0 then it will run infinitely repeating the
log again and again. If you see:

parsed 1000 programs
...
executed 5000 programs

then it looped 5 times already. You can run with -repeat=10.

syzbot has tried replaying the log, but for some reason it wasn't able
to reproduce the crash (maybe accumulated state, or maybe it crashed
in a different way). You can also try logs from other sctp hangs.
