From: "Michael Krolikowski" <MIK@mach.com>
Date: Wed, 30 Sep 2009 15:32:22 +0000
Subject: RE: linux sctp bug
Message-Id: <328601A8AE3DB64B9A9DF1CCA840B770028DB6BC@EXCHDK.machcorp.lan>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AC0E835.60808@hp.com>
In-Reply-To: <4AC0E835.60808@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I've first seen the bug in Debian Lenny with Debian's patched Linux 2.6.
Now I've just installed Linux 2.6.26.8 (UML) and seen a different
behavior:

SCTP: Hash tables configured (established 512 bind 512)
BUG: soft lockup - CPU#0 stuck for 61s! [sctp_test:847]
Modules linked in: sctp

Modules linked in: sctp
Pid: 847, comm: sctp_test Not tainted 2.6.26.8
RIP: 0033:[<0000000062dad9c2>]
RSP: 0000000061f3b870  EFLAGS: 00000202
RAX: 7360adde2c000001 RBX: 0000000061e20000 RCX: 0000000061f3b910
RDX: 7360adde2c000001 RSI: 0000000000000000 RDI: 000000006150ea00
RBP: 0000000061f3b880 R08: 0000000061e20140 R09: 0000000000000000
R10: 0000000060228240 R11: 0000000000000049 R12: 0000000061e20000
R13: 0000000061e20000 R14: 0000000062dbfeb5 R15: 0000000062dc1a00
Call Trace:
601c7ae8:  [<6004e355>] softlockup_tick+0xf7/0x10a
601c7af8:  [<600318e7>] raise_softirq+0x64/0x6d
601c7b28:  [<60035bf0>] run_local_timers+0x18/0x1a
601c7b38:  [<60035c69>] update_process_times+0x2e/0x59
601c7b68:  [<600463c9>] tick_sched_timer+0x64/0x96
601c7b98:  [<600418da>] __run_hrtimer+0x26/0x6f
601c7bb8:  [<600421b2>] hrtimer_interrupt+0xe3/0x143
601c7bf8:  [<60012cd4>] um_timer+0xf/0x16
601c7c08:  [<6004e78a>] handle_IRQ_event+0x2b/0x5f
601c7c38:  [<6004e81f>] __do_IRQ+0x61/0xa6
601c7c68:  [<60010b8a>] do_IRQ+0x23/0x39
601c7c88:  [<60012d42>] timer_handler+0x21/0x2f
601c7ca8:  [<60020e87>] real_alarm_handler+0x3f/0x41
601c7cb8:  [<62dbfeb5>] sctp_pname+0x0/0x1a [sctp]
601c7d30:  [<62dad9c2>] sctp_assoc_update_retran_path+0x44/0x13e [sctp]
601c7db8:  [<60020ee5>] alarm_handler+0x2e/0x39
601c7dd8:  [<60021179>] handle_signal+0x6b/0xa1
601c7e10:  [<62dbfeb5>] sctp_pname+0x0/0x1a [sctp]
601c7e28:  [<60022a90>] hard_handler+0x10/0x14
601c7e98:  [<62dbfeb5>] sctp_pname+0x0/0x1a [sctp]
601c7ee8:  [<62dad9c2>] sctp_assoc_update_retran_path+0x44/0x13e [sctp]

I did the test with the sctp_test tool from http://lksctp.sf.net/
I just repeated executing the tool manually, so no tight loop.
I always had both systems running with the same Linux Version. But this
shouldn't be the problem should it? It's always the same ICMP message I
get
from the remote host.
I did the test with Debian Lenny running inside VMware as well but
didn't
test inside KVM. I couldn't reproduce the bug in live systems but I did
only one quick test there. I'll give that a try and let you know - but
it
might take me a while.

Michael


-----Original Message-----
From: Vlad Yasevich [mailto:vladislav.yasevich@hp.com] 
Sent: Mittwoch, 30. September 2009 16:31
To: Michael Krolikowski
Cc: linux-sctp@vger.kernel.org
Subject: Re: linux sctp bug

Michael Krolikowski wrote:
> Hi,
> 
> I'm testing it using two UML machines. Both of them running Linux
> 2.6.31.
> I tried it today again and it seems that the error occurs not as I
first
> said after only a few tries but many tries later it does.
> I also tried with 2.6.31.1 (UML) with the same results.
> I used Debian Lenny with a 2.6.26 Linux where I got the error for the
> first time.

