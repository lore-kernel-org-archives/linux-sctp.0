From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 11 Jan 2018 12:40:59 +0000
Subject: Re: general protection fault in sctp_v6_get_dst
Message-Id: <20180111124059.GA15754@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <089e08259d2851dbad05626f6c36@google.com>
 <94eb2c0bd5648167ae0562700241@google.com>
 <CADvbK_eRijUiWD7JNZ33c0KVxOK9bCB0dwfM3epi8j2J26RsQQ@mail.gmail.com>
In-Reply-To: <CADvbK_eRijUiWD7JNZ33c0KVxOK9bCB0dwfM3epi8j2J26RsQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+7b7b518b1228d2743963@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Jan 11, 2018 at 05:30:17PM +0800, Xin Long wrote:
> On Thu, Jan 11, 2018 at 2:15 AM, syzbot
> <syzbot+7b7b518b1228d2743963@syzkaller.appspotmail.com> wrote:
> > syzkaller has found reproducer for the following crash on
> > 61ad64080e039dce99a7f8d89b729bbea995e2f7
> > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> >
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+7b7b518b1228d2743963@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed.
> >
> > device lo entered promiscuous mode
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] SMP KASAN
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > Modules linked in:
> > CPU: 0 PID: 3506 Comm: syzkaller968983 Not tainted 4.15.0-rc7+ #181
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__read_once_size include/linux/compiler.h:183 [inline]
> > RIP: 0010:sctp_v6_get_dst+0x59e/0x1c60 net/sctp/ipv6.c:271
> > RSP: 0018:ffff8801db205e20 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8512e05b
> > RDX: 000000000000000f RSI: 0000000067cf608c RDI: ffff8801db22376c
> > RBP: ffff8801db206190 R08: 1ffff1003b640b05 R09: 0000000000000002
> > R10: ffff8801db205cf0 R11: ffffffff8512e008 R12: ffff8801bf884db0
> > R13: 000000000000204e R14: ffff8801bfe3e680 R15: ffff8801bf884d80
> > FS:  00007f122e219700(0000) GS:ffff8801db200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020aaff09 CR3: 00000001bfdf0005 CR4: 00000000001606f0
> >
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <IRQ>
> >  sctp_transport_route+0xa8/0x430 net/sctp/transport.c:293
> >  sctp_assoc_add_peer+0x4fe/0x1190 net/sctp/associola.c:655
> >  sctp_process_init+0x119/0x2440 net/sctp/sm_make_chunk.c:2341
> >  sctp_sf_do_5_1B_init+0x8c9/0xe80 net/sctp/sm_statefuns.c:414
> >  sctp_do_sm+0x192/0x6ed0 net/sctp/sm_sideeffect.c:1178
> >  sctp_endpoint_bh_rcv+0x379/0x8f0 net/sctp/endpointola.c:456
> >  sctp_inq_push+0x23b/0x300 net/sctp/inqueue.c:95
> >  sctp_rcv+0x29f3/0x35c0 net/sctp/input.c:267
> >  sctp6_rcv+0x15/0x30 net/sctp/ipv6.c:1006
> >  ip6_input_finish+0x37e/0x17a0 net/ipv6/ip6_input.c:284
> >  NF_HOOK include/linux/netfilter.h:288 [inline]
> >  ip6_input+0xdb/0x560 net/ipv6/ip6_input.c:327
> >  dst_input include/net/dst.h:449 [inline]
> >  ip6_rcv_finish+0x1a9/0x7a0 net/ipv6/ip6_input.c:71
> >  NF_HOOK include/linux/netfilter.h:288 [inline]
> >  ipv6_rcv+0xf37/0x1fa0 net/ipv6/ip6_input.c:208
> >  __netif_receive_skb_core+0x1a41/0x3460 net/core/dev.c:4538
> >  __netif_receive_skb+0x2c/0x1b0 net/core/dev.c:4603
> >  process_backlog+0x203/0x740 net/core/dev.c:5283
> >  napi_poll net/core/dev.c:5681 [inline]
> >  net_rx_action+0x792/0x1910 net/core/dev.c:5747
> >  __do_softirq+0x2d7/0xb85 kernel/softirq.c:285
> >  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1133
> >  </IRQ>
> >  do_softirq.part.21+0x14d/0x190 kernel/softirq.c:329
> >  do_softirq kernel/softirq.c:177 [inline]
> >  __local_bh_enable_ip+0x1ee/0x230 kernel/softirq.c:182
> >  local_bh_enable include/linux/bottom_half.h:32 [inline]
> >  rcu_read_unlock_bh include/linux/rcupdate.h:727 [inline]
> >  ip6_finish_output2+0xba0/0x23a0 net/ipv6/ip6_output.c:121
> >  ip6_finish_output+0x698/0xaf0 net/ipv6/ip6_output.c:154
> >  NF_HOOK_COND include/linux/netfilter.h:277 [inline]
> >  ip6_output+0x1eb/0x840 net/ipv6/ip6_output.c:171
> >  dst_output include/net/dst.h:443 [inline]
> >  NF_HOOK include/linux/netfilter.h:288 [inline]
> >  ip6_xmit+0xd84/0x2090 net/ipv6/ip6_output.c:277
> >  sctp_v6_xmit+0x438/0x630 net/sctp/ipv6.c:225
> >  sctp_packet_transmit+0x225e/0x3750 net/sctp/output.c:638
> >  sctp_outq_flush+0xabb/0x4060 net/sctp/outqueue.c:911
> >  sctp_outq_uncork+0x5a/0x70 net/sctp/outqueue.c:776
> >  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1807 [inline]
> >  sctp_side_effects net/sctp/sm_sideeffect.c:1210 [inline]
> >  sctp_do_sm+0x4e0/0x6ed0 net/sctp/sm_sideeffect.c:1181
> >  sctp_primitive_ASSOCIATE+0x9d/0xd0 net/sctp/primitive.c:88
> >  sctp_sendmsg+0x1d2e/0x33f0 net/sctp/socket.c:2018
> >  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:764
> >  sock_sendmsg_nosec net/socket.c:628 [inline]
> >  sock_sendmsg+0xca/0x110 net/socket.c:638
> >  SYSC_sendto+0x361/0x5c0 net/socket.c:1719
> >  SyS_sendto+0x40/0x50 net/socket.c:1687
> >  entry_SYSCALL_64_fastpath+0x23/0x9a
> > RIP: 0033:0x4456c9
> > RSP: 002b:00007f122e218d98 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> > RAX: ffffffffffffffda RBX: 00000000006dac3c RCX: 00000000004456c9
> > RDX: 0000000000000001 RSI: 0000000020aaff09 RDI: 0000000000000007
> > RBP: 0000000000000000 R08: 0000000020abf000 R09: 000000000000001c
> > R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006dac38
> > R13: 0000800000000001 R14: 0100000000000000 R15: 0000000000000008
> > Code: 10 00 00 e8 e5 3d 5d fc 48 8b 85 e8 fc ff ff 48 83 c0 78 48 89 c2 48
> > 89 85 c0 fc ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f
> > 85 e9 15 00 00 48 8b 85 e8 fc ff ff 4c 8d b5 30
> > RIP: __read_once_size include/linux/compiler.h:183 [inline] RSP:
> > ffff8801db205e20
> > RIP: sctp_v6_get_dst+0x59e/0x1c60 net/sctp/ipv6.c:271 RSP: ffff8801db205e20
> > ---[ end trace 63ac71b302800ef4 ]---
> >
> v4 socket shouldn't have been allowed to bind v6 address, even it's v4mapped.
> 
> index de1087d..3595097 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -353,15 +353,14 @@ static struct sctp_af *sctp_sockaddr_af(struct
> sctp_sock *opt,
>         if (len < sizeof (struct sockaddr))
>                 return NULL;
> 
> +       if (!opt->pf->af_supported(addr->sa.sa_family, opt))
> +               return NULL;
> +
>         /* V4 mapped address are really of AF_INET family */
>         if (addr->sa.sa_family = AF_INET6 &&
>             ipv6_addr_v4mapped(&addr->v6.sin6_addr)) {
>                 if (!opt->pf->af_supported(AF_INET, opt))
>                         return NULL;
> -       } else {
> -               /* Does this PF support this AF? */
> -               if (!opt->pf->af_supported(addr->sa.sa_family, opt))
> -                       return NULL;
>         }
> 

This looks reasonable
Acked-by: Neil Horman <nhorman@tuxdriver.com>

