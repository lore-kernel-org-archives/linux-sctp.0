From: Mike Allport <mwallport@gmail.com>
Date: Thu, 19 Nov 2009 02:10:42 +0000
Subject: KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
Message-Id: <6d9ea0a90911181810n5927e941t402defc29aaeade7@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

This email outlines some kernel panics (oops) we've been getting and
would like to resolve.

My question is, is there a patch or set of patches to the 2.6.14
kernel known to resolve the oops shown in 1) and 2)?

Unfotunately, I don't have the luxury of picking up a more up-rev'ed kernel.


Background of our problem:
----------------------------------------
At the 2.6.14-7 kernel, we were getting the oops shown in 1) and 2)
frequently when running SCTP traffic to our server.

In an effort resolve the oops shown in 1) and 2), we ported over only
the SCTP parts of the official Linux patches up to the 2.6.23 release
found at ftp.kernel.org.  The patching seems to have resolved the oops
in 1) and 2), but introduced another set of oops which don't happen
'often' and are shown in 3) and 4) below.



1)  This is the oops gotten at the 2.6.14-7 kernel that is not patched
in the networking or SCTP areas.  I have found some google hits on the
string at the bottom of this oops "KERNEL:
 assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
net/ipv4/af_inet.c (146)", but no resolutions offered.


atcafs-n0s11:~# Oops: 0000 [#1]
@SMP
@LTT NESTING LEVEL : 0
@Modules linked in: sctp ip_queue iptable_filter ip_tables bonding
loop ohci_hcd i2c_i801 i2c_core ehci_hcd ipmi_watchdog ipmi_si
ipmi_devintf ipmi_msghandler softdog video thermal processor fan
button battery ac
@CPU:    1
@EIP:    0060:[<f89f2e6f>]    Not tainted VLI
@EFLAGS: 00010282   (2.6.14.7-selinux1-WR1.4aq_cgl)
@EIP is at sctp_getsockopt_sctp_status+0x100/0x1de [sctp]
@eax: 00000000   ebx: 000000b0   ecx: 00000000   edx: 00000000
@esi: d5e02000   edi: d64f1640   ebp: d93f2e78   esp: d93f2dac
@ds: 007b   es: 007b   ss: 0068
@Process upis (pid: 4388, threadinfo=D93f2000 task=D8d708d0)
@Stack: 00000000 00000000 87163ef0 d64f1640 00000000 00000001 0000ffff 0000=
0000
@       00200020 00000000 36fc0002 00000000 00000000 00000000 00000000 0000=
0000
@       00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
@Call Trace:
@ [<c0103fad>] show_stack+0x7a/0x90
@ [<c010412b>] show_registers+0x14f/0x1c7
@ [<c010516b>] die+0x11a/0x195
@ [<c042b54b>] do_page_fault+0xa77/0x360d
@ [<c0103cdb>] error_code+0x4f/0x54
@ [<f89f43f5>] sctp_getsockopt+0x1ef/0x2a5 [sctp]
@ [<c03aabb7>] sock_common_getsockopt+0x22/0x2c
@ [<c03a7f6b>] sys_getsockopt+0x49/0x82
@ [<c03a8e22>] sys_socketcall+0xa5a/0xa9b
@ [<c04239c4>] no_syscall_entry_trace+0xb/0xf
@Code: ff ff ff 0f b7 86 9e 00 00 00 66 89 85 54 ff ff ff 0f b7 86 9c
00 00 00 66 89 85 56 ff ff ff 8b 86 8c 13 00 00 89 85 58 ff ff
 ff <8b> 42 30 31 d2
