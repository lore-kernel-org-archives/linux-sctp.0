From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 05 Nov 2017 10:25:28 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <CADvbK_ekcKS1Jc4-R7bQ7mSCPKGYOhRu0dtwUM+Bg7HSV0NLUA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com>
In-Reply-To: <001a1149c712d56ccc055cc48e37@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Mon, Oct 30, 2017 at 10:36 PM, syzbot
<bot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>
wrote:
> Hello,
>
> syzkaller hit the following crash on
> c69fe407803d4b554b7397fad9598a04717ac255
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
>
>
>
>
> sctp: [Deprecated]: syz-executor0 (pid 12122) Use of struct sctp_assoc_value
> in delayed_ack socket option.
> Use struct sctp_sack_info instead
> skbuff: skb_over_panic: text:ffffffff848208a3 len:213348 put:213008
> head:ffff8801c99c2140 data:ffff8801c99c21f8 tail:0x3421c end:0x7ec0
> dev:<NULL>
'put:213008' is buggy. we need to check strreset_req chunk, that's the
only chunk I could see may exceed SCTP_MAX_CHUNK_LEN.

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3603,6 +3603,9 @@ struct sctp_chunk *sctp_make_strreset_req(
        outlen = (sizeof(outreq) + stream_len) * out;
        inlen = (sizeof(inreq) + stream_len) * in;

+       if (outlen + inlen > SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_chunkhdr))
+               return NULL;
+

> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:105!
> invalid opcode: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 12167 Comm: syz-executor5 Not tainted 4.14.0-rc5+ #100
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> task: ffff8801cd7ba3c0 task.stack: ffff8801c1fc0000
> RIP: 0010:skb_panic+0x15c/0x1f0 net/core/skbuff.c:101
> RSP: 0018:ffff8801c1fc63a8 EFLAGS: 00010286
> RAX: 0000000000000092 RBX: ffff8801a91dc680 RCX: 0000000000000000
> RDX: 0000000000000092 RSI: ffffffff8158d77e RDI: ffffed00383f8c69
> RBP: ffff8801c1fc6410 R08: 0000000000000000 R09: 1ffff100383f8c17
> R10: 000000006d0a2354 R11: ffffffff85b2cc98 R12: ffffffff853bcca0
> R13: ffffffff848208a3 R14: 0000000000034010 R15: ffffffff853bc4e0
> FS:  00007fbe84337700(0000) GS:ffff8801db300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001f68 CR3: 00000001c9045000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  skb_over_panic net/core/skbuff.c:110 [inline]
>  skb_put+0x181/0x1c0 net/core/skbuff.c:1699
>  skb_put_data include/linux/skbuff.h:2047 [inline]
>  sctp_packet_pack net/sctp/output.c:472 [inline]
>  sctp_packet_transmit+0x1183/0x3750 net/sctp/output.c:605
>  sctp_outq_flush+0x1216/0x4050 net/sctp/outqueue.c:1191
>  sctp_outq_uncork+0x5a/0x70 net/sctp/outqueue.c:772
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1822 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1222 [inline]
>  sctp_do_sm+0x50e/0x6a30 net/sctp/sm_sideeffect.c:1193
>  sctp_assoc_bh_rcv+0x283/0x4b0 net/sctp/associola.c:1065
>  sctp_inq_push+0x23b/0x300 net/sctp/inqueue.c:95
>  sctp_backlog_rcv+0x177/0xaa0 net/sctp/input.c:350
>  sk_backlog_rcv include/net/sock.h:912 [inline]
>  __release_sock+0x124/0x360 net/core/sock.c:2266
>  release_sock+0xa4/0x2a0 net/core/sock.c:2778
>  sctp_wait_for_connect+0x346/0x570 net/sctp/socket.c:8099
>  sctp_sendmsg+0x29fd/0x32b0 net/sctp/socket.c:2009
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:763
>  sock_sendmsg_nosec net/socket.c:633 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:643
>  SYSC_sendto+0x352/0x5a0 net/socket.c:1750
>  SyS_sendto+0x40/0x50 net/socket.c:1718
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
> RIP: 0033:0x452869
> RSP: 002b:00007fbe84336be8 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452869
> RDX: 0000000000034000 RSI: 0000000020c9bfff RDI: 0000000000000013
> RBP: 0000000000000000 R08: 0000000020a46000 R09: 000000000000001c
> R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000000
> R13: 0000000000a6f7ff R14: 00007fbe843379c0 R15: 0000000000000000
> Code: 03 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 78 41 57 48 c7 c7 20 c5
> 3b 85 52 56 4c 89 ea 41 50 4c 89 e6 45 89 f0 e8 b9 19 77 fd <0f> 0b 4c 89 4d
> b8 4c 89 45 c0 48 89 75 c8 48 89 55 d0 e8 6d 4b
> RIP: skb_panic+0x15c/0x1f0 net/core/skbuff.c:101 RSP: ffff8801c1fc63a8
> ---[ end trace 6beb4fe15730f020 ]---
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> Once a fix for this bug is committed, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
