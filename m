From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 18 Dec 2008 23:01:37 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <494AD651.3010202@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Karsten Keil wrote:
>> On Thu, Dec 18, 2008 at 01:35:08PM +0100, Karsten Keil wrote:
>>> On Mon, Dec 15, 2008 at 12:42:01PM -0500, Vlad Yasevich wrote:
>>>> Oh, forgot the actuall patch. ;)
>>>>
>>>> -vlad
>>> OK I did port back this patch to our 2.6.16 kernel and it seems it
>>> fix some of the pathes to trigger the bug, but after 2.5 hour it
>>> triggers a overflow again, this time with different call path in the
>>> trace:
>>>
>>> Dec 16 18:50:17 gw kernel: SKB ffff81012681f340 overflow: p_size = 32, n_chunks = 0, list(ffff81010be63160, ffff81010be63160)
>>> Dec 16 18:50:17 gw kernel: skb_over_panic: text:ffffffff8824af13 len:2092 put:1040 head:ffff81010e1a7000 data:ffff81010e1a7074 tail:ffff81010e1a78a0 end:ffff81010e1a7500 dev:<NULL>
>>> Dec 16 18:50:17 gw kernel: ----------- [cut here ] --------- [please bite here ] ---------
>>> Dec 16 18:50:17 gw kernel: Kernel BUG at net/core/skbuff.c:103
>>> Dec 16 18:50:17 gw kernel: invalid opcode: 0000 [1] SMP 
>>> Dec 16 18:50:17 gw kernel: last sysfs file: /devices/pci0000:00/0000:00:14.4/0000:04:05.0/irq
>>> Dec 16 18:50:17 gw kernel: CPU 0 
>>> Dec 16 18:50:17 gw kernel: Modules linked in: sctp cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table ipv6 af_packet button battery ac apparmor loop dm_mod floppy r8169 parport_pc lp parport ext3 jbd edd fan thermal processor atiixp sg ahci libata sd_mod scsi_mod ide_disk ide_core
>>> Dec 16 18:50:17 gw kernel: Pid: 11882, comm: sctpcrash Tainted: G     U 2.6.16.60-0.33-smp #13
>>> Dec 16 18:50:17 gw kernel: RIP: 0010:[<ffffffff8028667e>] <ffffffff8028667e>{skb_over_panic+77}
>>> Dec 16 18:50:17 gw kernel: RSP: 0018:ffff81010cbe17e8  EFLAGS: 00010292
>>> Dec 16 18:50:17 gw kernel: RAX: 000000000000009d RBX: 0000000000000410 RCX: 0000000000000292
>>> Dec 16 18:50:17 gw kernel: RDX: ffffffff8035a968 RSI: 0000000000000292 RDI: ffffffff8035a960
>>> Dec 16 18:50:17 gw kernel: RBP: ffff81012681f340 R08: ffffffff8035a968 R09: ffff810128190ac0
>>> Dec 16 18:50:17 gw kernel: R10: ffff810001023780 R11: 0000000000000070 R12: ffff81010e1a7490
>>> Dec 16 18:50:17 gw kernel: R13: ffff81010be63150 R14: ffff81010c926580 R15: ffff81010e1a7074
>>> Dec 16 18:50:17 gw kernel: FS:  00002aeca5d8c6e0(0000) GS:ffffffff803d4000(0000) knlGS:0000000000000000
>>> Dec 16 18:50:17 gw kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> Dec 16 18:50:17 gw kernel: CR2: 00002b363a857000 CR3: 0000000110154000 CR4: 00000000000006e0
>>> Dec 16 18:50:17 gw kernel: Process sctpcrash (pid: 11882, threadinfo ffff81010cbe0000, task ffff810129ece100)
>>> Dec 16 18:50:17 gw kernel: Stack: ffff81010e1a78a0 ffff81010e1a7500 ffffffff803197b7 ffff81010c926580 
>>> Dec 16 18:50:17 gw kernel:        ffff81012681f340 ffffffff8824af1d ffff81010be63160 ffff81010b6f3000 
>>> Dec 16 18:50:17 gw kernel:        ffff81010be63000 ffff81010c948000 
>>> Dec 16 18:50:17 gw kernel: Call Trace: <ffffffff8824af1d>{:sctp:sctp_packet_transmit+851}
>>> Dec 16 18:50:17 gw kernel:        <ffffffff88243810>{:sctp:sctp_outq_flush+1524} <ffffffff8823c2a7>{:sctp:sctp_do_sm+3421}
>>> Dec 16 18:50:17 gw kernel:        <ffffffff8823f22d>{:sctp:sctp_datamsg_from_user+689}
>>> Dec 16 18:50:17 gw kernel:        <ffffffff8824ab05>{:sctp:sctp_primitive_SEND+57} <ffffffff882498ac>{:sctp:sctp_sendmsg+0}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff8824a158>{:sctp:sctp_sendmsg+2220} <ffffffff80283a6a>{release_sock+19}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff8824a6eb>{:sctp:sctp_recvmsg+1024} <ffffffff8028159b>{sock_sendmsg+251}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff80148092>{autoremove_wake_function+0} <ffffffff801fa28c>{sprintf+81}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff80281b6f>{sys_sendmsg+523} <ffffffff801ab20e>{inotify_d_instantiate+26}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff80184655>{fd_install+46} <ffffffff80283bae>{lock_sock+169}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff80283a6a>{release_sock+19} <ffffffff80284e5e>{sock_setsockopt+1230}
>>> Dec 16 18:50:18 gw kernel:        <ffffffff8010ae42>{system_call+126}
>>> Dec 16 18:50:18 gw kernel: 
>>> Dec 16 18:50:18 gw kernel: Code: 0f 0b 68 86 90 32 80 c2 67 00 48 83 c4 28 c3 41 57 41 56 49 
>>> Dec 16 18:50:18 gw kernel: RIP <ffffffff8028667e>{skb_over_panic+77} RSP <ffff81010cbe17e8>
>>>
>>
>> Next crash (after 2 hour):
>> Dec 18 16:32:47 gw kernel: ----------- [cut here ] --------- [please bite here ] ---------
>> Dec 18 16:32:47 gw kernel: Kernel BUG at net/sctp/output.c:352
>> Dec 18 16:32:47 gw kernel: invalid opcode: 0000 [1] SMP 
>> Dec 18 16:32:47 gw kernel: last sysfs file: /devices/pci0000:00/0000:00:00.0/irq
>> Dec 18 16:32:47 gw kernel: CPU 0 
>> Dec 18 16:32:47 gw kernel: Modules linked in: sctp cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table ipv6 af_packet button battery ac apparmor loop dm_mod floppy r8169 parport_pc lp parport ext3 jbd edd fan thermal processor atiixp sg ahci libata sd_mod scsi_mod ide_disk ide_core
>> Dec 18 16:32:47 gw kernel: Pid: 3904, comm: sctpcrash Tainted: G     U 2.6.16.60-0.33-smp #13
>> Dec 18 16:32:47 gw kernel: RIP: 0010:[<ffffffff8824ac0d>] <ffffffff8824ac0d>{:sctp:sctp_packet_transmit+67}
>> Dec 18 16:32:47 gw kernel: RSP: 0018:ffff8101181af818  EFLAGS: 00010246
>> Dec 18 16:32:47 gw kernel: RAX: ffff810119ccfd60 RBX: ffff8101180e6cc0 RCX: 0000000000000020
>> Dec 18 16:32:47 gw kernel: RDX: ffff810119ccfd60 RSI: 0000000000000286 RDI: ffff810119ccfd50
>> Dec 18 16:32:47 gw kernel: RBP: ffff810119ccfc00 R08: 0000000000001f3a R09: 000000000000d400
>> Dec 18 16:32:47 gw kernel: R10: 0000000000000000 R11: ffff81011790d5d0 R12: 0000000000000000
>> Dec 18 16:32:47 gw kernel: R13: ffff810119ccfd50 R14: ffff8101190e15b0 R15: ffff810119ccfd50
>> Dec 18 16:32:47 gw kernel: FS:  00002b301e55b6e0(0000) GS:ffffffff803d4000(0000) knlGS:0000000000000000
>> Dec 18 16:32:47 gw kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Dec 18 16:32:47 gw kernel: CR2: 00002b539596d000 CR3: 000000011ccc0000 CR4: 00000000000006e0
>> Dec 18 16:32:47 gw kernel: Process sctpcrash (pid: 3904, threadinfo ffff8101181ae000, task ffff81012a32a080)
>> Dec 18 16:32:47 gw kernel: Stack: ffff810119ccfd60 ffff810119ccfc00 ffff810119ccfc00 ffff8101190e0000 
>> Dec 18 16:32:47 gw kernel:        ffff810119ccfd50 ffff8101180e6cc0 0000000000000286 ffff8101180e6cc0 
>> Dec 18 16:32:47 gw kernel:        ffff810119ccfc00 ffff8101181af998 
>> Dec 18 16:32:47 gw kernel: Call Trace: <ffffffff88243810>{:sctp:sctp_outq_flush+1524}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8011e49a>{flush_gart+206} <ffffffff8011e31e>{dma_map_area+48}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8011e4e4>{gart_map_simple+63} <ffffffff8823c2a7>{:sctp:sctp_do_sm+3421}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8823f22d>{:sctp:sctp_datamsg_from_user+689}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8824ab05>{:sctp:sctp_primitive_SEND+57} <ffffffff882498ac>{:sctp:sctp_sendmsg+0}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8824a158>{:sctp:sctp_sendmsg+2220} <ffffffff80283a6a>{release_sock+19}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8824a6eb>{:sctp:sctp_recvmsg+1024} <ffffffff8028159b>{sock_sendmsg+251}
>> Dec 18 16:32:47 gw kernel:        <ffffffff80148092>{autoremove_wake_function+0} <ffffffff801fa28c>{sprintf+81}
>> Dec 18 16:32:47 gw kernel:        <ffffffff80281b6f>{sys_sendmsg+523} <ffffffff801ab20e>{inotify_d_instantiate+26}
>> Dec 18 16:32:47 gw kernel:        <ffffffff80184655>{fd_install+46} <ffffffff80283bae>{lock_sock+169}
>> Dec 18 16:32:47 gw kernel:        <ffffffff80283a6a>{release_sock+19} <ffffffff80284e5e>{sock_setsockopt+1230}
>> Dec 18 16:32:47 gw kernel:        <ffffffff8010ae42>{system_call+126}
>> Dec 18 16:32:47 gw kernel: 
>> Dec 18 16:32:47 gw kernel: Code: 0f 0b 68 bf 0a 25 88 c2 60 01 49 8b 45 10 41 8b 7d 28 48 8b 
>>
>>
>> This is the BUG_ON(packet->num_chunks = 0);  in sctp_packet_transmit().
>>
>>
>>
> 
> The two crashes are somewhat consistent.  In both cases, the packet's chunk_list
> is not empty, but num_chunks shows up at 0.
> 
> Additionally, in the first crash, we see the packet size as 32, but the
> allocated skb is 1280 bytes and we have an overflow.
> 
> So, either we have a memory corruption or a race.  I can't figure out how there
> could be a race since the packet is embedded into the sctp_transport structure
> and we have only 1 of those per association.
> 
> I am running a test on 2.6.28-rc6 kernel with my cleaned up patches to see if I
> can trigger this fault.  It used to happen very quickly before my patches.  I am
> not at 2+ hours, but will let run for the rest of the day to see what happens.
> 
> -vlad

