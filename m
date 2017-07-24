From: hellskitchen@free.fr
Date: Mon, 24 Jul 2017 15:54:32 +0000
Subject: Re: help about a lockup in sctp module
Message-Id: <294651707.149863189.1500911672514.JavaMail.root@zimbra50-e8.priv.proxad.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
In-Reply-To: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi,

I work with Frederic on that issue.

We could produce another Oops trace and inspected the core dump related:

[  864.740652] BUG: soft lockup - CPU#0 stuck for 23s! [swapper/0:0]
[  864.740677] Modules linked in: hmac nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc vmw_vsock_vmci_transport vsock vmwgfx ttm drm_kms_helper drm vmw_balloon coretemp ppdev evdev i2c_piix4 serio_raw pcspkr crc32_pclmul i2c_core aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd vmw_vmci battery parport_pc parport shpchp processor thermal_sys ac button sctp libcrc32c crc32c_generic loop kkcore(O) autofs4 ext4 crc16 mbcache jbd2 dm_mod sr_mod cdrom sg ata_generic sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common crc32c_intel psmouse ata_piix libata vmw_pvscsi scsi_mod vmxnet3
[  864.740710] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O  3.16.0-4-amd64 #1 Debian 3.16.39-1+deb8u2
[  864.740711] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/21/2015
[  864.740712] task: ffffffff8181a460 ti: ffffffff81800000 task.ti: ffffffff81800000
[  864.740714] RIP: 0010:[<ffffffffa01d1ca8>]  [<ffffffffa01d1ca8>] sctp_assoc_update_retran_path+0x68/0xc0 [sctp]
[  864.740722] RSP: 0018:ffff88023fc03c68  EFLAGS: 00000297
[  864.740723] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX: 00000094d3160b1c
[  864.740724] RDX: 0000000000000001 RSI: ffff8800ba2ae400 RDI: ffff8800ba2ae400
[  864.740725] RBP: ffff8800bb14c128 R08: ffffffff81610640 R09: 0000000000000001
[  864.740725] R10: 0000000000000003 R11: 0000000000000010 R12: ffff88023fc03bd8
[  864.740726] R13: ffffffff8151bdbd R14: ffff8800ba2ae400 R15: ffffffff8151dd2b
[  864.740727] FS:  0000000000000000(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
[  864.740728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  864.740729] CR2: 00007f873ebc4000 CR3: 00000000ba73f000 CR4: 00000000003407f0
[  864.740733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  864.740734] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  864.740734] Stack:
[  864.740735]  ffff8800bb14c000 0000000000000000 ffff8802356f9700 0000000000000002
[  864.740737]  ffffffffa01d2065 ffff8800bb14c000 ffffffffa01ce521 00000000000003ff
[  864.740738]  0000000100000000 0000000100000001 0000000100000000 ffff8800bb14c000
[  864.740739] Call Trace:
[  864.740740]  <IRQ> 
[  864.740742] 
[  864.740746]  [<ffffffffa01d2065>] ? sctp_assoc_choose_alter_transport+0x25/0x40 [sctp]
[  864.740750]  [<ffffffffa01ce521>] ? sctp_do_sm+0x1491/0x1670 [sctp]
[  864.740755]  [<ffffffffa01cea6d>] ? sctp_generate_timeout_event+0xad/0xf0 [sctp]
[  864.740758]  [<ffffffffa01ceaf0>] ? sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[  864.740762]  [<ffffffff81073ea1>] ? call_timer_fn+0x31/0x140
[  864.740766]  [<ffffffffa01ceaf0>] ? sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[  864.740777]  [<ffffffff81075559>] ? run_timer_softirq+0x1e9/0x2f0
[  864.740779]  [<ffffffff8106d911>] ? __do_softirq+0xf1/0x2d0
[  864.740780]  [<ffffffff8106dd25>] ? irq_exit+0x95/0xa0
[  864.740783]  [<ffffffff8151dd30>] ? smp_apic_timer_interrupt+0x40/0x50
[  864.740786]  [<ffffffff8151bdbd>] ? apic_timer_interrupt+0x6d/0x80
[  864.740787]  <EOI> 
[  864.740787] 
[  864.740791]  [<ffffffff8101da50>] ? mwait_idle+0xa0/0xa0
[  864.740794]  [<ffffffff81052c22>] ? native_safe_halt+0x2/0x10
[  864.740796]  [<ffffffff8101da69>] ? default_idle+0x19/0xd0
[  864.740799]  [<ffffffff810a9b74>] ? cpu_startup_entry+0x374/0x470
[  864.740801]  [<ffffffff81903076>] ? start_kernel+0x497/0x4a2
[  864.740802]  [<ffffffff81902a04>] ? set_init_arg+0x4e/0x4e
[  864.740804]  [<ffffffff81902120>] ? early_idt_handler_array+0x120/0x120
[  864.740806]  [<ffffffff8190271f>] ? x86_64_start_kernel+0x14d/0x15c
[  864.740806] Code: 00 00 00 4c 39 e3 74 25 48 8b 1b 48 39 eb 74 f8 83 bb 1c 01 00 00 03 74 ef 48 89 c6 48 89 df e8 4f ed ff ff 83 b8 1c 01 00 00 02 <75> d6 f6 05 c1 5b 03 00 04 49 89 85 70 01 00 00 75 14 5b 5d 41

