From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Mar 2019 07:20:41 +0000
Subject: Re: KMSAN: kernel-infoleak in sctp_getsockopt (3)
Message-Id: <CADvbK_dckWR9o4497Reh7MONX_XBO7XZgJ9oEb-hsAH4Hjhw0Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000407080058529ff40@google.com> <20190329123025.GB30213@hmswarspite.think-freely.org>
 <CAG_fn=XiNEhWiswHUschD2dma9SfS+eLRU8gXVJnbo7AozomPg@mail.gmail.com>
 <20190329183039.GC30213@hmswarspite.think-freely.org> <CACT4Y+YFjn2bMrd6xpuYV1au-nOnascKy1NXsqKwZr7m5CYHrQ@mail.gmail.com>
In-Reply-To: <CACT4Y+YFjn2bMrd6xpuYV1au-nOnascKy1NXsqKwZr7m5CYHrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Alexander Potapenko <glider@google.com>, syzbot <syzbot+86b5c7c236a22616a72f@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Networking <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladislav Yasevich <vyasevich@gmail.com>

On Sat, Mar 30, 2019 at 2:52 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, Mar 29, 2019 at 7:31 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Fri, Mar 29, 2019 at 06:35:40PM +0100, Alexander Potapenko wrote:
> > > On Fri, Mar 29, 2019 at 3:51 PM Neil Horman <nhorman@tuxdriver.com> w=
rote:
> > > >
> > > > On Thu, Mar 28, 2019 at 09:25:06AM -0700, syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following crash on:
> > > > >
> > > > > HEAD commit:    c10a026b kmsan: use __free_pages() in kmsan_iounm=
ap_page_r..
> > > > > git tree:       kmsan
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=107d3c7=
d200000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=A567581=
4e8eae69e
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=86b5c7c23=
6a22616a72f
> > > > > compiler:       clang version 8.0.0 (trunk 350509)
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12528=
34d200000
> > > > >
> > > > > IMPORTANT: if you fix the bug, please add the following tag to th=
e commit:
> > > > > Reported-by: syzbot+86b5c7c236a22616a72f@syzkaller.appspotmail.com
> > > > >
> > > > > IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_hsr: link becomes ready
> > > > > IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
> > > > > 8021q: adding VLAN 0 to HW filter on device batadv0
> > > > > 8021q: adding VLAN 0 to HW filter on device batadv0
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > BUG: KMSAN: kernel-infoleak in _copy_to_user+0x16b/0x1f0 lib/user=
copy.c:32
> > > > > CPU: 0 PID: 10131 Comm: syz-executor.4 Not tainted 5.0.0+ #16
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS
> > > > > Google 01/01/2011
> > > > > Call Trace:
> > > > >  __dump_stack lib/dump_stack.c:77 [inline]
> > > > >  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
> > > > >  kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:636
> > > > >  kmsan_internal_check_memory+0xaa1/0xbb0 mm/kmsan/kmsan.c:730
> > > > >  kmsan_copy_to_user+0xab/0xc0 mm/kmsan/kmsan_hooks.c:485
> > > > >  _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
> > > > >  copy_to_user include/linux/uaccess.h:174 [inline]
> > > > >  sctp_getsockopt_peer_addrs net/sctp/socket.c:5911 [inline]
> > > > >  sctp_getsockopt+0x1668e/0x17f70 net/sctp/socket.c:7562
> > > > >  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
> > > > >  __sys_getsockopt+0x489/0x550 net/socket.c:1938
> > > > >  __do_sys_getsockopt net/socket.c:1949 [inline]
> > > > >  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1946
> > > > >  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1946
> > > > >  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > > > > RIP: 0033:0x458209
> > > > > Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8=
 48 89 f7
> > > > > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff
> > > > > 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > > > > RSP: 002b:00007fdbef191c78 EFLAGS: 00000246 ORIG_RAX: 00000000000=
00037
> > > > > RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000458209
> > > > > RDX: 000000000000006c RSI: 0000000000000084 RDI: 0000000000000004
> > > > > RBP: 000000000073bf00 R08: 0000000020000300 R09: 0000000000000000
> > > > > R10: 0000000020000280 R11: 0000000000000246 R12: 00007fdbef1926d4
> > > > > R13: 00000000004c96c8 R14: 00000000004d0310 R15: 00000000ffffffff
> > > > >
> > > > > Uninit was stored to memory at:
> > > > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
> > > > >  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
> > > > >  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
> > > > >  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
> > > > >  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
> > > > >  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
> > > > >  sctp_getsockopt_peer_addrs net/sctp/socket.c:5906 [inline]
> > > > >  sctp_getsockopt+0x16556/0x17f70 net/sctp/socket.c:7562
> > > > >  sock_common_getsockopt+0x13f/0x180 net/core/sock.c:2950
> > > > >  __sys_getsockopt+0x489/0x550 net/socket.c:1938
> > > > >  __do_sys_getsockopt net/socket.c:1949 [inline]
> > > > >  __se_sys_getsockopt+0xe1/0x100 net/socket.c:1946
> > > > >  __x64_sys_getsockopt+0x62/0x80 net/socket.c:1946
> > > > >  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > > > >
> > > > > Uninit was stored to memory at:
> > > > >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205 [inline]
> > > > >  kmsan_save_stack mm/kmsan/kmsan.c:220 [inline]
> > > > >  kmsan_internal_chain_origin+0x134/0x230 mm/kmsan/kmsan.c:426
> > > > >  kmsan_memcpy_memmove_metadata+0xb5b/0xfe0 mm/kmsan/kmsan.c:304
> > > > >  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:324
> > > > >  __msan_memcpy+0x58/0x70 mm/kmsan/kmsan_instr.c:139
> > > > >  sctp_transport_init net/sctp/transport.c:61 [inline]
> > > > >  sctp_transport_new+0x16d/0x9a0 net/sctp/transport.c:115
> > > > >  sctp_assoc_add_peer+0x532/0x1f70 net/sctp/associola.c:637
> > > > >  sctp_process_param net/sctp/sm_make_chunk.c:2548 [inline]
> > > > >  sctp_process_init+0x1a1b/0x3ed0 net/sctp/sm_make_chunk.c:2361
> > > > >  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
> > > > >  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]
> > > > >  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > > > >  sctp_do_sm+0x3cfc/0x9af0 net/sctp/sm_sideeffect.c:1191
> > > > >  sctp_assoc_bh_rcv+0x65a/0xd80 net/sctp/associola.c:1074
> > > > >  sctp_inq_push+0x300/0x420 net/sctp/inqueue.c:95
> > > > >  sctp_backlog_rcv+0x20a/0xaf0 net/sctp/input.c:354
> > > > >  sk_backlog_rcv include/net/sock.h:936 [inline]
> > > > >  __release_sock+0x281/0x5f0 net/core/sock.c:2284
> > > > >  release_sock+0x99/0x2a0 net/core/sock.c:2800
> > > > >  sctp_wait_for_connect+0x3ee/0x860 net/sctp/socket.c:8751
> > > > >  sctp_sendmsg_to_asoc+0x2167/0x21a0 net/sctp/socket.c:1967
> > > > >  sctp_sendmsg+0x3fd7/0x6700 net/sctp/socket.c:2113
> > > > >  inet_sendmsg+0x54a/0x720 net/ipv4/af_inet.c:798
> > > > >  sock_sendmsg_nosec net/socket.c:622 [inline]
> > > > >  sock_sendmsg net/socket.c:632 [inline]
> > > > >  ___sys_sendmsg+0xdb9/0x11b0 net/socket.c:2115
> > > > >  __sys_sendmsg net/socket.c:2153 [inline]
> > > > >  __do_sys_sendmsg net/socket.c:2162 [inline]
> > > > >  __se_sys_sendmsg+0x305/0x460 net/socket.c:2160
> > > > >  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2160
> > > > >  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > > > >
> > > > > Local variable description: ----addr.i@sctp_process_init
> > > > > Variable was created at:
> > > > >  sctp_process_init+0xb5/0x3ed0 net/sctp/sm_make_chunk.c:2324
> > > > >  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
> > > > >  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]
> > > > >  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > > > >  sctp_do_sm+0x3cfc/0x9af0 net/sctp/sm_sideeffect.c:1191
> > > > >
> > > > > Bytes 8-15 of 16 are uninitialized
> > > > > Memory access of size 16 starts at ffff88809511fc28
> > > > > Data copied to user address 0000000020000298
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >
> > > > >
> > > > > ---
> > > > > This bug is generated by a bot. It may contain errors.
> > > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > > >
> > > > > syzbot will keep track of this bug report. See:
> > > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > > > syzbot can test patches for this bug, for details see:
> > > > > https://goo.gl/tpsmEJ#testing-patches
> > > > >
> > > > >
> > > >
> > > >
> > > > Hmm, odd.  I see where we are doing the copy_to_user call in
> > > > getsockopt_peer_addrs, but the length we copy should always be equa=
l to or less
> > > > than what was memcopied to the temp variable.  False positive?
> > > I'll take a closer look next week.
> > > The bug is reproducible with the following syzkaller program:
> > >
> > > r0 =3D socket$inet(0x2, 0x80001, 0x84)
> > > bind$inet(r0, &(0x7f0000000080)=3D{0x2, 0x4e20, @empty}, 0x10)
> > > sendmsg(r0, &(0x7f0000000100)=3D{&(0x7f0000006000)=3D@in=3D{0x2, 0x4e=
20,
> > > @loopback}, 0x80, &(0x7f0000007f80)=3D[{&(0x7f00000001c0)=3D"de", 0x1=
}],
> > > 0x1}, 0x0)
> > > getsockopt$inet_sctp_SCTP_GET_PEER_ADDRS(r0, 0x84, 0x6c,
> > > &(0x7f0000000000)=3D{<r5=3D>0x0, 0x38,
> > > "41925f90e4121fadc9c1296dd22ae19d0b1b0942e46fc79e2ecec1056b23199f0ca0=
08915d8dba1b3896c154f2244bbe859fe3423a4b437a"},
> > > &(0x7f0000000040)=3D0x40)
> > >
> > > Just need to check where the uninitializedness comes from.
> > my only guess would be if we somehow copied an ipv4 address worth of da=
ta to the
> > buffer (which contains an enum for both ipv4 and ipv6 addresses), and t=
hen
> > copied an ipv6 address worth of data to userspace,
>
> This seems to partially confirm this:
>
> > Bytes 8-15 of 16 are uninitialized
From the call trace, Uninit memory was stored in 'addr' when processing
SCTP_PARAM_IPV4_ADDRESS in sctp_process_param() by
af->from_addr_param/sctp_v4_from_addr_param, in which
addr->v4.sin_family/port/sin_addr was set, but not addr->v4._pad,
which maches, 8-15 of 16 are uninitialized.

Then it went to sctp_transport_init(), and set the addr directly to
peer->ipaddr and added the new transport into asoc->peer.transport_addr_lis=
t.

When dumping peer_addrs in sctp_getsockopt_peer_addrs():

  memcpy(&temp, &from->ipaddr, sizeof(temp));
  copy_to_user(to, &temp, addrlen),

addrlen is sizeof(struct sockaddr_in), 16 bytes, but only the first 8
bytes were inited.

So we should fix it by setting addr->v4._pad in sctp_v4_addr_to_user as
sctp_v6_addr_to_user does:

@@ -600,6 +600,7 @@ static struct sock
*sctp_v4_create_accept_sk(struct sock *sk,
 static int sctp_v4_addr_to_user(struct sctp_sock *sp, union sctp_addr *add=
r)
 {
        /* No address mapping for V4 sockets */
+       memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
        return sizeof(struct sockaddr_in);
 }


>
> Not 4 bytes are initialized, but still half of the ipv6 addr.
>
>
> > but I don't yet see how that
> > can happen.
>
> The repro says "#{"threaded":true,"collide":true,"repeat":true,"procs":6".
> So I would assume there is a race somewhere.
