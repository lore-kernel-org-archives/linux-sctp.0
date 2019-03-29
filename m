From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 29 Mar 2019 14:50:56 +0000
Subject: Re: KMSAN: kernel-infoleak in sctp_getsockopt (3)
Message-Id: <20190329123025.GB30213@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000407080058529ff40@google.com>
In-Reply-To: <000000000000407080058529ff40@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+86b5c7c236a22616a72f@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, glider@google.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Thu, Mar 28, 2019 at 09:25:06AM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    c10a026b kmsan: use __free_pages() in kmsan_iounmap_page_=
r..
> git tree:       kmsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=107d3c7d200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=A5675814e8eae69e
> dashboard link: https://syzkaller.appspot.com/bug?extid=86b5c7c236a22616a=
72f
> compiler:       clang version 8.0.0 (trunk 350509)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1252834d200000
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+86b5c7c236a22616a72f@syzkaller.appspotmail.com
>=20
> IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_hsr: link becomes ready
> IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
> 8021q: adding VLAN 0 to HW filter on device batadv0
> 8021q: adding VLAN 0 to HW filter on device batadv0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KMSAN: kernel-infoleak in _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
> CPU: 0 PID: 10131 Comm: syz-executor.4 Not tainted 5.0.0+ #16
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
>  kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:636
>  kmsan_internal_check_memory+0xaa1/0xbb0 mm/kmsan/kmsan.c:730
>  kmsan_copy_to_user+0xab/0xc0 mm/kmsan/kmsan_hooks.c:485
>  _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
>  copy_to_user include/linux/uaccess.h:174 [inline]
>  sctp_getsockopt_peer_addrs net/sctp/socket.c:5911 [inline]
>  sctp_getsockopt+0x1668e/0x17f70 net/sctp/socket.c:7562
>  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
>  __sys_getsockopt+0x489/0x550 net/socket.c:1938
>  __do_sys_getsockopt net/socket.c:1949 [inline]
>  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1946
>  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1946
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> RIP: 0033:0x458209
> Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff
> 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fdbef191c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000458209
> RDX: 000000000000006c RSI: 0000000000000084 RDI: 0000000000000004
> RBP: 000000000073bf00 R08: 0000000020000300 R09: 0000000000000000
> R10: 0000000020000280 R11: 0000000000000246 R12: 00007fdbef1926d4
> R13: 00000000004c96c8 R14: 00000000004d0310 R15: 00000000ffffffff
>=20
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
>  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
>  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
>  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
>  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
>  sctp_getsockopt_peer_addrs net/sctp/socket.c:5906 [inline]
>  sctp_getsockopt+0x16556/0x17f70 net/sctp/socket.c:7562
>  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
>  __sys_getsockopt+0x489/0x550 net/socket.c:1938
>  __do_sys_getsockopt net/socket.c:1949 [inline]
>  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1946
>  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1946
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
>=20
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
>  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
>  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
>  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
>  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
>  sctp_transport_init net/sctp/transport.c:61 [inline]
>  sctp_transport_new+0x16d/0x9a0 net/sctp/transport.c:115
>  sctp_assoc_add_peer+0x532/0x1f70 net/sctp/associola.c:637
>  sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
>  sctp_process_init+0x1a1b/0x3ed0 net/sctp/sm_make_chunk.c:2361
>  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>  sctp_do_sm+0x3cfc/0x9af0 net/sctp/sm_sideeffect.c:1191
>  sctp_assoc_bh_rcv+0x65a/0xd80 net/sctp/associola.c:1074
>  sctp_inq_push+0x300/0x420 net/sctp/inqueue.c:95
>  sctp_backlog_rcv+0x20a/0xaf0 net/sctp/input.c:354
>  sk_backlog_rcv include/net/sock.h:936 [inline]
>  __release_sock+0x281/0x5f0 net/core/sock.c:2284
>  release_sock+0x99/0x2a0 net/core/sock.c:2800
>  sctp_wait_for_connect+0x3ee/0x860 net/sctp/socket.c:8751
>  sctp_sendmsg_to_asoc+0x2167/0x21a0 net/sctp/socket.c:1967
>  sctp_sendmsg+0x3fd7/0x6700 net/sctp/socket.c:2113
>  inet_sendmsg+0x54a/0x720 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:622 [inline]
>  sock_sendmsg net/socket.c:632 [inline]
>  ___sys_sendmsg+0xdb9/0x11b0 net/socket.c:2115
>  __sys_sendmsg net/socket.c:2153 [inline]
>  __do_sys_sendmsg net/socket.c:2162 [inline]
>  __se_sys_sendmsg+0x305/0x460 net/socket.c:2160
>  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2160
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
>=20
> Local variable description: ----addr.i@sctp_process_init
> Variable was created at:
>  sctp_process_init+0xb5/0x3ed0 net/sctp/sm_make_chunk.c:2324
>  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>  sctp_do_sm+0x3cfc/0x9af0 net/sctp/sm_sideeffect.c:1191
>=20
> Bytes 8-15 of 16 are uninitialized
> Memory access of size 16 starts at ffff88809511fc28
> Data copied to user address 0000000020000298
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>=20
>=20


Hmm, odd.  I see where we are doing the copy_to_user call in
getsockopt_peer_addrs, but the length we copy should always be equal to or =
less
than what was memcopied to the temp variable.  False positive?

Neil
