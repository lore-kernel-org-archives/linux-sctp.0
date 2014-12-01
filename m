From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Date: Mon, 01 Dec 2014 18:02:14 +0000
Subject: Re: panic in skb_push via sctp
Message-Id: <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com>
	<547CA719.6060101@redhat.com>
In-Reply-To: <547CA719.6060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com

Thanks for looking into it. I can try with your patch, but no
guarantees that the fuzzer will hit the same condition in some
reasonable time-frame. Will get back in some time with results.

PS. If you think it's possible to create a repro (userland code) which
can trigger this, I can give it a try.

2014-12-01 18:36 GMT+01:00 Daniel Borkmann <dborkman@redhat.com>:
> On 12/01/2014 05:49 PM, Robert Święcki wrote:
>>
>> I don't have much more, cause my kernel is kASLRNized and gdb cannot
>> handle that, but pasting output from kdb. Maybe somebody will be able
>> to see something obvious.
>>
>>   <0>[93699.703244] skbuff: skb_under_panic: text:ffffffff83cff03e
>> len:104 put:56 head:ffff8803bd804ec0 data:ffff8803bd804ebc tail:0x64
>> end:0xc0 dev:<NULL>
>
>
> Thanks for the report!
>
> On a first view, it looks like we should be using MAX_HEADER instead
> of LL_MAX_HEADER here, could you try with the following patch:
>
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 42dffd4..fc5e45b 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -401,12 +401,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>         sk = chunk->skb->sk;
>
>         /* Allocate the new skb.  */
> -       nskb = alloc_skb(packet->size + LL_MAX_HEADER, GFP_ATOMIC);
> +       nskb = alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
>         if (!nskb)
>                 goto nomem;
>
>         /* Make sure the outbound skb has enough header room reserved. */
> -       skb_reserve(nskb, packet->overhead + LL_MAX_HEADER);
> +       skb_reserve(nskb, packet->overhead + MAX_HEADER);
>
>         /* Set the owning socket so that we know where to get the
>          * destination IP address.
>
>
>
>> [9]kdb> bt
>> Stack traceback for pid 14150
>> 0xffff88039c81ebf0    14150    15338  1    9   R  0xffff88039c81f0f0
>> *trinity-c9
>>   ffff8805318ab4b8 0000000000000018 ffffffff83abddc4 ffff8803bd804ebc
>>   0000000000000064 00000000000000c0 ffffffff84bc674d ffff8805318ab508
>>   ffff8805318ab518 00000000ffffffff 0000000000000000 ffff8805318ab558
>> Call Trace:
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83cff03e>] ? ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac4551>] ? skb_push+0xc1/0x100
>>   [<ffffffff83cff03e>] ? ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac8410>] ? __skb_checksum+0x110/0x730
>>   [<ffffffff81604c92>] ? kmem_cache_free+0x1d2/0x210
>>   [<ffffffff8437cf91>] ? sctp_v4_xmit+0x101/0x1a0
>>   [<ffffffff843d5ba2>] ? sctp_packet_transmit+0xf32/0x2050
>>   [<ffffffff8438fb8c>] ? sctp_chunkify+0x4c/0x2a0
>>   [<ffffffff81622c64>] ? kasan_poison_shadow+0x34/0x40
>>   [<ffffffff843d2a50>] ? sctp_csum_combine+0x20/0x20
>>   [<ffffffff843d2a30>] ? sctp_packet_release_owner+0x50/0x50
>>   [<ffffffff843a6dde>] ? sctp_outq_flush+0x6ee/0x2fa0
>>   [<ffffffff81326b7f>] ? preempt_count_add+0x16f/0x1b0
>>   [<ffffffff843ad8dd>] ? sctp_outq_uncork+0x6d/0x90
>>   [<ffffffff84378765>] ? sctp_do_sm+0x2c25/0x4a40
>>   [<ffffffff83ce2630>] ? __ip_route_output_key+0xa50/0x2830
>>   [<ffffffff83e99011>] ? xfrm_lookup_route+0x21/0x100
>>   [<ffffffff83ce5369>] ? ip_route_output_flow+0x69/0x90
>>   [<ffffffff82305052>] ? extract_entropy+0xa2/0x230
>>   [<ffffffff8437d7ff>] ? sctp_v4_get_dst+0x65f/0x1040
>>   [<ffffffff843d2584>] ? sctp_primitive_ASSOCIATE+0x84/0xd0
>>   [<ffffffff843c4ad6>] ? sctp_sendmsg+0x15b6/0x29b0
>>   [<ffffffff81530000>] ? toggle_bp_slot.constprop.11+0x1d0/0x530
>>   [<ffffffff81544636>] ? generic_perform_write+0x266/0x450
>>   [<ffffffff83dda011>] ? inet_sendmsg+0x231/0x360
>>   [<ffffffff83aa9e94>] ? sock_sendmsg+0xc4/0x150
>>   [<ffffffff81681ab3>] ? __fdget+0x13/0x20
>>   [<ffffffff83aa5a61>] ? sockfd_lookup_light+0x21/0x230
>>   [<ffffffff83aaa086>] ? SYSC_sendto+0x166/0x240
>>   [<ffffffff811561d2>] ? syscall_trace_enter_phase2+0x2f2/0x640
>>   [<ffffffff83aac57e>] ? SyS_sendto+0xe/0x10
>>   [<ffffffff845cb778>] ? tracesys_phase2+0xd8/0xdd
>>
>>   [9]kdb> rd
>>   ax: 0000000000000087  bx: ffff8803c086ed00  cx: 0000000000000000
>>   dx: 1ffffffff0a51c6b  si: 1ffffffff0a51c6b  di: ffffffff81391731
>>   bp: ffff8805318ab528  sp: ffff8805318ab4b8  r8: ffffffff8528e415
>>   r9: 0000000000000000  r10: ffffe8fff0a51c80  r11: 0000000000000007
>>   r12: ffffffff849a5420  r13: 00000000000000c0  r14: 0000000000000064
>>   r15: ffff8803bd804ebc  ip: ffffffff83abddc4  flags: 00010296  cs:
>> 00000010
>>   ss: 00000018  ds: 00000018  es: 00000018  fs: 00000018  gs: 00000018
>>
>> ONFIG_KASAN_INLINE enabled
>> 0GPF could be caused by NULL-ptr deref or user memory access
>> 2KGDB: re-enter exception: ALL breakpoints killed
>> 0CONFIG_KASAN_INLINE enabled
>> 0GPF could be caused by NULL-ptr deref or user memory access
>> dCPU: 9 PID: 14150 Comm: trinity-c9 Tainted: G    B   W I    3.18.0-rc1+
>> #8
>> dHardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS
>> A08 09/16/2010
>>   ffff8805318aacb8 00000000ea01fa3d 0000000000000000 00000000000003e8
>>   ffff8805318aaa68 ffffffff845b35bb 1ffffffff0a512a4 ffffffff852ddd00
>>   ffff8805318aab08 ffffffff81459b3d ffff880500000000 ffffffff811394e5
>> Call Trace:
>>   [<ffffffff845b35bb>] dump_stack+0x4f/0x7c
>>   [<ffffffff81459b3d>] kgdb_handle_exception+0x34d/0x360
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81134b45>] do_general_protection+0x225/0x3c0
>>   [<ffffffff845cd5e8>] general_protection+0x28/0x30
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff81139325>] ? show_stack_log_lvl+0x35/0x480
>>   [<ffffffff814640d9>] ? kdbgetaddrarg+0x559/0x850
>>   [<ffffffff8113b84d>] show_stack+0x3d/0x100
>>   [<ffffffff8146bf22>] kdb_show_stack+0xb2/0x1c0
>>   [<ffffffff8146c6ee>] kdb_bt+0x56e/0x8b0
>>   [<ffffffff8145e7c0>] ? kdb_printf+0x50/0x70
>>   [<ffffffff8146700b>] kdb_parse+0x67b/0xf80
>>   [<ffffffff8146827c>] kdb_main_loop+0x69c/0x9f0
>>   [<ffffffff8146e9d0>] kdb_stub+0x6b0/0x1230
>>   [<ffffffff81458dc9>] kgdb_cpu_enter+0x569/0xce0
>>   [<ffffffff81459ab9>] kgdb_handle_exception+0x2c9/0x360
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81133acf>] do_error_trap+0x5f/0x1b0
>>   [<ffffffff845c1682>] ? preempt_schedule+0x62/0xa0
>>   [<ffffffff81f29d44>] ? ___preempt_schedule+0x35/0x37
>>   [<ffffffff81f29d0a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
>>   [<ffffffff81134620>] do_invalid_op+0x20/0x30
>>   [<ffffffff845cd09e>] invalid_op+0x1e/0x30
>>   [<ffffffff845aea2a>] ? printk+0xa8/0xc3
>>   [<ffffffff81391731>] ? vprintk_emit+0x341/0x720
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83cff03e>] ? ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac4551>] skb_push+0xc1/0x100
>>   [<ffffffff83cff03e>] ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac8410>] ? __skb_checksum+0x110/0x730
>>   [<ffffffff81604c92>] ? kmem_cache_free+0x1d2/0x210
>>   [<ffffffff8437cf91>] sctp_v4_xmit+0x101/0x1a0
>>   [<ffffffff843d5ba2>] sctp_packet_transmit+0xf32/0x2050
>>   [<ffffffff8438fb8c>] ? sctp_chunkify+0x4c/0x2a0
>>   [<ffffffff81622c64>] ? kasan_poison_shadow+0x34/0x40
>>   [<ffffffff843d2a50>] ? sctp_csum_combine+0x20/0x20
>>   [<ffffffff843d2a30>] ? sctp_packet_release_owner+0x50/0x50
>>   [<ffffffff843a6dde>] sctp_outq_flush+0x6ee/0x2fa0
>>   [<ffffffff81326b7f>] ? preempt_count_add+0x16f/0x1b0
>>   [<ffffffff843ad8dd>] sctp_outq_uncork+0x6d/0x90
>>   [<ffffffff84378765>] sctp_do_sm+0x2c25/0x4a40
>>   [<ffffffff83ce2630>] ? __ip_route_output_key+0xa50/0x2830
>>   [<ffffffff83e99011>] ? xfrm_lookup_route+0x21/0x100
>>   [<ffffffff83ce5369>] ? ip_route_output_flow+0x69/0x90
>>   [<ffffffff82305052>] ? extract_entropy+0xa2/0x230
>>   [<ffffffff8437d7ff>] ? sctp_v4_get_dst+0x65f/0x1040
>>   [<ffffffff843d2584>] sctp_primitive_ASSOCIATE+0x84/0xd0
>>   [<ffffffff843c4ad6>] sctp_sendmsg+0x15b6/0x29b0
>>   [<ffffffff81530000>] ? toggle_bp_slot.constprop.11+0x1d0/0x530
>>   [<ffffffff81544636>] ? generic_perform_write+0x266/0x450
>>   [<ffffffff83dda011>] inet_sendmsg+0x231/0x360
>>   [<ffffffff83aa9e94>] sock_sendmsg+0xc4/0x150
>>   [<ffffffff81681ab3>] ? __fdget+0x13/0x20
>>   [<ffffffff83aa5a61>] ? sockfd_lookup_light+0x21/0x230
>>   [<ffffffff83aaa086>] SYSC_sendto+0x166/0x240
>>   [<ffffffff811561d2>] ? syscall_trace_enter_phase2+0x2f2/0x640
>>   [<ffffffff83aac57e>] SyS_sendto+0xe/0x10
>>   [<ffffffff845cb778>] tracesys_phase2+0xd8/0xdd
>> 0Kernel panic - not syncing: Recursive entry to debugger
>> dCPU: 9 PID: 14150 Comm: trinity-c9 Tainted: G    B   W I    3.18.0-rc1+
>> #8
>> dHardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS
>> A08 09/16/2010
>>   ffff8805318aacb8 00000000ea01fa3d 0000000000000000 00000000000003e8
>>   ffff8805318aa9e8 ffffffff845b35bb 1ffffffff0a51c00 ffffffff84b62959
>>   ffff8805318aaa68 ffffffff845ae6ed ffff880300000008 ffff8805318aaa78
>> Call Trace:
>>   [<ffffffff845b35bb>] dump_stack+0x4f/0x7c
>>   [<ffffffff845ae6ed>] panic+0x168/0x2c3
>>   [<ffffffff81459b50>] kgdb_handle_exception+0x360/0x360
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81134b45>] do_general_protection+0x225/0x3c0
>>   [<ffffffff845cd5e8>] general_protection+0x28/0x30
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff81139325>] ? show_stack_log_lvl+0x35/0x480
>>   [<ffffffff814640d9>] ? kdbgetaddrarg+0x559/0x850
>>   [<ffffffff8113b84d>] show_stack+0x3d/0x100
>>   [<ffffffff8146bf22>] kdb_show_stack+0xb2/0x1c0
>>   [<ffffffff8146c6ee>] kdb_bt+0x56e/0x8b0
>>   [<ffffffff8145e7c0>] ? kdb_printf+0x50/0x70
>>   [<ffffffff8146700b>] kdb_parse+0x67b/0xf80
>>   [<ffffffff8146827c>] kdb_main_loop+0x69c/0x9f0
>>   [<ffffffff8146e9d0>] kdb_stub+0x6b0/0x1230
>>   [<ffffffff81458dc9>] kgdb_cpu_enter+0x569/0xce0
>>   [<ffffffff81459ab9>] kgdb_handle_exception+0x2c9/0x360
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81133acf>] do_error_trap+0x5f/0x1b0
>>   [<ffffffff845c1682>] ? preempt_schedule+0x62/0xa0
>>   [<ffffffff81f29d44>] ? ___preempt_schedule+0x35/0x37
>>   [<ffffffff81f29d0a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
>>   [<ffffffff81134620>] do_invalid_op+0x20/0x30
>>   [<ffffffff845cd09e>] invalid_op+0x1e/0x30
>>   [<ffffffff845aea2a>] ? printk+0xa8/0xc3
>>   [<ffffffff81391731>] ? vprintk_emit+0x341/0x720
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83cff03e>] ? ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac4551>] skb_push+0xc1/0x100
>>   [<ffffffff83cff03e>] ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac8410>] ? __skb_checksum+0x110/0x730
>>   [<ffffffff81604c92>] ? kmem_cache_free+0x1d2/0x210
>>   [<ffffffff8437cf91>] sctp_v4_xmit+0x101/0x1a0
>>   [<ffffffff843d5ba2>] sctp_packet_transmit+0xf32/0x2050
>>   [<ffffffff8438fb8c>] ? sctp_chunkify+0x4c/0x2a0
>>   [<ffffffff81622c64>] ? kasan_poison_shadow+0x34/0x40
>>   [<ffffffff843d2a50>] ? sctp_csum_combine+0x20/0x20
>>   [<ffffffff843d2a30>] ? sctp_packet_release_owner+0x50/0x50
>>   [<ffffffff843a6dde>] sctp_outq_flush+0x6ee/0x2fa0
>>   [<ffffffff81326b7f>] ? preempt_count_add+0x16f/0x1b0
>>   [<ffffffff843ad8dd>] sctp_outq_uncork+0x6d/0x90
>>   [<ffffffff84378765>] sctp_do_sm+0x2c25/0x4a40
>>   [<ffffffff83ce2630>] ? __ip_route_output_key+0xa50/0x2830
>>   [<ffffffff83e99011>] ? xfrm_lookup_route+0x21/0x100
>>   [<ffffffff83ce5369>] ? ip_route_output_flow+0x69/0x90
>>   [<ffffffff82305052>] ? extract_entropy+0xa2/0x230
>>   [<ffffffff8437d7ff>] ? sctp_v4_get_dst+0x65f/0x1040
>>   [<ffffffff843d2584>] sctp_primitive_ASSOCIATE+0x84/0xd0
>>   [<ffffffff843c4ad6>] sctp_sendmsg+0x15b6/0x29b0
>>   [<ffffffff81530000>] ? toggle_bp_slot.constprop.11+0x1d0/0x530
>>   [<ffffffff81544636>] ? generic_perform_write+0x266/0x450
>>   [<ffffffff83dda011>] inet_sendmsg+0x231/0x360
>>   [<ffffffff83aa9e94>] sock_sendmsg+0xc4/0x150
>>   [<ffffffff81681ab3>] ? __fdget+0x13/0x20
>>   [<ffffffff83aa5a61>] ? sockfd_lookup_light+0x21/0x230
>>   [<ffffffff83aaa086>] SYSC_sendto+0x166/0x240
>>   [<ffffffff811561d2>] ? syscall_trace_enter_phase2+0x2f2/0x640
>>   [<ffffffff83aac57e>] SyS_sendto+0xe/0x10
>>   [<ffffffff845cb778>] tracesys_phase2+0xd8/0xdd
>> 0Shutting down cpus with NMI
>> PANIC: Recursive entry to debugger
>> dCPU: 9 PID: 14150 Comm: trinity-c9 Tainted: G    B   W I    3.18.0-rc1+
>> #8
>> dHardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS
>> A08 09/16/2010
>>   ffff88053f528f58 00000000ea01fa3d 0000000000000000 00000000000003e8
>>   ffff88053f528de8 ffffffff845b35bb 1ffff100a7ea51fb ffffffff852ddd00
>>   ffff88053f528e88 ffffffff81459b3d ffff88053f528e68 ffffffff81459f83
>> Call Trace:
>>   <#DB>  [<ffffffff845b35bb>] dump_stack+0x4f/0x7c
>>   [<ffffffff81459b3d>] kgdb_handle_exception+0x34d/0x360
>>   [<ffffffff81459f83>] ? kgdb_breakpoint+0x13/0x20
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff81307c2d>] ? notify_die+0x3d/0x60
>>   [<ffffffff811dab26>] kgdb_ll_trap+0x76/0xa0
>>   [<ffffffff81134d73>] do_int3+0x93/0x210
>>   [<ffffffff845cd4da>] int3+0x3a/0x50
>>   [<ffffffff81459f84>] ? kgdb_breakpoint+0x14/0x20
>>   <<EOE>>  [<ffffffff8145a029>] kgdb_panic_event+0x29/0x30
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff845ae73d>] panic+0x1b8/0x2c3
>>   [<ffffffff81459b50>] kgdb_handle_exception+0x360/0x360
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81134b45>] do_general_protection+0x225/0x3c0
>>   [<ffffffff845cd5e8>] general_protection+0x28/0x30
>>   [<ffffffff811394e5>] ? show_stack_log_lvl+0x1f5/0x480
>>   [<ffffffff81139325>] ? show_stack_log_lvl+0x35/0x480
>>   [<ffffffff814640d9>] ? kdbgetaddrarg+0x559/0x850
>>   [<ffffffff8113b84d>] show_stack+0x3d/0x100
>>   [<ffffffff8146bf22>] kdb_show_stack+0xb2/0x1c0
>>   [<ffffffff8146c6ee>] kdb_bt+0x56e/0x8b0
>>   [<ffffffff8145e7c0>] ? kdb_printf+0x50/0x70
>>   [<ffffffff8146700b>] kdb_parse+0x67b/0xf80
>>   [<ffffffff8146827c>] kdb_main_loop+0x69c/0x9f0
>>   [<ffffffff8146e9d0>] kdb_stub+0x6b0/0x1230
>>   [<ffffffff81458dc9>] kgdb_cpu_enter+0x569/0xce0
>>   [<ffffffff81459ab9>] kgdb_handle_exception+0x2c9/0x360
>>   [<ffffffff811da77e>] __kgdb_notify+0x10e/0x3c0
>>   [<ffffffff811daa69>] kgdb_notify+0x39/0x80
>>   [<ffffffff813064b2>] notifier_call_chain+0xc2/0x130
>>   [<ffffffff81306917>] atomic_notifier_call_chain+0x37/0x50
>>   [<ffffffff81307c2d>] notify_die+0x3d/0x60
>>   [<ffffffff81133acf>] do_error_trap+0x5f/0x1b0
>>   [<ffffffff845c1682>] ? preempt_schedule+0x62/0xa0
>>   [<ffffffff81f29d44>] ? ___preempt_schedule+0x35/0x37
>>   [<ffffffff81f29d0a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
>>   [<ffffffff81134620>] do_invalid_op+0x20/0x30
>>   [<ffffffff845cd09e>] invalid_op+0x1e/0x30
>>   [<ffffffff845aea2a>] ? printk+0xa8/0xc3
>>   [<ffffffff81391731>] ? vprintk_emit+0x341/0x720
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83abddc4>] ? skb_panic+0x154/0x220
>>   [<ffffffff83cff03e>] ? ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac4551>] skb_push+0xc1/0x100
>>   [<ffffffff83cff03e>] ip_queue_xmit+0x12e/0x16d0
>>   [<ffffffff83ac8410>] ? __skb_checksum+0x110/0x730
>>   [<ffffffff81604c92>] ? kmem_cache_free+0x1d2/0x210
>>   [<ffffffff8437cf91>] sctp_v4_xmit+0x101/0x1a0
>>   [<ffffffff843d5ba2>] sctp_packet_transmit+0xf32/0x2050
>>   [<ffffffff8438fb8c>] ? sctp_chunkify+0x4c/0x2a0
>>   [<ffffffff81622c64>] ? kasan_poison_shadow+0x34/0x40
>>   [<ffffffff843d2a50>] ? sctp_csum_combine+0x20/0x20
>>   [<ffffffff843d2a30>] ? sctp_packet_release_owner+0x50/0x50
>>   [<ffffffff843a6dde>] sctp_outq_flush+0x6ee/0x2fa0
>>   [<ffffffff81326b7f>] ? preempt_count_add+0x16f/0x1b0
>>   [<ffffffff843ad8dd>] sctp_outq_uncork+0x6d/0x90
>>   [<ffffffff84378765>] sctp_do_sm+0x2c25/0x4a40
>>   [<ffffffff83ce2630>] ? __ip_route_output_key+0xa50/0x2830
>>   [<ffffffff83e99011>] ? xfrm_lookup_route+0x21/0x100
>>   [<ffffffff83ce5369>] ? ip_route_output_flow+0x69/0x90
>>   [<ffffffff82305052>] ? extract_entropy+0xa2/0x230
>>   [<ffffffff8437d7ff>] ? sctp_v4_get_dst+0x65f/0x1040
>>   [<ffffffff843d2584>] sctp_primitive_ASSOCIATE+0x84/0xd0
>>   [<ffffffff843c4ad6>] sctp_sendmsg+0x15b6/0x29b0
>>   [<ffffffff81530000>] ? toggle_bp_slot.constprop.11+0x1d0/0x530
>>   [<ffffffff81544636>] ? generic_perform_write+0x266/0x450
>>   [<ffffffff83dda011>] inet_sendmsg+0x231/0x360
>>   [<ffffffff83aa9e94>] sock_sendmsg+0xc4/0x150
>>   [<ffffffff81681ab3>] ? __fdget+0x13/0x20
>>   [<ffffffff83aa5a61>] ? sockfd_lookup_light+0x21/0x230
>>   [<ffffffff83aaa086>] SYSC_sendto+0x166/0x240
>>   [<ffffffff811561d2>] ? syscall_trace_enter_phase2+0x2f2/0x640
>>   [<ffffffff83aac57e>] SyS_sendto+0xe/0x10
>>   [<ffffffff845cb778>] tracesys_phase2+0xd8/0xdd
>>
>>
>>
>>
>



-- 
Robert Święcki
