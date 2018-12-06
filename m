From: Alexander Potapenko <glider@google.com>
Date: Thu, 06 Dec 2018 10:36:08 +0000
Subject: Re: KMSAN: kernel-infoleak in sctp_getsockopt
Message-Id: <CAG_fn=WbOyQ0R35_OhCLjxTTnV7z=u5xnjtm2gXtiSRdHbDz=A@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="000000000000d08802057c581192"
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000311344057c4b6cc3@google.com>
In-Reply-To: <000000000000311344057c4b6cc3@google.com>
To: syzbot+ad5d327e6936a2e284be@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Networking <netdev@vger.kernel.org>, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

--000000000000d08802057c581192
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 5, 2018 at 8:31 PM syzbot
<syzbot+ad5d327e6936a2e284be@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    fffec98ae2a6 net: proper support for CONFIG_GENERIC_CSUM =
o..
> git tree:       https://github.com/google/kmsan.git/master
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12e84a4740000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D56b48b46dafe4=
516
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dad5d327e6936a2e=
284be
> compiler:       clang version 8.0.0 (trunk 343298)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D103cd225400=
000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+ad5d327e6936a2e284be@syzkaller.appspotmail.com
>
> 8021q: adding VLAN 0 to HW filter on device team0
> 8021q: adding VLAN 0 to HW filter on device team0
> 8021q: adding VLAN 0 to HW filter on device team0
> 8021q: adding VLAN 0 to HW filter on device team0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KMSAN: kernel-infoleak in _copy_to_user+0x19a/0x230 lib/usercopy.c:3=
3
> CPU: 1 PID: 8164 Comm: syz-executor2 Not tainted 4.20.0-rc3+ #95
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x32d/0x480 lib/dump_stack.c:113
>   kmsan_report+0x12c/0x290 mm/kmsan/kmsan.c:683
>   kmsan_internal_check_memory+0x32a/0xa50 mm/kmsan/kmsan.c:743
>   kmsan_copy_to_user+0x78/0xd0 mm/kmsan/kmsan_hooks.c:634
>   _copy_to_user+0x19a/0x230 lib/usercopy.c:33
>   copy_to_user include/linux/uaccess.h:183 [inline]
>   sctp_getsockopt_local_addrs net/sctp/socket.c:5998 [inline]
>   sctp_getsockopt+0x15248/0x186f0 net/sctp/socket.c:7477
>   sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2937
>   __sys_getsockopt+0x489/0x550 net/socket.c:1939
>   __do_sys_getsockopt net/socket.c:1950 [inline]
>   __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
>   __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
>   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> RIP: 0033:0x457569
> Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f=
7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f4991886c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000457569
> RDX: 000000000000006d RSI: 0000000000000084 RDI: 0000000000000003
> RBP: 000000000072bf00 R08: 0000000020000140 R09: 0000000000000000
> R10: 0000000020001100 R11: 0000000000000246 R12: 00007f49918876d4
> R13: 00000000004c7d88 R14: 00000000004ce348 R15: 00000000ffffffff
>
> Uninit was stored to memory at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:246 [inline]
>   kmsan_save_stack mm/kmsan/kmsan.c:261 [inline]
>   kmsan_internal_chain_origin+0x13d/0x240 mm/kmsan/kmsan.c:469
>   kmsan_memcpy_memmove_metadata+0x1a9/0xf70 mm/kmsan/kmsan.c:344
>   kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:362
>   __msan_memcpy+0x61/0x70 mm/kmsan/kmsan_instr.c:162
>   sctp_copy_laddrs net/sctp/socket.c:5901 [inline]
>   sctp_getsockopt_local_addrs net/sctp/socket.c:5967 [inline]
>   sctp_getsockopt+0x14f41/0x186f0 net/sctp/socket.c:7477
>   sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2937
>   __sys_getsockopt+0x489/0x550 net/socket.c:1939
>   __do_sys_getsockopt net/socket.c:1950 [inline]
>   __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
>   __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
>   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
>
> Uninit was stored to memory at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:246 [inline]
>   kmsan_save_stack mm/kmsan/kmsan.c:261 [inline]
>   kmsan_internal_chain_origin+0x13d/0x240 mm/kmsan/kmsan.c:469
>   kmsan_memcpy_memmove_metadata+0x1a9/0xf70 mm/kmsan/kmsan.c:344
>   kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:362
>   __msan_memcpy+0x61/0x70 mm/kmsan/kmsan_instr.c:162
>   sctp_copy_laddrs net/sctp/socket.c:5890 [inline]
>   sctp_getsockopt_local_addrs net/sctp/socket.c:5967 [inline]
>   sctp_getsockopt+0x14de8/0x186f0 net/sctp/socket.c:7477
>   sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2937
>   __sys_getsockopt+0x489/0x550 net/socket.c:1939
>   __do_sys_getsockopt net/socket.c:1950 [inline]
>   __se_sys_getsockopt+0xe1/0x100 net/socket.c:1947
>   __x64_sys_getsockopt+0x62/0x80 net/socket.c:1947
>   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
>
> Uninit was created at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:246 [inline]
>   kmsan_internal_poison_shadow+0x6d/0x130 mm/kmsan/kmsan.c:170
>   kmsan_kmalloc+0xa1/0x100 mm/kmsan/kmsan_hooks.c:186
>   __kmalloc+0x14c/0x4d0 mm/slub.c:3825
>   kmalloc include/linux/slab.h:551 [inline]
>   sctp_inet6addr_event+0x60e/0xbd0 net/sctp/ipv6.c:100
>   notifier_call_chain kernel/notifier.c:93 [inline]
>   __atomic_notifier_call_chain kernel/notifier.c:183 [inline]
>   atomic_notifier_call_chain+0x13d/0x240 kernel/notifier.c:193
>   inet6addr_notifier_call_chain+0x76/0x90 net/ipv6/addrconf_core.c:107
>   ipv6_add_addr+0x2597/0x2890 net/ipv6/addrconf.c:1115
>   inet6_addr_add+0xc86/0x1c10 net/ipv6/addrconf.c:2912
>   inet6_rtm_newaddr+0x167e/0x3d20 net/ipv6/addrconf.c:4750
>   rtnetlink_rcv_msg+0x1148/0x1540 net/core/rtnetlink.c:4947
>   netlink_rcv_skb+0x394/0x640 net/netlink/af_netlink.c:2477
>   rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:4965
>   netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
>   netlink_unicast+0x1699/0x1740 net/netlink/af_netlink.c:1336
>   netlink_sendmsg+0x13c7/0x1440 net/netlink/af_netlink.c:1917
>   sock_sendmsg_nosec net/socket.c:621 [inline]
>   sock_sendmsg net/socket.c:631 [inline]
>   ___sys_sendmsg+0xe3b/0x1240 net/socket.c:2116
>   __sys_sendmsg net/socket.c:2154 [inline]
>   __do_sys_sendmsg net/socket.c:2163 [inline]
>   __se_sys_sendmsg+0x305/0x460 net/socket.c:2161
>   __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2161
>   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
>
> Bytes 32-35 of 2100 are uninitialized
> Memory access of size 2100 starts at ffff888185d8b000
> Data copied to user address 0000000020001108
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
When a network device goes up and sctp_inetaddr_event() is called, it
allocates a partially initialized struct sctp_sockaddr_entry to hold
the newly created address.
The attached reproducer can be then used to read up to 8 uninit bytes
for each of the local addresses.
I guess the devices aren't created so often that this can pose any
security risk, but we probably still need to allocate this structure
with __GFP_ZERO.
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/000000000000311344057c4b6cc3%40google.com.
> For more options, visit https://groups.google.com/d/optout.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

