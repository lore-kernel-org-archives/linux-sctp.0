From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 30 Sep 2009 14:31:08 +0000
Subject: Re: linux sctp bug
Message-Id: <4AC36BAC.5020506@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AC0E835.60808@hp.com>
In-Reply-To: <4AC0E835.60808@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michael Krolikowski wrote:
> Hi,
> 
> I'm testing it using two UML machines. Both of them running Linux
> 2.6.31.
> I tried it today again and it seems that the error occurs not as I first
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
>> I think I found a bug in the Linux SCTP implementation. I hope you are
>> the right persons to ask for help with this.
> 
> The right place to ask is on linux-sctp mailing list.
> 
>> If I send an SCTP INIT to a host which does not support SCTP (e.g. the
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
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

