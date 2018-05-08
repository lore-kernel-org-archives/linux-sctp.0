From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 May 2018 17:41:03 +0000
Subject: Re: KASAN: use-after-free Read in sctp_do_sm
Message-Id: <CADvbK_d8O7b9OCfCKGhaaQuBafi6rgkKEQh9Bk7pvZKX3KDKCg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000c10690056bb22ccd@google.com>
In-Reply-To: <000000000000c10690056bb22ccd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Tue, May 8, 2018 at 9:58 PM, syzbot
<syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f142f08bf7ec Fix typo in comment.
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x59ade7800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x1f4b3733894ef79
> dashboard link: https://syzkaller.appspot.com/bug?extid1d898c5f24489db4aa
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com
>
> RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000014
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000015
> R13: 000000000000071e R14: 00000000006feb70 R15: 0000000000000007
> =================================
> BUG: KASAN: use-after-free in sctp_cmd_interpreter
> net/sctp/sm_sideeffect.c:1817 [inline]
> BUG: KASAN: use-after-free in sctp_side_effects
> net/sctp/sm_sideeffect.c:1220 [inline]
> BUG: KASAN: use-after-free in sctp_do_sm+0x6015/0x7160
> net/sctp/sm_sideeffect.c:1191
> Read of size 1 at addr ffff8801c7883cb8 by task syz-executor6/18616
>
> CPU: 1 PID: 18616 Comm: syz-executor6 Not tainted 4.17.0-rc4+ #38
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
>  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1817 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>  sctp_do_sm+0x6015/0x7160 net/sctp/sm_sideeffect.c:1191
>  sctp_assoc_bh_rcv+0x30f/0x520 net/sctp/associola.c:1065
>  sctp_inq_push+0x263/0x320 net/sctp/inqueue.c:95
>  sctp_backlog_rcv+0x192/0xc00 net/sctp/input.c:350
>  sk_backlog_rcv include/net/sock.h:909 [inline]
>  __release_sock+0x12f/0x3a0 net/core/sock.c:2335
>  release_sock+0xa4/0x2b0 net/core/sock.c:2850
>  sctp_sendmsg+0x13cc/0x1d70 net/sctp/socket.c:2128
>  inet_sendmsg+0x19f/0x690 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:629 [inline]
>  sock_sendmsg+0xd5/0x120 net/socket.c:639
>  sock_write_iter+0x35a/0x5a0 net/socket.c:908
>  call_write_iter include/linux/fs.h:1784 [inline]
>  new_sync_write fs/read_write.c:474 [inline]
>  __vfs_write+0x64d/0x960 fs/read_write.c:487
>  vfs_write+0x1f8/0x560 fs/read_write.c:549
>  ksys_write+0xf9/0x250 fs/read_write.c:598
>  __do_sys_write fs/read_write.c:610 [inline]
>  __se_sys_write fs/read_write.c:607 [inline]
>  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x455979
> RSP: 002b:00007f6fad842c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f6fad8436d4 RCX: 0000000000455979
> RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000014
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000015
> R13: 000000000000071e R14: 00000000006feb70 R15: 0000000000000007
>
> Allocated by task 18616:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
>  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
>  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
>  kmem_cache_zalloc include/linux/slab.h:691 [inline]
>  sctp_chunkify+0xce/0x400 net/sctp/sm_make_chunk.c:1355
>  sctp_rcv+0xc65/0x3a60 net/sctp/input.c:221
>  sctp6_rcv+0x15/0x30 net/sctp/ipv6.c:1045
>  ip6_input_finish+0x3ff/0x1a30 net/ipv6/ip6_input.c:284
>  NF_HOOK include/linux/netfilter.h:288 [inline]
>  ip6_input+0xe1/0x5e0 net/ipv6/ip6_input.c:327
>  dst_input include/net/dst.h:450 [inline]
>  ip6_rcv_finish+0x29c/0xa10 net/ipv6/ip6_input.c:71
>  NF_HOOK include/linux/netfilter.h:288 [inline]
>  ipv6_rcv+0xed6/0x22a0 net/ipv6/ip6_input.c:208
>  __netif_receive_skb_core+0x26f5/0x3630 net/core/dev.c:4592
>  __netif_receive_skb+0x2c/0x1e0 net/core/dev.c:4657
>  process_backlog+0x219/0x760 net/core/dev.c:5337
>  napi_poll net/core/dev.c:5735 [inline]
>  net_rx_action+0x7b7/0x1930 net/core/dev.c:5801
>  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:285
>
> Freed by task 18616:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
>  set_track mm/kasan/kasan.c:460 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>  __cache_free mm/slab.c:3498 [inline]
>  kmem_cache_free+0x86/0x2d0 mm/slab.c:3756
>  sctp_chunk_destroy net/sctp/sm_make_chunk.c:1481 [inline]
>  sctp_chunk_put+0x321/0x440 net/sctp/sm_make_chunk.c:1504
>  sctp_ulpevent_make_rcvmsg+0x955/0xd40 net/sctp/ulpevent.c:718
There's no reason to put the chunk in sctp_ulpevent_make_rcvmsg's
fail_mark err path before holding this chunk later there.

We should just remove it.

@@ -715,7 +715,6 @@ struct sctp_ulpevent
*sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
        return event;

 fail_mark:
-       sctp_chunk_put(chunk);
        kfree_skb(skb);
 fail:
        return NULL;

>  sctp_ulpq_tail_data+0xa8/0x12b0 net/sctp/ulpqueue.c:108
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1478 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
>  sctp_do_sm+0x1658/0x7160 net/sctp/sm_sideeffect.c:1191
>  sctp_assoc_bh_rcv+0x30f/0x520 net/sctp/associola.c:1065
>  sctp_inq_push+0x263/0x320 net/sctp/inqueue.c:95
>  sctp_backlog_rcv+0x192/0xc00 net/sctp/input.c:350
>  sk_backlog_rcv include/net/sock.h:909 [inline]
>  __release_sock+0x12f/0x3a0 net/core/sock.c:2335
>  release_sock+0xa4/0x2b0 net/core/sock.c:2850
>  sctp_sendmsg+0x13cc/0x1d70 net/sctp/socket.c:2128
>  inet_sendmsg+0x19f/0x690 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:629 [inline]
>  sock_sendmsg+0xd5/0x120 net/socket.c:639
>  sock_write_iter+0x35a/0x5a0 net/socket.c:908
>  call_write_iter include/linux/fs.h:1784 [inline]
>  new_sync_write fs/read_write.c:474 [inline]
>  __vfs_write+0x64d/0x960 fs/read_write.c:487
>  vfs_write+0x1f8/0x560 fs/read_write.c:549
>  ksys_write+0xf9/0x250 fs/read_write.c:598
>  __do_sys_write fs/read_write.c:610 [inline]
>  __se_sys_write fs/read_write.c:607 [inline]
>  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8801c7883bc0
>  which belongs to the cache sctp_chunk of size 256
> The buggy address is located 248 bytes inside of
>  256-byte region [ffff8801c7883bc0, ffff8801c7883cc0)
> The buggy address belongs to the page:
> page:ffffea00071e20c0 count:1 mapcount:0 mapping:ffff8801c7883080 index:0x0
> flags: 0x2fffc0000000100(slab)
> raw: 02fffc0000000100 ffff8801c7883080 0000000000000000 000000010000000c
> raw: ffffea000723a220 ffff8801cdb66f48 ffff8801cdb65600 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801c7883b80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>  ffff8801c7883c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>
>> ffff8801c7883c80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>
>                                         ^
>  ffff8801c7883d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801c7883d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