85 c0 74 03 8b 50 7c 8b b5 38 ff ff ff 89 95 5c
@ idr_remove called for idp0 which is not allocated.
@ [<c0103fda>] dump_stack+0x17/0x19
@ [<c029a158>] idr_remove_warning+0x1b/0x1d
@ [<c029a241>] sub_remove+0xe7/0xe9
@ [<c029a266>] idr_remove+0x23/0x87
@ [<f89e8be1>] sctp_association_destroy+0x64/0xa3 [sctp]
@ [<f89e9101>] sctp_association_put+0x19/0x1b [sctp]
@ [<f89e9377>] sctp_assoc_bh_rcv+0xd1/0x105 [sctp]
@ [<f89ed9ce>] sctp_inq_push+0x18/0x1a [sctp]
@ [<f89f6660>] sctp_backlog_rcv+0x11/0x15 [sctp]
@ [<c03aa40b>] __release_sock+0x47/0x6a
@ [<c03aaac8>] release_sock+0x55/0x90
@ [<f89f170d>] sctp_close+0xa6/0x111 [sctp]
@ [<c03efd50>] inet_release+0x37/0x5b
@ [<c03a4ac7>] sock_release+0x4c/0x9f
@ [<c03a6a54>] sock_close+0x21/0x3d
@ [<c017a4cf>] __fput+0x147/0x172
@ [<c017a386>] fput+0x19/0x1b
@ [<c01731fd>] filp_close+0x3c/0x75
@ [<c0173589>] sys_close+0x353/0x7a9
@ [<c04239c4>] no_syscall_entry_trace+0xb/0xf
@KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
net/ipv4/af_inet.c (146)



2)  Below is another oops flaver we've seen logged to the serial port
while running the 2.6.14 kernel (not patched in the network or sctp
areas)

atcafs-n0s6:~# Oops: 0000 [#1]
SMP
LTT NESTING LEVEL : 0
Modules linked in: sctp ip_queue iptable_filter ip_tables bonding loop
ohci_hcd i2c_i801 i2c_core ehci_hcd ipmi_watchdog ipmi_si ipmi_devintf
ipmi_msghandler softdog video thermal processor fan button battery ac
CPU:    1
EIP:    0060:[<f89f2e6f>]    Not tainted VLI
EFLAGS: 00010282   (2.6.14.7-selinux1-WR1.4aq_cgl)
EIP is at sctp_getsockopt_sctp_status+0x100/0x1de [sctp]
eax: 00000000   ebx: 000000b0   ecx: 00000000   edx: 00000000
esi: d8a7c000   edi: d9094940   ebp: d8cbae78   esp: d8cbadac
ds: 007b   es: 007b   ss: 0068
Process upis (pid: 4177, threadinfo=D8cba000 task=D8d53830)
Stack: 00000000 00000000 87180ef0 d9094940 00000000 00000001 0000ffff 00000=
000
       00200020 00000000 72ed0002 00000000 00000000 00000000 00000000 00000=
000
       00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000=
000
Call Trace:
 [<c0103fad>] show_stack+0x7a/0x90
 [<c010412b>] show_registers+0x14f/0x1c7
 [<c010516b>] die+0x11a/0x195
 [<c042b54b>] do_page_fault+0xa77/0x360d
 [<c0103cdb>] error_code+0x4f/0x54
 [<f89f43f5>] sctp_getsockopt+0x1ef/0x2a5 [sctp]
 [<c03aabb7>] sock_common_getsockopt+0x22/0x2c
 [<c03a7f6b>] sys_getsockopt+0x49/0x82
 [<c03a8e22>] sys_socketcall+0xa5a/0xa9b
 [<c04239c4>] no_syscall_entry_trace+0xb/0xf
Code: ff ff ff 0f b7 86 9e 00 00 00 66 89 85 54 ff ff ff 0f b7 86 9c
00 00 00 66 89 85 56 ff ff ff 8b 86 8c 13 00 00 89 85 58 ff ff
ff <8b> 42 30 31 d2 85 c0 74
03 8b 50 7c 8b b5 38 ff ff ff 89 95 5c

atcafs-n0s6:~#




3) after porting SCTP parts of the ftp.kernel.org official patches up
to the 2.6.23 relase to our kernel, we now get these oops...


The follwing oops did not lock up the computer and did stop the
computer from accepting SCTP associations (every association attempt
from a client was answered with an ABORT).


