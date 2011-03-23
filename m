From: Jacek Luczak <difrost.kernel@gmail.com>
Date: Wed, 23 Mar 2011 13:25:11 +0000
Subject: sctp 2.6.37 kernel - general protection fault
Message-Id: <AANLkTin4xUzdp89sm5_x0eXpde1NzqCzcKMbxP7YJBN4@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I receive the below attached general protection fault. Details:
1) HW: HP BL460c G6
2) Kernel: 2.6.37
3) Arch: x86_64

System is unusable and does not respond. Currently I'm trying to find
the way to reproduce this issue.

-Jacek

kernel: general protection fault: 0000 [#1] SMP
kernel: last sysfs file:
/sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
kernel: CPU 15
kernel: Modules linked in: hmac sctp nfsd autofs4 ib_iser rdma_cm
ib_cm iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxg
b3i libcxgbi iw_cxgb3 ib_core cxgb3 libiscsi_tcp libiscsi
scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_multipath
battery acpi_pad ac parport usbhi
d evdev power_meter radeon ttm drm_kms_helper drm hwmon ipmi_si
i2c_algo_bit i2c_core ipmi_msghandler psmouse ehci_hcd uhci_hcd
kernel:
kernel: Pid: 19271, comm: k3r.exe Not tainted 2.6.37-2.NSN.kiuas #1
/ProLiant BL460c G6
kernel: RIP: 0010:[<ffffffffa02f3dde>]  [<ffffffffa02f3dde>]
sctp_bind_addr_conflict+0x64/0x82 [sctp]
kernel: RSP: 0018:ffff88030c303c38  EFLAGS: 00010246
kernel: RAX: dead000000100100 RBX: dead000000100100 RCX: ffff880001902640
kernel: RDX: 0000000000000000 RSI: ffff8806010bc150 RDI: ffff8805f85bf1a0
kernel: RBP: ffff8800018c1dc0 R08: 0000000000000001 R09: ffff880604c48080
kernel: R10: ffff8806065daf90 R11: ffff88030c303c98 R12: ffff880ae5292c68
kernel: R13: ffff8806010bc150 R14: ffff880001902640 R15: 0000000000b436b4
kernel: FS:  0000000000000000(0000) GS:ffff8800df2e0000(0063)
knlGS:00000000f76fe6d0
kernel: CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
kernel: CR2: 000000000a43101c CR3: 0000000588ec0000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process k3r.exe (pid: 19271, threadinfo ffff88030c302000, task
ffff88013ab5a160)
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process k3r.exe (pid: 19271, threadinfo ffff88030c302000, task
ffff88013ab5a160)
kernel: Stack:
kernel:  00000000ffffff9d ffff8806010bc140 dead000000100100 ffff880a959aab20
kernel:  ffff8800018c1de8 ffff880942c36b40 ffff8800018c1dc0 ffffffffa02f415f
kernel:  0000000000000000 ffff8806010bc150 0000000000000000 ffffffffa02f3d45
kernel: Call Trace:
kernel:  [<ffffffffa02f415f>] ? sctp_get_port_local+0x17b/0x2a3 [sctp]
kernel:  [<ffffffffa02f3d45>] ? sctp_bind_addr_match+0x33/0x68 [sctp]
kernel:  [<ffffffffa02f4416>] ? sctp_do_bind+0xd3/0x141 [sctp]
kernel:  [<ffffffffa02f5030>] ? sctp_bindx_add+0x4d/0x8e [sctp]
kernel:  [<ffffffffa02f5183>] ? sctp_setsockopt_bindx+0x112/0x4a4 [sctp]
kernel:  [<ffffffff81089e82>] ? generic_file_aio_write+0x7f/0x9b
kernel:  [<ffffffffa02f763e>] ? sctp_setsockopt+0x14f/0xfee [sctp]
kernel:  [<ffffffff810c11fb>] ? do_sync_write+0xab/0xeb
kernel:  [<ffffffff810e82ab>] ? fsnotify+0x239/0x282
kernel:  [<ffffffff810c2462>] ? alloc_file+0x18/0xb1
kernel:  [<ffffffff8134a0b1>] ? compat_sys_setsockopt+0x1a5/0x1d9
kernel:  [<ffffffff8134aaf1>] ? compat_sys_socketcall+0x143/0x1a4
kernel:  [<ffffffff810467dc>] ? sysenter_dispatch+0x7/0x32
b 5c 24 10 <48> 8b 03 0f 18 08 49 8d 44 24 08 48 39 c3 75 c3 48 83 c4 18 89
kernel: RIP  [<ffffffffa02f3dde>] sctp_bind_addr_conflict+0x64/0x82 [sctp]
kernel:  RSP <ffff88030c303c38>
kernel: Kernel panic - not syncing: Fatal exception in interrupt
kernel: Pid: 19271, comm: k3r.exe Tainted: G      D     2.6.37-2.NSN.kiuas #1
kernel: Call Trace:
kernel:  [<ffffffff81053add>] ? panic+0xdc/0x1d7
kernel:  [<ffffffff8102588e>] ? apic_timer_interrupt+0xe/0x20
kernel:  [<ffffffff81054f96>] ? kmsg_dump+0xa9/0x143
kernel:  [<ffffffff810288f7>] ? oops_end+0x86/0x93
kernel:  [<ffffffff813ccaf5>] ? general_protection+0x25/0x30
kernel:  [<ffffffffa02f3dde>] ? sctp_bind_addr_conflict+0x64/0x82 [sctp]
kernel:  [<ffffffffa02f3dcb>] ? sctp_bind_addr_conflict+0x51/0x82 [sctp]
kernel:  [<ffffffffa02f415f>] ? sctp_get_port_local+0x17b/0x2a3 [sctp]
kernel:  [<ffffffffa02f3d45>] ? sctp_bind_addr_match+0x33/0x68 [sctp]
kernel:  [<ffffffffa02f4416>] ? sctp_do_bind+0xd3/0x141 [sctp]
kernel:  [<ffffffffa02f5030>] ? sctp_bindx_add+0x4d/0x8e [sctp]
kernel:  [<ffffffffa02f5183>] ? sctp_setsockopt_bindx+0x112/0x4a4 [sctp]
kernel:  [<ffffffff81089e82>] ? generic_file_aio_write+0x7f/0x9b
kernel:  [<ffffffffa02f763e>] ? sctp_setsockopt+0x14f/0xfee [sctp]
kernel:  [<ffffffff810c11fb>] ? do_sync_write+0xab/0xeb
kernel:  [<ffffffff810e82ab>] ? fsnotify+0x239/0x282
kernel:  [<ffffffff810c2462>] ? alloc_file+0x18/0xb1
kernel:  [<ffffffff8134a0b1>] ? compat_sys_setsockopt+0x1a5/0x1d9
kernel:  [<ffffffff8134aaf1>] ? compat_sys_socketcall+0x143/0x1a4
kernel:  [<ffffffff810467dc>] ? sysenter_dispatch+0x7/0x32
