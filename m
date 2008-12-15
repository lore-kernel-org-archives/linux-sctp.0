From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 15 Dec 2008 17:41:04 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <494696B0.2020707@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Karsten Keil wrote:
> On Mon, Dec 15, 2008 at 10:38:56AM -0500, Vlad Yasevich wrote:
>> Karsten Keil wrote:
>>> Hi Vlad,
>>>
>>> On Thu, Dec 11, 2008 at 10:28:35AM -0500, Vlad Yasevich wrote:
>>>> Michal Hocko wrote:
>>>>> Hi Vlad,
>>>>>
>>>>> I am starting this new thread because I am starting to believe that
>>>>> sles10sp2 kernel (based on 2.6.16 upstream kernel) experiences different
>>>>> issue than we can see in the upstream kernel (see bellow).
>>>>>
>>>>> Karsten (CCing him) has found out following:
>>>>> "
>>>>> OK I think the
>>>>> KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
>>>>> net/ipv4/af_inet.c (149)
>>>>>
>>>>> is related to the main problem here, it says that on the time a socket
>>>>> get destroyed here is still some wmem allocated. This mean here is still
>>>>> a transmit skb on the fly. Since sctp use skb destructors to do the
>>>>> memory accounting, this also means that after destroying the socket, the
>>>>> destructor of this skb will access the already freed socket struct,
>>>>> which will let in some cases (if the memory is in use again and the
>>>>> pointers are already overwritten) cause the crash with on
>>>>> {sock_wfree+48} (which is a call to sk->sk_write_space(sk);).  Of course
>>>>> it can crash in every other place, since the accounting may overwrite
>>>>> pointers in any other struct, which reuse this memory.
>>>>>
>>>>> I instrument some routines with extra debug (eg. inet_sock_destruct) too
>>>>> see the amount of memory in sk->sk_wmem_alloc, it allmost show 
>>>>>
>>>>> Dec 11 12:31:16 gw kernel: inet_sock_destruct:
>>>>> sk(ffff810116960e00)->sk_wmem_alloc 496
>>>>> Dec 11 12:31:17 gw kernel: inet_sock_destruct:
>>>>> sk(ffff8101144f1b00)->sk_wmem_alloc 496
>>>>> Dec 11 12:31:18 gw kernel: inet_sock_destruct:
>>>>> sk(ffff8101144f1b00)->sk_wmem_alloc -496
>>>>> Dec 11 12:31:20 gw kernel: inet_sock_destruct:
>>>>> sk(ffff81011d461a00)->sk_wmem_alloc 496
>>>>> Dec 11 12:31:21 gw kernel: inet_sock_destruct:
>>>>> sk(ffff81011d460080)->sk_wmem_alloc 496
>>>>>
>>>>> Note the -496, I think this is a case in which the same memory was again
>>>>> allocated by a socket struct, so the memory still has valid pointers and
>>>>> so on the destructor call for the old socket it did decrement the memory
>>>>> on the new socket.
>>>>>
>>>>> Do you agree with this analysis ?
>>>>> "
>>>>>
>>>>> I am trying to go through git logs but maybe you remember some fix in
>>>>> this area.
>>>>>
>>>>> If I understand correctly, then 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
>>>>> removes destructors from sctp completely, so the previous should not
>>>>> happen in upstream, shouldn't it?
>>>>>
>>>> Here are a few commits that you need to check on:
>>>>
>>>> 61c9fed41638249f8b6ca5345064eb1beb50179f
>>>> [SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_rcv().
>>>>
>>>> cfdeef3282705a4b872d3559c4e7d2561251363c
>>>> [SCTP]: Unhash the endpoint in sctp_endpoint_free().
>>>>
>>>> f26f7c480555812ca7c4037e0a50fa54afe2cb4a
>>>> [SCTP]: Add bind hash locking to the migrate code
>>>>
>>>>
>>>> All of the above commits address races in the SCTP code and are not in the base
>>>> 2.6.16 kernel.
>>>>
>>> Thanks for your input.
>>>
>>> 61c9fed41638249f8b6ca5345064eb1beb50179f
>>> [SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_rcv().
>>>
>>> seems to fix this issue, I applied also the other patches.
>>>
>>> Now I do not get any longer the "KERNEL: assertion
>>> (!atomic_read(&sk->sk_wmem_alloc)) failed ..." messages.
>>>
>>> But now I run into the skb_overflow BUG.
>>> With some extra debug (based on your debug patch) I see:
>>>
>>> Possible SKB overflow: packet size = 76, packet overhead = 32, packet chunk = 1/4, chunk len 40 packet padding 0 nskb len 12 mtu = 1500
>>>
>>> packet chunk = 1/4 read as first chunk of total 4 chunks cause the overflow.
>> OK.  It appears that the list of chunk on the packets is not cleaned up
>> correctly.  It could also be that in my prior debug patches I didn't reset
>> the number of chunks properly.
> 
> No I think that the debug patch is correct.
> I already tried some things, so log "the history" of adding chunks in the
> packet struct, but it does not really help me, but maybe you see something:
> 
> Possible SKB overflow: packet size = 1072, packet overhead = 32, packet chunk = 2/4, chunk len 40 packet padding 0 nskb len 1052 mtu = 1500
> 
> 
> chunk[1]: ps(36) ss(4) cs(4) ct(11)
> chunk[2]: ps(48) ss(16) cs(16) ct(3)
> chunk[3]: ps(1088) ss(1040) cs(1040) ct(0)
> chunk[4]: ps(1072) ss(1040) cs(1040) ct(0)
> skb_over_panic: text:ffffffff8824af48 len:2092 put:1040
> head:ffff81006b8b8000 data:ffff81006b8b8074 tail:ffff81006b8b88a0
> end:ffff81006b8b8500 dev:<NULL>
> 
> ps packet size after adding this chunk
> ss chunk->skb->len
> cs chunk_len
> ct chunk type
> 
> I attach the patch at the end, so you see what I did.
> 
> All traces (with our 2.6.16) are similar to this one (which happend after
> the above printout).
> 
> CPU 0
> Modules linked in: sctp cpufreq_ondemand cpufreq_userspace cpufreq_powersave
> powernow_k8 freq_table ipv6 af_packet button battery ac apparmor loop dm_mod
> floppy r8169 parport_pc
> Pid: 0, comm: swapper Tainted: G     U 2.6.16.60-0.33-smp #13
> RIP: 0010:[<ffffffff8028667e>] <ffffffff8028667e>{skb_over_panic+77}
> RSP: 0018:ffffffff8042fb68  EFLAGS: 00010296
> RAX: 000000000000009d RBX: 0000000000000410 RCX: 00000000000046b2
> RDX: ffff81006b8b8490 RSI: 0000000000000296 RDI: ffffffff8035a99c
> RBP: ffff81010845e480 R08: 0000000000000000 R09: 0000000000000010
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff81006bd87bc0
> R13: ffff81006b8b8490 R14: ffff810069b3ad50 R15: ffff810069b3ac00
> FS:  00002aba700166e0(0000) GS:ffffffff803d4000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00002ae33210c000 CR3: 0000000117424000 CR4: 00000000000006e0
> Process swapper (pid: 0, threadinfo ffffffff803ee000, task ffffffff80354320)
> Stack: ffff81006b8b88a0 ffff81006b8b8500 ffffffff803197b7 000000000000041c
>        00000000000005dc ffffffff8824af52 0000000000000286 ffff810069b3ad58
>        ffff810117a4f000 ffff810108042000
> Call Trace: <IRQ> <ffffffff8824af52>{:sctp:sctp_packet_transmit+962}
>        <ffffffff882437c7>{:sctp:sctp_outq_flush+1507}
> <ffffffff8013d450>{do_timer+61}
>        <ffffffff8010f5f6>{main_timer_handler+641}
> <ffffffff801198b4>{smp_send_timer_broadcast_ipi+107}
>        <ffffffff88243ab3>{:sctp:sctp_retransmit+116}
> <ffffffff8010b35e>{ret_from_intr+0}
>        <ffffffff8823baf1>{:sctp:sctp_do_sm+1503}
> <ffffffff8014a88a>{ktime_get+14}
>        <ffffffff8823c4c7>{:sctp:sctp_generate_t3_rtx_event+0}
>        <ffffffff8823c53c>{:sctp:sctp_generate_t3_rtx_event+117}
>        <ffffffff8013db23>{run_timer_softirq+352}
> <ffffffff80139774>{__do_softirq+85}
>        <ffffffff8010c222>{call_softirq+30} <ffffffff8010d1a4>{do_softirq+44}
>        <ffffffff80109d41>{default_idle+0}
> <ffffffff8010bb7c>{apic_timer_interrupt+132} <EOI>
>        <ffffffff80109d41>{default_idle+0}
> <ffffffff80109d7d>{default_idle+60}
>        <ffffffff80109e57>{cpu_idle+160} <ffffffff803f0832>{start_kernel+626}
>        <ffffffff803f02a2>{_sinittext+674}
> 
> 
> 
>> Since this is the same bug that I am trying to diagnose in 2.6.27+, it now
>> boils down to the same problem.  Either the packet is not cleaned up
>> correctly, or there is a race wrt packet chunk list.
>>
> 
> Unfortunately I could not reproduce it with 2.6.27 here (I did run the test
> overnight, > 12 hour), with our 2.6.16 it triggers on my machine (Dual core
> AMD 64) in 5 -10 minutes. I also tried 2.6.25, here I could see a similar
> Oops after 3 hour.
> 
> I had the idea, that maybe the corruption comes from concurent access
> to a chunk list, so I did instrument all list operation on the
> chunklist with special debug spinlocks (use try_lock and print a message
> if failed), the message was never printed, but it crashed with the same
> trace, so I think we can rule out this (I used seperate locks for
> each list_head).
> 

I've tried that as well with the same results.  However, what really got to me
was that when added

BUG_ON(!list_empty(&packet->chunk_list));

after the loop that took all the chunks from the list, I tripped over this
BUG.

The way the code is structured, at the end of sctp_packet_transmit() the
packet must be empty, i.e. the chunk_list must be empty and the number
of chunks must be 0.

See if you can play around with that.

FYI, I am currently running with the following patch on top of 2.6.28-rc6.
It is a cumulative of a few bugs I found and debugging for the chunk_list
corruption.  The BUG is currently commented out since I wanted to see how
it runs without it.

-vlad
