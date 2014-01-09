From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 09 Jan 2014 12:42:46 +0000
Subject: Re: NULL pointer dereference at @sctp_unhash_established+0x6e/0xb6 [sctp]
Message-Id: <20140109124246.GD16701@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1C24E2A22F3B0C4CAC3C670E0EF37E7203E6B470@G5W2734.americas.hpqcorp.net>
In-Reply-To: <1C24E2A22F3B0C4CAC3C670E0EF37E7203E6B470@G5W2734.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jan 09, 2014 at 07:23:33AM +0000, Arankal, Nagaraj P wrote:
> Hi All,
> I have updated my 2.6.32 based debian kernel with recent SCTP security patch i.e cve-2013-2206.
> It looks like patch may have Introduced Kernel Null deref in function sctp_unhash_established.
> During my regression testing, Kernel generated Call Trace on the console and went for reboot.
> 
> Following are the call trace
> 
You'll need to take this up with the Debian maintainers to figure out whats
going on, although commit 2eebc1e188e9e45886ee00662519849339884d6d may fix your
problem.
Neil

> start_sctp_servers -n 10
> w2moto1-0.cooper.telco -> [ 8180.001473] BUG: unable to handle kernel NULL pointer dereference at (null)
> [ 8180.003053] IP: [<ffffffffa029d0fe>] sctp_unhash_established+0x6e/0xb6 [sctp]
> [ 8180.004871] PGD 316a8d067 PUD 31af11067 PMD 0 
> [ 8180.006005] Thread overran stack, or stack corrupted
> [ 8180.007270] Oops: 0002 #1 SMP 
> [ 8180.008100] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> [ 8180.010151] CPU 0 
> [ 8180.010628] Modules linked in: ipmi_devintf nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc sctp ipv6 crc32c libcrc32c loop ipmi_si tpm_tis hpilo serio_raw ipmi_msghandler tpm tpm_bios psmouse container processor evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod usbhid cdrom hid ide_pci_generic ide_core ata_generic ata_piix libata ehci_hcd uhci_hcd bnx2 igb dca cciss scsi_mod button thermal fan thermal_sys edd [last unloaded: scsi_wait_scan]
> [ 8180.020777] Pid: 0, comm: swapper Not tainted 2.6.32-cdma-29-amd64 #1 ProLiant? DL380 G6
> [ 8180.022839] RIP: 0010:[<ffffffffa029d0fe>] [<ffffffffa029d0fe>] sctp_unhash_established+0x6e/0xb6 [sctp]
> [ 8180.025366] RSP: 0018:ffff880033003840 EFLAGS: 00010246
> [ 8180.026656] RAX: 0000000000000000 RBX: ffff88031c9b7fd0 RCX: ffff8800330038d0
> [ 8180.028557] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88031c9b7fd0
> [ 8180.030672] RBP: ffff880033003860 R08: ffff8800330038b0 R09: 000000004bab6cfd
> [ 8180.032444] R10: 00000000d1e26bff R11: 000000001ad7175e R12: ffff880310fb1000
> [ 8180.034214] R13: ffff8803116765c0 R14: ffff880310fb1000 R15: ffffffff813e5fd8
> [ 8180.035993] FS: 0000000000000000(0000) GS:ffff880033000000(0000) knlGS:0000000000000000
> [ 8180.038038] CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [ 8180.039582] CR2: 0000000000000000 CR3: 0000000313f0d000 CR4: 00000000000006f0
> [ 8180.041423] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 8180.043368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 8180.045013] Process swapper (pid: 0, threadinfo ffffffff813e4000, task ffffffff814224b0)
> [ 8180.046994] Stack:
> [ 8180.047460] ffff8803162e7000 ffff8800330038b0 ffff8800330038d0 ffff8803116765c0
> [ 8180.049033] <0> ffff8800330039e0 ffffffffa0289674 0000000000000000 0000000000000000
> [ 8180.050935] <0> 0000000000000000 ffff88031762da00 0000000400000000 000000010000000a
> [ 8180.052881] Call Trace:
> [ 8180.053529] <IRQ> 
> [ 8180.054122] [<ffffffffa0289674>] sctp_do_sm+0x162/0x1047 [sctp]
> [ 8180.055656] [<ffffffffa028d8e3>] sctp_assoc_bh_rcv+0xf2/0x133 [sctp]
> [ 8180.057278] [<ffffffffa02926de>] sctp_inq_push+0x37/0x39 [sctp]
> [ 8180.058812] [<ffffffffa029e1cc>] sctp_rcv+0x880/0x91c [sctp]
> [ 8180.060263] [<ffffffff8128f4bd>] ? tcp_rcv_established+0x7c8/0xae0
> [ 8180.061864] [<ffffffff81265795>] ? fib_rules_lookup+0x92/0xcd
> [ 8180.063347] [<ffffffffa02a032d>] sctp6_rcv+0x9/0x12 [sctp]
> [ 8180.064777] [<ffffffffa0235736>] ip6_input_finish+0x226/0x3cf [ipv6]
> [ 8180.066451] [<ffffffffa023592c>] ip6_input+0x4d/0x51 [ipv6]
> [ 8180.067890] [<ffffffffa0235f49>] ipv6_rcv+0x3c1/0x418 [ipv6]
> [ 8180.069339] [<ffffffff81256929>] netif_receive_skb+0x470/0x495
> [ 8180.070919] [<ffffffffa00a206c>] bnx2_poll_work+0x107e/0x11c9 [bnx2]
> [ 8180.072639] [<ffffffff81256929>] ? netif_receive_skb+0x470/0x495
> [ 8180.074316] [<ffffffff81256b48>] ? napi_gro_complete+0x95/0xad
> [ 8180.075846] [<ffffffffa007aa0c>] ? igb_ring_irq_enable+0x81/0x252 [igb]
> [ 8180.077592] [<ffffffffa00804cb>] ? igb_poll+0x8e7/0x8ff [igb]
> [ 8180.079107] [<ffffffff810100c0>] ? mask_and_ack_8259A+0xcc/0xdc
> [ 8180.080806] [<ffffffffa00a21ea>] bnx2_poll_msix+0x33/0xb5 [bnx2]
> [ 8180.082470] [<ffffffff8106c71d>] ? clockevents_program_event+0x73/0x7c
> [ 8180.084233] [<ffffffff81257011>] net_rx_action+0xb8/0x1e3
> [ 8180.085694] [<ffffffff810501b4>] do_softirq+0xde/0x1a6
> [ 8180.087061] [<ffffffff8100ccec>] call_softirq+0x1c/0x28
> [ 8180.088343] [<ffffffff8100e8b1>] do_softirq+0x41/0x81
> [ 8180.089799] [<ffffffff8104ff90>] irq_exit+0x36/0x75
> [ 8180.091175] [<ffffffff8100dfa5>] do_IRQ+0xa3/0xba
> [ 8180.092363] [<ffffffff8100c513>] ret_from_intr+0x0/0x11
> [ 8180.093770] <EOI> 
> [ 8180.094310] [<ffffffffa01dc346>] ? acpi_idle_enter_c1+0xf7/0x115 [processor]
> [ 8180.096099] [<ffffffffa01dc324>] ? acpi_idle_enter_c1+0xd5/0x115 [processor]
> [ 8180.097916] [<ffffffff812402ce>] ? cpuidle_idle_call+0x9b/0xf9
> [ 8180.099532] [<ffffffff8100af06>] ? cpu_idle+0x5b/0x93
> [ 8180.100780] [<ffffffff812c660e>] ? rest_init+0x72/0x74
> [ 8180.101975] [<ffffffff81499cae>] ? start_kernel+0x38d/0x398
> [ 8180.103407] [<ffffffff81499140>] ? early_idt_handler+0x0/0x71
> [ 8180.104946] [<ffffffff814992a3>] ? x86_64_start_reservations+0xaa/0xae
> [ 8180.106882] [<ffffffff8149939e>] ? x86_64_start_kernel+0xf7/0x106
> [ 8180.108510] Code: ff c8 21 c2 48 63 da 41 89 54 24 10 48 c1 e3 04 48 03 1d 3e 95 00 00 48 89 df e8 c3 b6 03 e1 49 8b 04 24 49 8b 54 24 08 48 85 c0 <48> 89 02 74 04 48 89 50 08 f0 81 03 00 00 00 01 49 8b 9c 24 40 
> [ 8180.113513] RIP [<ffffffffa029d0fe>] sctp_unhash_established+0x6e/0xb6 [sctp]
> [ 8180.115198] RSP <ffff880033003840>
> [ 8180.115993] CR2: 0000000000000000
> [ 0.000000] Initializing cgroup subsys cpuset
> [ 0.000000] Initializing cgroup subsys cpu
> 
> Note: 
> Core hasn't created.
> 
> Thanks,
> Nagaraj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
