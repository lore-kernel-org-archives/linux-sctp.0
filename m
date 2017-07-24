From: Alexander Potapenko <glider@google.com>
Date: Mon, 24 Jul 2017 16:27:58 +0000
Subject: Re: [PATCH] sctp: fully initialize the IPv6 address in sctp_v6_to_addr()
Message-Id: <CAG_fn=Xg-No_CbMYoqiW8_2LOzUjs2oyXGkczyNPr0QWFxg_5Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170718145557.89616-1-glider@google.com> <CAG_fn=WPJb7k+nErwyvwvY54etVvvGmrDDnpvGqVkDMv5foJmA@mail.gmail.com>
 <CADvbK_fD5H_FmCQX=p5eyN2261BerqR7=1_-LqdehS8o_M9Agg@mail.gmail.com>
In-Reply-To: <CADvbK_fD5H_FmCQX=p5eyN2261BerqR7=1_-LqdehS8o_M9Agg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Vladislav Yasevich <vyasevich@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org

On Wed, Jul 19, 2017 at 2:58 AM, Xin Long <lucien.xin@gmail.com> wrote:
> On Wed, Jul 19, 2017 at 3:02 AM, Alexander Potapenko <glider@google.com> wrote:
>> On Tue, Jul 18, 2017 at 4:55 PM, Alexander Potapenko <glider@google.com> wrote:
>>> KMSAN reported use of uninitialized sctp_addr->v4.sin_addr.s_addr and
>>> sctp_addr->v6.sin6_scope_id in sctp_v6_cmp_addr() (see below).
>>> Make sure all fields of an IPv6 address are initialized, which
>>> guarantees that the IPv4 fields are also initialized.
>> I'm assuming here that the IPv4 address is known to overlap with the
>> IPv6 one and doesn't need separate initialization.
>>
>
> Ok, addr->v6.sin6_scope_id = 0 will fix the call trace you posted here.
Sorry for the delay, I somehow missed your question.
> addr->v6.sin6_flowinfo = 0 is to fix uninitialized
> sctp_addr->v4.sin_addr.s_addr,
> I couldn't see how this happens, can you also post the call trace for
> v4.sin_addr.s_addr ?
Here it is:

==================================================================
BUG: KMSAN: use of uninitialized memory in
sctp_v6_cmp_addr+0x8d4/0x9f0 net/sctp/ipv6.c:535
CPU: 2 PID: 17306 Comm: syz-executor1 Not tainted 4.11.0-rc5+ #2944
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0x172/0x1c0 lib/dump_stack.c:42
 is_logbuf_locked mm/kmsan/kmsan.c:59 [inline]
 kmsan_report+0x12a/0x180 mm/kmsan/kmsan.c:938
 native_save_fl arch/x86/include/asm/irqflags.h:18 [inline]
 arch_local_save_flags arch/x86/include/asm/irqflags.h:72 [inline]
 arch_local_irq_save arch/x86/include/asm/irqflags.h:113 [inline]
 __msan_warning_32+0x61/0xb0 mm/kmsan/kmsan_instr.c:467
 sctp_v6_cmp_addr+0x8d4/0x9f0 net/sctp/ipv6.c:535
 sctp_v6_get_dst+0x8c7/0x1630 net/sctp/ipv6.c:297
 sctp_transport_route+0x101/0x570 net/sctp/transport.c:292
 sctp_assoc_add_peer+0x66d/0x16f0 net/sctp/associola.c:651
 sctp_sendmsg+0x35a5/0x4f90 net/sctp/socket.c:1871
 inet_sendmsg+0x498/0x670 net/ipv4/af_inet.c:762
 sock_sendmsg_nosec net/socket.c:633 [inline]
 sock_sendmsg net/socket.c:643 [inline]
 SYSC_sendto+0x608/0x710 net/socket.c:1696
 SyS_sendto+0x8a/0xb0 net/socket.c:1664
 entry_SYSCALL_64_fastpath+0x13/0x94
RIP: 0033:0x44b479
RSP: 002b:00007f28a5bb2c08 EFLAGS: 00000286 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 000000000044b479
RDX: 0000000000000001 RSI: 0000000020036000 RDI: 0000000000000005
RBP: 0000000000708000 R08: 00000000206e4000 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000286 R12: 00000000ffffffff
R13: 0000000000003760 R14: 00000000006e5820 R15: 0000000000ff9000
origin description: ----dst_saddr@sctp_v6_get_dst
local variable created at:
 sctp_v6_get_dst+0x91/0x1630 net/sctp/ipv6.c:236
 sctp_transport_route+0x101/0x570 net/sctp/transport.c:292
==================================================================


> Thanks



-- 
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Straße, 33
80636 München

Geschäftsführer: Matthew Scott Sucherman, Paul Terence Manicle
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
