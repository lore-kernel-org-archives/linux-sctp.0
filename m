From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 14 Aug 2018 01:24:21 +0000
Subject: Re: WARNING: refcount bug in sctp_transport_put
Message-Id: <20180814012419.GB26909@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000fb3b1605735aa815@google.com>
In-Reply-To: <000000000000fb3b1605735aa815@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+6a15c8ad0f0632ccd7f3@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Mon, Aug 13, 2018 at 05:55:02PM -0700, syzbot wrote:
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 7203 at lib/refcount.c:187
> refcount_sub_and_test+0x2e7/0x350 lib/refcount.c:187
> Kernel panic - not syncing: panic_on_warn set ...
> 
...
>  refcount_dec_and_test+0x1a/0x20 lib/refcount.c:212
>  sctp_transport_put+0x76/0x200 net/sctp/transport.c:331
>  sctp_generate_heartbeat_event+0x2d7/0x450 net/sctp/sm_sideeffect.c:416
>  call_timer_fn+0x242/0x970 kernel/time/timer.c:1326
>  expire_timers kernel/time/timer.c:1363 [inline]
>  __run_timers+0x7a6/0xc70 kernel/time/timer.c:1666
>  run_timer_softirq+0x4c/0x70 kernel/time/timer.c:1692
>  __do_softirq+0x2e8/0xb17 kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:372 [inline]
>  irq_exit+0x1d4/0x210 kernel/softirq.c:412
>  exiting_irq arch/x86/include/asm/apic.h:527 [inline]
>  smp_apic_timer_interrupt+0x186/0x730 arch/x86/kernel/apic/apic.c:1055
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
>  </IRQ>

Interesting, again on heartbeat timer handler.

  Marcelo