atcafs-n0s5:~# Oops: 0000 [#1]
SMP
LTT NESTING LEVEL : 0
Modules linked in: sctp ip_queue iptable_filter ip_tables bonding loop ohci=
_hcdc
CPU:    1
EIP:    0060:[<f89f8c8c>]    Not tainted VLI
EFLAGS: 00010246   (2.6.14.7-selinux1-WR1.4aq_cgl)
EIP is at sctp_getsockopt_sctp_status+0xe8/0x1f7 [sctp]
eax: 00000000   ebx: 00000000   ecx: 00000000   edx: 00000000
esi: d81d0000   edi: d70cb700   ebp: d896fe78   esp: d896fdac
ds: 007b   es: 007b   ss: 0068
Process upis (pid: 22955, threadinfo=D896f000 task=D8cab5b0)
Stack: 00000000 870f3ed0 000000b0 d70cb700 00000000 00000001 0000ffff 00000=
000
       00200020 00000000 60450002 00000000 00000000 00000000 00000000 00000=
000
       00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000=
000
Call Trace:
[<c0103fad>] show_stack+0x7a/0x90
[<c010412b>] show_registers+0x14f/0x1c7
[<c010516b>] die+0x11a/0x195
[<c042b54b>] do_page_fault+0xa77/0x360d
[<c0103cdb>] error_code+0x4f/0x54
[<f89fa5af>] sctp_getsockopt+0x1ef/0x322 [sctp]
[<c03aabb7>] sock_common_getsockopt+0x22/0x2c
[<c03a7f6b>] sys_getsockopt+0x49/0x82
[<c03a8e22>] sys_socketcall+0xa5a/0xa9b
[<c04239c4>] no_syscall_entry_trace+0xb/0xf
Code: ff ff ff 0f b7 86 9a 00 00 00 66 89 85 54 ff ff ff 0f b7 86 98 00 00 =
00 6



4) Then, after the above oops happened, issue the 'cat
/proc/net/sctp/assocs' on this same computer, now the computer will
lock up after dumping the following oops to the serial port.



atcafs-n0s5:~# cat /proc/net/sctp/assocs


...then the lock up...


ASSOC     SOCK <1>Unable to handle kernel NULL pointer dereference  STY SST=
 STc
printing eip:
T ASSOC-ID TX_QUf89ec250
*pde =3D 00000000
EUE RX_QUEUE UIDOops: 0000 [#2]
SMP
LTT NESTING LEVEL : 0
Modules linked in: sctp ip_queue iptable_filter ip_tables bonding loop ohci=
_hcdc
CPU:    3
INODE LPORT RPOEIP:    0060:[<f89ec250>]    Not tainted VLI
EFLAGS: 00010206   (2.6.14.7-selinux1-WR1.4aq_cgl)
RT LADDRS <-> RAEIP is at sctp_v4_cmp_addr+0x3/0x2f [sctp]
eax: d7824c10   ebx: d7824c00   ecx: d7824c10   edx: 0000005c
DDRS
d8c36000 desi: f8a0a680   edi: d7824c10   ebp: d810bdb0   esp: d810bd88
ds: 007b   es: 007b   ss: 0068
Process cat (pid: 15602, threadinfo=D810b000 task=D6d0b450)
Stack: d810bdb0 f89fd7ea d78f61ae d6e9ea00 d81d0064 0000005c d6e9ea00 d70cb=
700
       00a7f18d d81d0000 d810be0c f89fdc58 d6e9ea00 f8a002e7 d81d0000 d70cb=
700
       00000002 00000001 00000001 0000f425 00000000 00000000 00000000 00000=
000
Call Trace:
[<c0103fad>] show_stack+0x7a/0x908d83700 2   10
[<c010412b>] show_registers+0x14f/0x1c7
[<c010516b>] die+0x11a/0x195
[<c042b54b>] do_page_fault+0xa77/0x360d
[<c0103cdb>] error_code+0x4f/0x54
[<f89fdc58>] 1  6499 1523    sctp_assocs_seq_show+0xf5/0x146 [sctp]
[<c019a8a2>] seq_read+0x1f8/0x28e    0      229
[<c0175187>] vfs_read+0xc4/0x169     0 96474 140
[<c0175812>] sys_read+0x371/0x132c
[<c04239c4>] no_syscall_entry_trace+0xb/0xf
Code: 00 08 8b 40 04 89 e5 5d 89 42 04 b8 08 00 00 00 c3 55 66 c7 00 02 00 =
66 8
01 43211  *10.6.<0>Kernel panic - not syncing: Fatal exception in interrupt
48.5 <-> *62.11.


Thanks,
  Mike Allport