At the moment of the crash the RIP register points to 

[  864.740714] RIP: 0010:[<ffffffffa01d1ca8>]  [<ffffffffa01d1ca8>] sctp_assoc_update_retran_path+0x68/0xc0 [sctp]

In this function at offset 0x68 we find:

0xffffffffa01d1c9c <sctp_assoc_update_retran_path+0x5c>:        callq  0xffffffffa01d09f0 <sctp_trans_elect_best>
0xffffffffa01d1ca1 <sctp_assoc_update_retran_path+0x61>:        cmpl   $0x2,0x11c(%rax)
0xffffffffa01d1ca8 <sctp_assoc_update_retran_path+0x68>:        jne    0xffffffffa01d1c80

Because it arrives after a call to sctp_trans_elect_best and a compare with the integer 2, this matches with that lines in c:

1287                 trans_next = sctp_trans_elect_best(trans, trans_next);
1288                 /* Active is good enough for immediate return. */
1289                 if (trans_next->state = SCTP_ACTIVE)
1290                         break;

(SCTP_ACTIVE = 2).

This also means that RAX has a pointer to the last sctp_transport structure evaluated before the crash:

[  864.740723] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX: 00000094d3160b1c

The struct itself contains a pointer to its association :

crash> struct sctp_transport.asoc ffff8800ba2ae400
  asoc = 0xffff8800bb14c000

And the association has these interesting fields:

peer.transport_count = 2
peer.primary_path = 0xffff880232a14c00
peer.active_path = 0xffff8800ba2ae400 
peer.retran_path = 0xffff880232a14c00

So we have two transports (0xffff880232a14c00 and 0xffff8800ba2ae400) and their state is:

crash> struct sctp_transport.state 0xffff880232a14c00
  state = 3 (SCTP_UNCONFIRMED: already down before init)
crash> struct sctp_transport.state 0xffff8800ba2ae400 
  state = 1 (SCTP_PF:  brought down on purpose after init for testing)

Moreover here is the assoc state before the crash:

state = SCTP_STATE_SHUTDOWN_SENT
shutdown_last_sent_to = 0xffff880232a14c00
init_last_sent_to = 0xffff8800ba2ae400
shutdown_retries = 2

It seems we have tried to send a SHUTDOWN to the retran_path (in UNCONFIRMED state) and retried.

So when we arrive in function sctp_assoc_update_retran_path, our retran_path will never be evaluated because of  line 1285. 

1285                 if (trans->state = SCTP_UNCONFIRMED)
1286                         continue;

And when we call sctp_trans_elect_best at line 1287 will always be called either with trans = active_path and trans_next = NULL or trans = active_path and trans_next = active_path so that it will always return active_path.

1287                 trans_next = sctp_trans_elect_best(trans, trans_next);

This line will never match 

1292                 if (trans = asoc->peer.retran_path)

Because trans will always equal active_path. We are in an infinite loop.

1264 void sctp_assoc_update_retran_path(struct sctp_association *asoc)
1265 {
1266         struct sctp_transport *trans = asoc->peer.retran_path;
1267         struct sctp_transport *trans_next = NULL;
1268 
1269         /* We're done as we only have the one and only path. */
1270         if (asoc->peer.transport_count = 1)
1271                 return;
1272         /* If active_path and retran_path are the same and active,
1273          * then this is the only active path. Use it.
1274          */
1275         if (asoc->peer.active_path = asoc->peer.retran_path &&
1276             asoc->peer.active_path->state = SCTP_ACTIVE)
1277                 return;
1278 
1279         /* Iterate from retran_path's successor back to retran_path. */
1280         for (trans = list_next_entry(trans, transports); 1;
1281              trans = list_next_entry(trans, transports)) {
1282                 /* Manually skip the head element. */
1283                 if (&trans->transports = &asoc->peer.transport_addr_list)
1284                         continue;
1285                 if (trans->state = SCTP_UNCONFIRMED)
1286                         continue;
1287                 trans_next = sctp_trans_elect_best(trans, trans_next);
1288                 /* Active is good enough for immediate return. */
1289                 if (trans_next->state = SCTP_ACTIVE)
1290                         break;
1291                 /* We've reached the end, time to update path. */
1292                 if (trans = asoc->peer.retran_path)
1293                         break;
1294         }
1295 
1296         asoc->peer.retran_path = trans_next;
1297 
1298         pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
1299                  __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
1300 }

The real problem here comes from the fact that the retran_path is in state SCTP_UNCONFIRMED. We believe it has been put here because it is also the primary_path (forced with ASCONF).
When we don’t force that SCTP_UNCONFIRMED path (always down during the connection)  to be primary from socket interface we don’t have any problem and we see that  retran_path = active_path instead of primary_path. So we are going to try this alternative as a patch.

We also noticed that sctp_select_active_and_retran_path have changed from commit aa4a83ee8bbc08342c4acfd59ef234cac51a1eef. We applied the changes manually and this also solves our issue because primary_path is not copied to retran_path anymore but unfortunately the change is not ported to our kernel version in use.
We will ask the Debian community if they can backport the changes of commit aa4a83ee8bbc08342c4acfd59ef234cac51a1eef to Debian 8.

Best regards.
Jonathan.
