From: fblistes@free.fr
Date: Wed, 19 Jul 2017 09:01:31 +0000
Subject: help about a lockup in sctp module
Message-Id: <e4c98fb0210c79e7cce88835b6db7ef6@free.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
In-Reply-To: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

    Hello,

   I'm pursuing with a private e-mail address, to avoid company's footer=20
=E2=80=A6

The whole Oops trace is :

[ 696.611862] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
[ 696.611894] Modules linked in: hmac nfsd auth_rpcgss oid_registry=20
nfs_acl nfs lockd fscache sunrpc vmw_vsock_vmci_transport vsock vmwgfx=20
ttm drm_kms_helper drm vmw_balloon coretemp ppdev evdev i2c_piix4=20
serio_raw pcspkr crc32_pclmul i2c_core aesni_intel aes_x86_64 lrw=20
gf128mul glue_helper ablk_helper cryptd vmw_vmci battery parport_pc=20
parport shpchp processor thermal_sys ac button sctp libcrc32c=20
crc32c_generic loop kkcore(O) autofs4 ext4 crc16 mbcache jbd2 dm_mod=20
sr_mod cdrom sg ata_generic sd_mod crc_t10dif crct10dif_generic=20
crct10dif_pclmul crct10dif_common crc32c_intel psmouse ata_piix libata=20
vmw_pvscsi scsi_mod vmxnet3
[ 696.611925] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G O 3.16.0-4-amd64=20
#1 Debian 3.16.39-1+deb8u2
[ 696.611926] Hardware name: VMware, Inc. VMware Virtual Platform/440BX=20
Desktop Reference Platform, BIOS 6.00 09/21/2015
[ 696.611927] task: ffffffff8181a460 ti: ffffffff81800000 task.ti:=20
ffffffff81800000
[ 696.611928] RIP: 0010:[<ffffffffa01d1c94>] [<ffffffffa01d1c94>]=20
sctp_assoc_update_retran_path+0x54/0xc0 [sctp] <<=3D=3D
[ 696.611937] RSP: 0018:ffff88023fc03c68 EFLAGS: 00000293
[ 696.611938] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX:=20
00000094d3160b1c
[ 696.611939] RDX: 0000000000000001 RSI: ffff8800ba2ae400 RDI:=20
ffff8800ba2ae400
[ 696.611940] RBP: ffff8800bb14c128 R08: ffffffff81610640 R09:=20
0000000000000001
[ 696.611941] R10: 0000000000000003 R11: 0000000000000010 R12:=20
ffff88023fc03bd8
[ 696.611941] R13: ffffffff8151bdbd R14: ffff8800ba2ae400 R15:=20
ffffffff8151dd2b
[ 696.611943] FS: 0000000000000000(0000) GS:ffff88023fc00000(0000)=20
knlGS:0000000000000000
[ 696.611944] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 696.611944] CR2: 00007f873ebc4000 CR3: 00000000ba73f000 CR4:=20
00000000003407f0
[ 696.611986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 696.611986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[ 696.611987] Stack:
[ 696.611988] ffff8800bb14c000 0000000000000000 ffff8802356f9700=20
0000000000000002
[ 696.611990] ffffffffa01d2065 ffff8800bb14c000 ffffffffa01ce521=20
00000000000003ff
[ 696.611991] 0000000100000000 0000000100000001 0000000100000000=20
ffff8800bb14c000
[ 696.611992] Call Trace:
[ 696.611994] <IRQ>
[ 696.611998]
[ 696.612002] [<ffffffffa01d2065>] ?=20
sctp_assoc_choose_alter_transport+0x25/0x40 [sctp]
[ 696.612006] [<ffffffffa01ce521>] ? sctp_do_sm+0x1491/0x1670 [sctp]
[ 696.612011] [<ffffffffa01cea6d>] ?=20
sctp_generate_timeout_event+0xad/0xf0 [sctp]
[ 696.612014] [<ffffffffa01ceaf0>] ?=20
sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[ 696.612019] [<ffffffff81073ea1>] ? call_timer_fn+0x31/0x140
[ 696.612022] [<ffffffffa01ceaf0>] ?=20
sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[ 696.612025] [<ffffffff81075559>] ? run_timer_softirq+0x1e9/0x2f0
[ 696.612026] [<ffffffff8106d911>] ? __do_softirq+0xf1/0x2d0
[ 696.612028] [<ffffffff8106dd25>] ? irq_exit+0x95/0xa0
[ 696.612031] [<ffffffff8151dd30>] ? smp_apic_timer_interrupt+0x40/0x50
[ 696.612035] [<ffffffff8151bdbd>] ? apic_timer_interrupt+0x6d/0x80
[ 696.612035] <EOI>
[ 696.612036]
[ 696.612039] [<ffffffff8101da50>] ? mwait_idle+0xa0/0xa0
[ 696.612043] [<ffffffff81052c22>] ? native_safe_halt+0x2/0x10
[ 696.612045] [<ffffffff8101da69>] ? default_idle+0x19/0xd0
[ 696.612047] [<ffffffff810a9b74>] ? cpu_startup_entry+0x374/0x470
[ 696.612050] [<ffffffff81903076>] ? start_kernel+0x497/0x4a2
[ 696.612051] [<ffffffff81902a04>] ? set_init_arg+0x4e/0x4e
[ 696.612053] [<ffffffff81902120>] ? early_idt_handler_array+0x120/0x120
[ 696.612054] [<ffffffff8190271f>] ? x86_64_start_kernel+0x14d/0x15c
[ 696.612055] Code: 8b 1c 24 49 8d ad 28 01 00 00 31 c0 eb 11 66 0f 1f=20
84 00 00 00 00 00 4c 39 e3 74 25 48 8b 1b 48 39 eb 74 f8 83 bb 1c 01 00=20
00 03 <74> ef 48 89 c6 48 89 df e8 4f ed ff ff 83 b8 1c 01 00 00 02 75
[ 724.633312] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
[ 724.633345] Modules linked in: hmac nfsd auth_rpcgss oid_registry=20
nfs_acl nfs lockd fscache sunrpc vmw_vsock_vmci_transport vsock vmwgfx=20
ttm drm_kms_helper drm vmw_balloon coretemp ppdev evdev i2c_piix4=20
serio_raw pcspkr crc32_pclmul i2c_core aesni_intel aes_x86_64 lrw=20
gf128mul glue_helper ablk_helper cryptd vmw_vmci battery parport_pc=20
parport shpchp processor thermal_sys ac button sctp libcrc32c=20
crc32c_generic loop kkcore(O) autofs4 ext4 crc16 mbcache jbd2 dm_mod=20
sr_mod cdrom sg ata_generic sd_mod crc_t10dif crct10dif_generic=20
crct10dif_pclmul crct10dif_common crc32c_intel psmouse ata_piix libata=20
vmw_pvscsi scsi_mod vmxnet3
[ 724.633376] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G O 3.16.0-4-amd64=20
#1 Debian 3.16.39-1+deb8u2
[ 724.633377] Hardware name: VMware, Inc. VMware Virtual Platform/440BX=20
Desktop Reference Platform, BIOS 6.00 09/21/2015
[ 724.633379] task: ffffffff8181a460 ti: ffffffff81800000 task.ti:=20
ffffffff81800000
[ 724.633380] RIP: 0010:[<ffffffffa01d1c96>] [<ffffffffa01d1c96>]=20
sctp_assoc_update_retran_path+0x56/0xc0 [sctp] <<=3D=3D
[ 724.633388] RSP: 0018:ffff88023fc03c68 EFLAGS: 00000293
[ 724.633389] RAX: ffff8800ba2ae400 RBX: 0000000000000000 RCX:=20
00000094d3160b1c
[ 724.633390] RDX: 0000000000000001 RSI: ffff8800ba2ae400 RDI:=20
ffff8800ba2ae400
[ 724.633391] RBP: ffff8800bb14c128 R08: ffffffff81610640 R09:=20
0000000000000001
[ 724.633391] R10: 0000000000000003 R11: 0000000000000010 R12:=20
ffff88023fc03bd8
[ 724.633392] R13: ffffffff8151bdbd R14: ffff8800ba2ae400 R15:=20
ffffffff8151dd2b
[ 724.633393] FS: 0000000000000000(0000) GS:ffff88023fc00000(0000)=20
knlGS:0000000000000000
[ 724.633394] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 724.633395] CR2: 00007f873ebc4000 CR3: 00000000ba73f000 CR4:=20
00000000003407f0
[ 724.633450] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 724.633451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[ 724.633453] Stack:
[ 724.633454] ffff8800bb14c000 0000000000000000 ffff8802356f9700=20
0000000000000002
[ 724.633456] ffffffffa01d2065 ffff8800bb14c000 ffffffffa01ce521=20
00000000000003ff
[ 724.633458] 0000000100000000 0000000100000001 0000000100000000=20
ffff8800bb14c000
[ 724.633459] Call Trace:
[ 724.633460] <IRQ>
[ 724.633463]
[ 724.633471] [<ffffffffa01d2065>] ?=20
sctp_assoc_choose_alter_transport+0x25/0x40 [sctp]
[ 724.633475] [<ffffffffa01ce521>] ? sctp_do_sm+0x1491/0x1670 [sctp]
[ 724.633479] [<ffffffffa01cea6d>] ?=20
sctp_generate_timeout_event+0xad/0xf0 [sctp]
[ 724.633483] [<ffffffffa01ceaf0>] ?=20
sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[ 724.633487] [<ffffffff81073ea1>] ? call_timer_fn+0x31/0x140
[ 724.633490] [<ffffffffa01ceaf0>] ?=20
sctp_generate_t4_rto_event+0x10/0x10 [sctp]
[ 724.633493] [<ffffffff81075559>] ? run_timer_softirq+0x1e9/0x2f0
[ 724.633494] [<ffffffff8106d911>] ? __do_softirq+0xf1/0x2d0
[ 724.633496] [<ffffffff8106dd25>] ? irq_exit+0x95/0xa0
[ 724.633499] [<ffffffff8151dd30>] ? smp_apic_timer_interrupt+0x40/0x50
[ 724.633502] [<ffffffff8151bdbd>] ? apic_timer_interrupt+0x6d/0x80
[ 724.633503] <EOI>
[ 724.633504]
[ 724.633507] [<ffffffff8101da50>] ? mwait_idle+0xa0/0xa0
[ 724.633510] [<ffffffff81052c22>] ? native_safe_halt+0x2/0x10
[ 724.633511] [<ffffffff8101da69>] ? default_idle+0x19/0xd0
[ 724.633515] [<ffffffff810a9b74>] ? cpu_startup_entry+0x374/0x470
[ 724.633517] [<ffffffff81903076>] ? start_kernel+0x497/0x4a2
[ 724.633518] [<ffffffff81902a04>] ? set_init_arg+0x4e/0x4e
[ 724.633520] [<ffffffff81902120>] ? early_idt_handler_array+0x120/0x120
[ 724.633522] [<ffffffff8190271f>] ? x86_64_start_kernel+0x14d/0x15c
[ 724.633522] Code: 24 49 8d ad 28 01 00 00 31 c0 eb 11 66 0f 1f 84 00=20
00 00 00 00 4c 39 e3 74 25 48 8b 1b 48 39 eb 74 f8 83 bb 1c 01 00 00 03=20
74 ef <48> 89 c6 48 89 df e8 4f ed ff ff 83 b8 1c 01 00 00 02 75 d6 f6


    With regards,
           Fred Boiteux.