So you were able to reproduce this with 2.6.26 kernel?

How do you test?  Do you just try to call connect() in a loop?

I run under KVM with a connect() call in a tight loop and see
not issues.  My ICMP sender is an Ubuntu Jaunty (2.6.28-15-generic)
kernel.

Looking at the stack trace you posted, the failure happens here:
        if (!asoc->temp) {
>>>              list_del(&asoc->asocs);

The addresses look very weird to.

Can reproduce this with live systems, or KVM?  I am suspecting UML...

-vlad


> 
> I hope this little information helps you a bit.
> 
> 
> Regards,
> 
> Michael
> 
> 
> -----Original Message-----
> From: Vlad Yasevich [mailto:vladislav.yasevich@hp.com] 
> Sent: Montag, 28. September 2009 18:46
> To: Michael Krolikowski
> Cc: Sridhar Samudrala; Linux SCTP Dev Mailing list
> Subject: Re: linux sctp bug
> 
> Michael Krolikowski wrote:
>> Hi,
>>
>> I think I found a bug in the Linux SCTP implementation. I hope you
are
>> the right persons to ask for help with this.
> 
> The right place to ask is on linux-sctp mailing list.
> 
>> If I send an SCTP INIT to a host which does not support SCTP (e.g.
the
>> module is not loaded), the
>> other host sends an ICMP Protocol unreachable. This makes the SCTP
>> module on the initiating host
>> crash. It maybe that it crashes not at the first try but if I repeat
> the
>> SCTP INIT 3-4 times it will crash.
> 
> Hm..  I've tried to reproduce and couldn't with top of tree 2.6.31.
> I've tried repeating INITs over the same path and over multiple paths,
> but
> didn't see a crash.
> 
> Would you be able to do a bisect?
> 
> Thanks
> -vlad
> 
>> See this message:
>> SCTP: Hash tables configured (established 512 bind 512)
>>
>> Modules linked in: sctp
>> Pid: 610, comm: sctp_test Not tainted 2.6.31
>> RIP: 0033:[<00000000646228f9>]
>> RSP: 0000000063873810  EFLAGS: 00010246
>> RAX: 0000000000200200 RBX: 0000000063a20000 RCX: 00000000638e6800
>> RDX: 0000000000100100 RSI: 000000006384b8c0 RDI: 0000000063a20000
>> RBP: 0000000063873830 R08: 0000003000000008 R09: 0000000000000000
>> R10: 000000000000000f R11: 0000000000000000 R12: 00000000ffffffea
>> R13: 00000000638e6800 R14: 0000000063a20000 R15: 0000000063a20000
>> Call Trace: 
>> 601f1ad8:  [<60014bcd>] segv+0x1fd/0x20f
>> 601f1b18:  [<601102f0>] process_backlog+0x8b/0xa9
>> 601f1b58:  [<60110904>] net_rx_action+0xe5/0x123
>> 601f1bb8:  [<60014c92>] segv_handler+0xb3/0xb9
>> 601f1bf8:  [<600329c4>] do_softirq+0x43/0x4a
>> 601f1c28:  [<60016439>] free_irqs+0x72/0xd4
>> 601f1c68:  [<60012108>] sigio_handler+0x5a/0x5f
>> 601f1c88:  [<60021a47>] sig_handler_common+0x87/0x9b
>> 601f1d10:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1d30:  [<60017b51>] line_write_room+0x57/0x58
>> 601f1db8:  [<60021b90>] sig_handler+0x30/0x3b
>> 601f1dd8:  [<60021de9>] handle_signal+0x6b/0xa1
>> 601f1e28:  [<600236fc>] hard_handler+0x10/0x14
>> 601f1ee8:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>>
>> Kernel panic - not syncing: Kernel mode fault at addr 0x100108, ip
>> 0x646228f9
>> Call Trace: 
>> 601f19d8:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f19e8:  [<60158b8d>] panic+0xd3/0x174
>> 601f1a20:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1a40:  [<6004c462>] __module_text_address+0xd/0x5b
>> 601f1a58:  [<6004c4b9>] is_module_text_address+0x9/0x11
>> 601f1a68:  [<6003e264>] __kernel_text_address+0x65/0x6b
>> 601f1a70:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1a88:  [<60013a96>] show_trace+0x8e/0x92
>> 601f1aa8:  [<600271ff>] show_regs+0x2b/0x30
>> 601f1ad8:  [<60014bdf>] segv_handler+0x0/0xb9
>> 601f1b18:  [<601102f0>] process_backlog+0x8b/0xa9
>> 601f1b58:  [<60110904>] net_rx_action+0xe5/0x123
>> 601f1bb8:  [<60014c92>] segv_handler+0xb3/0xb9
>> 601f1bf8:  [<600329c4>] do_softirq+0x43/0x4a
>> 601f1c28:  [<60016439>] free_irqs+0x72/0xd4
>> 601f1c68:  [<60012108>] sigio_handler+0x5a/0x5f
>> 601f1c88:  [<60021a47>] sig_handler_common+0x87/0x9b
>> 601f1d10:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1d30:  [<60017b51>] line_write_room+0x57/0x58
>> 601f1db8:  [<60021b90>] sig_handler+0x30/0x3b
>> 601f1dd8:  [<60021de9>] handle_signal+0x6b/0xa1
>> 601f1e28:  [<600236fc>] hard_handler+0x10/0x14
>> 601f1ee8:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>>
>>
>> Modules linked in: sctp
>> Pid: 610, comm: sctp_test Not tainted 2.6.31
>> RIP: 0033:[<00000000404ef5c0>]
>> RSP: 0000007fbf8613f8  EFLAGS: 00000246
>> RAX: ffffffffffffffda RBX: 0000007fbf861460 RCX: ffffffffffffffff
>> RDX: 0000000000000100 RSI: 0000007fbf861410 RDI: 0000000000000003
>> RBP: 0000000000000001 R08: 00000000ffffffff R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000607560
>> R13: 0000000000000002 R14: 0000000000000000 R15: 0000007fbf861450
>> Call Trace: 
>> 601f1960:  [<6004c462>] __module_text_address+0xd/0x5b
>> 601f1978:  [<60014e05>] panic_exit+0x2f/0x45
>> 601f1998:  [<60043417>] notifier_call_chain+0x33/0x5b
>> 601f19c8:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f19d8:  [<60043459>] atomic_notifier_call_chain+0xf/0x11
>> 601f19e8:  [<60158b9e>] panic+0xe4/0x174
>> 601f1a20:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1a40:  [<6004c462>] __module_text_address+0xd/0x5b
>> 601f1a58:  [<6004c4b9>] is_module_text_address+0x9/0x11
>> 601f1a68:  [<6003e264>] __kernel_text_address+0x65/0x6b
>> 601f1a70:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1a88:  [<60013a96>] show_trace+0x8e/0x92
>> 601f1aa8:  [<600271ff>] show_regs+0x2b/0x30
>> 601f1ad8:  [<60014bdf>] segv_handler+0x0/0xb9
>> 601f1b18:  [<601102f0>] process_backlog+0x8b/0xa9
>> 601f1b58:  [<60110904>] net_rx_action+0xe5/0x123
>> 601f1bb8:  [<60014c92>] segv_handler+0xb3/0xb9
>> 601f1bf8:  [<600329c4>] do_softirq+0x43/0x4a
>> 601f1c28:  [<60016439>] free_irqs+0x72/0xd4
>> 601f1c68:  [<60012108>] sigio_handler+0x5a/0x5f
>> 601f1c88:  [<60021a47>] sig_handler_common+0x87/0x9b
>> 601f1d10:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>> 601f1d30:  [<60017b51>] line_write_room+0x57/0x58
>> 601f1db8:  [<60021b90>] sig_handler+0x30/0x3b
>> 601f1dd8:  [<60021de9>] handle_signal+0x6b/0xa1
>> 601f1e28:  [<600236fc>] hard_handler+0x10/0x14
>> 601f1ee8:  [<646228f9>] sctp_association_free+0x2b/0x1e0 [sctp]
>>
>> This error seems only to occur if the remote host answers with ICMP
>> protocol unreachable.
>> If the remote host answers with SCTP ABORT, the error won't occur.
>>
>>
>> Thanks in advance,
>>
>> Michael Krolikowski
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