At this point, I am starting to think that this is a race, but I am not sure
what/who is racing what/who.

When I add an SCTP level setsockopt call in the accept() loop of the server, I
get 4+ hours of normal operation (I killed the test at this point).  It doesn't
matter what the socket option does.  As a test, I used SCTP_DISABLE_FRAGMENTS
with a value of 0 which is essentially a no-op with locks around it, and it worked.

The few crashes I've received on 2.6.28-rc6 seem to always eminate from
the retransmission timeout.  After poking around the crash dump, I see
the following:

crash> sctp_transport.packet 0xffff88013dd830d8
  packet = {
    source_port = 10003,
    destination_port = 36107,
    vtag = 4043516048,
    chunk_list = {
      next = 0xffff88013c395e80,
      prev = 0xffff88013c395e80
    },
    ...
crash> struct sctp_chunk 0xffff88013c395e80
struct sctp_chunk {
  list = {
    next = 0xffff88013c395e80,
    prev = 0xffff88013c395e80
  },
  refcnt = {
    counter = 2
  },
  transmitted_list = {
    next = 0xffff88013dd83228,
    prev = 0xffff88013dd83228
  },


Note that the transmitted_list is good (it points back to the association).
However, the list{} in the sctp chunk points to itself, while chunk_list in
the packet also points to it.  This results an infinite iteration over the same
chunk while trying to copy it into the transmission skb and triggers the skb
overflow that we BUG() with.

I am going to see if I can poison the chunk->list from the start and see who
dies.

-vlad

p.s.  the crash I am seeing is with locks added around packet->chunk_list
manipulations.