--000000000000d08802057c581192
Content-Type: text/x-chdr; charset="US-ASCII"; name="dump_buf.h"
Content-Disposition: attachment; filename="dump_buf.h"
Content-Transfer-Encoding: base64
Content-ID: <f_jpcgtlxx0>
X-Attachment-Id: f_jpcgtlxx0

I2lmbmRlZiBEVU1QX0JVRl9ICiNkZWZpbmUgRFVNUF9CVUZfSAoKI2lmbmRlZiBEVU1QX01JTl9T
VFJMRU4KI2RlZmluZSBEVU1QX01JTl9TVFJMRU4gMQojZW5kaWYKCiNpZm5kZWYgRFVNUF9QQVJB
TExFTAojZGVmaW5lIERVTVBfUEFSQUxMRUwgMAojZW5kaWYKCiNpZm5kZWYgRFVNUF9QUklOVF9C
VUZfQUREUgojZGVmaW5lIERVTVBfUFJJTlRfQlVGX0FERFIgMAojZW5kaWYKCiNpZm5kZWYgRFVN
UF9QUklOVF9IRVgKI2RlZmluZSBEVU1QX1BSSU5UX0hFWCAwCiNlbmRpZgoKI2lmbmRlZiBEVU1Q
X1BSSU5UX1NUUklORwojZGVmaW5lIERVTVBfUFJJTlRfU1RSSU5HIDAKI2VuZGlmCgojaWYgRFVN
UF9QQVJBTExFTApwdGhyZWFkX211dGV4X3Qgb3V0X211dGV4ID0gUFRIUkVBRF9NVVRFWF9JTklU
SUFMSVpFUjsKI2VuZGlmCgp2b2lkIGR1bXBfYnVmKHVuc2lnbmVkIGNoYXIgKmJ1ZiwgaW50IGxl
bikgewogIGludCBpLCBueiA9IDA7CiAgZm9yIChpID0gMDsgaSA8IGxlbjsgaSsrKSB7CiAgICBp
ZiAoYnVmW2ldKSB7CiAgICAgIG56ID0gMTsKICAgICAgYnJlYWs7CiAgICB9CiAgfQogIGlmICgh
bnopIHsKICAgIC8vIFRoZSBidWZmZXIgaXMgZW1wdHkuCiAgICByZXR1cm47CiAgfSBlbHNlIHsK
I2lmIERVTVBfUEFSQUxMRUwKICAgIHB0aHJlYWRfbXV0ZXhfbG9jaygmb3V0X211dGV4KTsKI2Vu
ZGlmCiNpZiBEVU1QX1BSSU5UX0JVRl9BRERSCiAgICBmcHJpbnRmKHN0ZGVyciwgIm5vbmVtcHR5
IGJ1ZmZlciBhdCAlcFxuIiwgYnVmKTsKI2VuZGlmCiNpZiBEVU1QX1BSSU5UX0hFWAogICAgZm9y
IChpPTA7IGkgPCBsZW47IGkrKykgewogICAgICBpZiAoYnVmW2ldKSB7CiAgICAgICAgZnByaW50
ZihzdGRlcnIsICJidWZbJWRdOiAleCAoJXApXG4iLCBpLCBidWZbaV0sICoodm9pZCoqKSZidWZb
aV0pOwogICAgICB9CiAgICB9CiNlbmRpZiAvLyBEVU1QX1BSSU5UX0hFWAojaWYgRFVNUF9QQVJB
TExFTAogICAgcHRocmVhZF9tdXRleF91bmxvY2soJm91dF9tdXRleCk7CiNlbmRpZgogIH0KI2lm
IERVTVBfUEFSQUxMRUwKICBwdGhyZWFkX211dGV4X2xvY2soJm91dF9tdXRleCk7CiNlbmRpZgoj
aWYgRFVNUF9QUklOVF9TVFJJTkcKICBmb3IgKGkgPSAwOyBpIDwgbGVuOyBpKyspIHsKICAgIGlm
IChidWZbaV0pIHsKICAgICAgaW50IHN0cl9sZW4gPSBzdHJsZW4oJmJ1ZltpXSk7CiAgICAgIC8v
IFNob3J0IHN0cmluZyBwaWVjZXMgYXJlIHRvbyBib3JpbmcuCiAgICAgIGlmIChzdHJfbGVuID49
IERVTVBfTUlOX1NUUkxFTikgewogICAgICAgIHVuc2lnbmVkIGNoYXIgKmM7CiAgICAgICAgZm9y
IChjID0gJmJ1ZltpXTsgYyA8ICZidWZbaSArIHN0cl9sZW5dOyBjKyspIHsKICAgICAgICAgIGlm
ICgoKmMgPiAxMjcpIHx8ICgoKmMgPCAzMikgJiYgKCpjICE9IDEwKSAmJiAoKmMgIT0gMTMpKSkg
IHsKICAgICAgICAgICAgKmMgPSAnICc7CiAgICAgICAgICAgIGNvbnRpbnVlOwogICAgICAgICAg
fQogICAgICAgIH0KICAgICAgICAvLyBEdW1wIHRoZSBidWZmZXIuCiAgICAgICAgZnByaW50Zihz
dGRlcnIsICIlc1xuIiwgJmJ1ZltpXSk7CiAgICAgIH0KICAgICAgaSArPSBzdHJfbGVuOwogICAg
fQogIH0KI2VuZGlmIC8vIERVTVBfUFJJTlRfU1RSSU5HCiNpZiBEVU1QX1BBUkFMTEVMCiAgcHRo
cmVhZF9tdXRleF91bmxvY2soJm91dF9tdXRleCk7CiNlbmRpZgp9CgojZW5kaWYK
--000000000000d08802057c581192
Content-Type: text/x-csrc; charset="US-ASCII"; name="getsockopt.c"
Content-Disposition: attachment; filename="getsockopt.c"
Content-Transfer-Encoding: base64
Content-ID: <f_jpcgttur1>
X-Attachment-Id: f_jpcgttur1

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzeXMvdHlw
ZXMuaD4gICAgICAgICAgLyogU2VlIE5PVEVTICovCiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNp
bmNsdWRlIDx1bmlzdGQuaD4KCiNkZWZpbmUgRFVNUF9QQVJBTExFTCAxCiNkZWZpbmUgRFVNUF9Q
UklOVF9CVUZfQUREUiAxCiNkZWZpbmUgRFVNUF9QUklOVF9TVFJJTkcgMQojZGVmaW5lIERVTVBf
UFJJTlRfSEVYIDEKI2luY2x1ZGUgImR1bXBfYnVmLmgiCgp2b2lkICpzZXRzb2Nrb3B0X2ZuKHZv
aWQgKmFyZykgewogIGludCBzb2NrID0gKGludClhcmc7CiAgc3RydWN0IHNvY2thZGRyIGFkZHI7
CiAgbWVtc2V0KCZhZGRyLCAwLCBzaXplb2YoYWRkcikpOwogIGFkZHIuc2FfZmFtaWx5ID0gMjsK
ICBhZGRyLnNhX2RhdGFbMl0gPSAweGFjOwogIGFkZHIuc2FfZGF0YVszXSA9IDB4MTQ7CiAgYWRk
ci5zYV9kYXRhWzRdID0gMHgxNDsKICBzZXRzb2Nrb3B0KHNvY2ssIDB4ODQsIDB4NmUsICZhZGRy
LCAweDEwKTsKfQoKI2RlZmluZSBCVUZMRU4gKDB4MmMyKQp2b2lkICpnZXRzb2Nrb3B0X2ZuKHZv
aWQgKmFyZykgewogIGludCBzb2NrID0gKGludClhcmc7CiAgY2hhciBidWZbQlVGTEVOXTsKICBt
ZW1zZXQoYnVmLCAwLCBCVUZMRU4pOwogIGludCBzb2NrbGVuID0gQlVGTEVOOwogIGdldHNvY2tv
cHQoc29jaywgMHg4NCwgLypTQ1RQX0dFVF9MT0NBTF9BRERSUyovMHg2ZCwgYnVmLCAmc29ja2xl
bik7CiAgZHVtcF9idWYoJihidWZbOF0pLCAzMik7Cn0KCnZvaWQgZG9fd29yayhpbnQgc29jaykg
ewogIHB0aHJlYWRfdCB0MSwgdDI7CiAgZm9yIChpbnQgaSA9IDA7IGkgPCAxMDsgaSsrKSB7CiAg
ICBwdGhyZWFkX2NyZWF0ZSgmdDEsIE5VTEwsIGdldHNvY2tvcHRfZm4sICh2b2lkKilzb2NrKTsK
ICAgIHB0aHJlYWRfY3JlYXRlKCZ0MiwgTlVMTCwgc2V0c29ja29wdF9mbiwgKHZvaWQqKXNvY2sp
OwogICAgdXNsZWVwKDEwMCk7CiAgfQp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltd
KSB7CiAgaW50IHJlczsKICBpbnQgcGlkID0gZm9yaygpOwogIGlmIChwaWQgPT0gMCkgewogICAg
aW50IHNvY2sgPSBzb2NrZXQoMHgyLCAweDEsIDB4ODQpOwogICAgZG9fd29yayhzb2NrKTsKICB9
CiAgc2xlZXAoMTApOwogIHJldHVybiAwOwp9Cg==
--000000000000d08802057c581192--
