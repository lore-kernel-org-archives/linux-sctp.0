From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 08:45:58 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <CADvbK_c5Z7rE-AABGOFKXYA5v7_XLg=V1HOGzBO1X-O13aJ8Gg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com> <001a1140f5788a1817055fcfcb1f@google.com>
In-Reply-To: <001a1140f5788a1817055fcfcb1f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, yoshfuji <yoshfuji@linux-ipv6.org>

On Fri, Dec 8, 2017 at 4:16 PM, syzbot
<bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
wrote:
> syzkaller has found reproducer for the following crash on
> 82bcf1def3b5f1251177ad47c44f7e17af039b4b
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
>
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
>
>
> skbuff: skb_over_panic: text:0000000010b86b8d len:196 put:20
> head:000000003b477e60 data:000000000e85441e tail:0xd4 end:0xc0 dev:lo
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:104!
> invalid opcode: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.15.0-rc2-mm1+ #39
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:skb_panic+0x15c/0x1f0 net/core/skbuff.c:100
> RSP: 0018:ffff8801db307508 EFLAGS: 00010286
> RAX: 0000000000000082 RBX: ffff8801c517e840 RCX: 0000000000000000
> RDX: 0000000000000082 RSI: 1ffff1003b660e61 RDI: ffffed003b660e95
> RBP: ffff8801db307570 R08: 1ffff1003b660e23 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff85bd4020
> R13: ffffffff84754ed2 R14: 0000000000000014 R15: ffff8801c4e26540
> FS:  0000000000000000(0000) GS:ffff8801db300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000463610 CR3: 00000001c6698000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  skb_over_panic net/core/skbuff.c:109 [inline]
>  skb_put+0x181/0x1c0 net/core/skbuff.c:1694
>  add_grhead.isra.24+0x42/0x3b0 net/ipv6/mcast.c:1695
>  add_grec+0xa55/0x1060 net/ipv6/mcast.c:1817
>  mld_send_cr net/ipv6/mcast.c:1903 [inline]
>  mld_ifc_timer_expire+0x4d2/0x770 net/ipv6/mcast.c:2448
>  call_timer_fn+0x23b/0x840 kernel/time/timer.c:1320
>  expire_timers kernel/time/timer.c:1357 [inline]
>  __run_timers+0x7e1/0xb60 kernel/time/timer.c:1660
>  run_timer_softirq+0x4c/0xb0 kernel/time/timer.c:1686
>  __do_softirq+0x29d/0xbb2 kernel/softirq.c:285
>  invoke_softirq kernel/softirq.c:365 [inline]
>  irq_exit+0x1d3/0x210 kernel/softirq.c:405
>  exiting_irq arch/x86/include/asm/apic.h:540 [inline]
>  smp_apic_timer_interrupt+0x16b/0x700 arch/x86/kernel/apic/apic.c:1052
>  apic_timer_interrupt+0xa9/0xb0 arch/x86/entry/entry_64.S:920
>  </IRQ>
> RIP: 0010:native_safe_halt+0x6/0x10 arch/x86/include/asm/irqflags.h:54
> RSP: 0018:ffff8801d9f97da8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff11
> RAX: dffffc0000000000 RBX: 1ffff1003b3f2fb8 RCX: 0000000000000000
> RDX: 1ffffffff0c59734 RSI: 0000000000000001 RDI: ffffffff862cb9a0
> RBP: ffff8801d9f97da8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff8801d9f97e60 R14: ffffffff869eb920 R15: 0000000000000000
>  arch_safe_halt arch/x86/include/asm/paravirt.h:93 [inline]
>  default_idle+0xbf/0x430 arch/x86/kernel/process.c:355
>  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:346
>  default_idle_call+0x36/0x90 kernel/sched/idle.c:98
>  cpuidle_idle_call kernel/sched/idle.c:156 [inline]
>  do_idle+0x24a/0x3b0 kernel/sched/idle.c:246
>  cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:351
>  start_secondary+0x330/0x460 arch/x86/kernel/smpboot.c:277
>  secondary_startup_64+0xa5/0xb0 arch/x86/kernel/head_64.S:237
> Code: 03 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 78 41 57 48 c7 c7 a0 38
> bd 85 52 56 4c 89 ea 41 50 4c 89 e6 45 89 f0 e8 0c b6 3d fd <0f> 0b 4c 89 4d
> b8 4c 89 45 c0 48 89 75 c8 48 89 55 d0 e8 7d 93
> RIP: skb_panic+0x15c/0x1f0 net/core/skbuff.c:100 RSP: ffff8801db307508
> ---[ end trace 941a8a0f633e271f ]---
>
This isn't a sctp problem, but mld's, seems when lo's mtu became 0,
it allocs a skb without enough space in add_grec():
              if (AVAILABLE(skb) < sizeof(*psrc) +
                    first*sizeof(struct mld2_grec)) {
                        if (truncate && !first)
                                break;   /* truncate these */
                        if (pgr)
                                pgr->grec_nsrcs = htons(scount);
                        if (skb)
                                mld_sendpack(skb);
                        skb = mld_newpack(idev, dev->mtu); <---

I will check this for sure later on both igmp and mld.
