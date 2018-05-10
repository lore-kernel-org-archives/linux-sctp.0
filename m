From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 10 May 2018 09:51:53 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-Id: <CACT4Y+bJf_MNz9PfrAQOCvf5KtTCP9zGHx_wEpcfDkTPVhm1UA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a114372a6074e6505642b7f72@google.com> <CADvbK_d9Z3OsHnLc2mg-3e=0t6sVFnEVXoDah3nWJrFSyaq+5w@mail.gmail.com>
In-Reply-To: <CADvbK_d9Z3OsHnLc2mg-3e=0t6sVFnEVXoDah3nWJrFSyaq+5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, William Tu <u9012063@gmail.com>, mvohra@vmware.com
Cc: syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Sat, Feb 10, 2018 at 12:17 PM, Xin Long <lucien.xin@gmail.com> wrote:
> On Fri, Feb 2, 2018 at 3:21 AM, syzbot
> <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot hit the following crash on net-next commit
>> b2fe5fa68642860e7de76167c3111623aa0d5de1 (Wed Jan 31 22:31:10 2018 +0000)
>> Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>> Raw console output is attached.
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
>> It will help syzbot understand when the bug is fixed. See footer for
>> details.
>> If you forward the report, please keep this part and the footer.
>>
>> skbuff: skb_over_panic: text:000000004b89f3be len:66136 put:66124
>> head:00000000f255561a data:00000000ccb55e52 tail:0x10310 end:0x6c0
>> dev:<NULL>
> From the raw log, it should be a data chunk.
> But I couldn't see how len:66136 happened?
> considering that frag_point is always smaller than SCTP_MAX_CHUNK_LEN.

William, Meenakshi,

This crash was bisected to:

commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
Author: William Tu <u9012063@gmail.com>
Date:   Tue Aug 22 09:40:28 2017 -0700

    gre: introduce native tunnel support for ERSPAN

bisection log:
https://gist.githubusercontent.com/dvyukov/a9661d43b2b519b91540f7466dbc32c1/raw/8df343224177933c8c398be126bb82be99aa0b4b/gistfile1.txt




>> ------------[ cut here ]------------
>> kernel BUG at net/core/skbuff.c:104!
>> invalid opcode: 0000 [#1] SMP KASAN
>> Dumping ftrace buffer:
>>    (ftrace buffer empty)
>> Modules linked in:
>> CPU: 1 PID: 19738 Comm: syz-executor3 Not tainted 4.15.0+ #219
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> RIP: 0010:skb_panic+0x162/0x1f0 net/core/skbuff.c:100
>> RSP: 0018:ffff8801c1a6e4e8 EFLAGS: 00010286
>> RAX: 000000000000008f RBX: ffff8801d0090000 RCX: 0000000000000000
>> RDX: 000000000000008f RSI: ffffc90003d53000 RDI: ffffed003834dc91
>> RBP: ffff8801c1a6e550 R08: 1ffff1003834dc1f R09: 0000000000000000
>> R10: 0000000000000004 R11: 0000000000000000 R12: ffffffff863fe4e0
>> R13: ffffffff85276640 R14: 000000000001024c R15: ffffffff863fdd20
>> FS:  00007f69cd01b700(0000) GS:ffff8801db500000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000718008 CR3: 00000001c71c7006 CR4: 00000000001606e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  skb_over_panic net/core/skbuff.c:109 [inline]
>>  skb_put+0x18d/0x1d0 net/core/skbuff.c:1695
>>  skb_put_data include/linux/skbuff.h:2049 [inline]
>>  sctp_packet_pack net/sctp/output.c:473 [inline]
>>  sctp_packet_transmit+0x1180/0x3750 net/sctp/output.c:606
>>  sctp_outq_flush+0x121b/0x4060 net/sctp/outqueue.c:1197
>>  sctp_outq_uncork+0x5a/0x70 net/sctp/outqueue.c:776
>>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1807 [inline]
>>  sctp_side_effects net/sctp/sm_sideeffect.c:1210 [inline]
>>  sctp_do_sm+0x4e0/0x6ed0 net/sctp/sm_sideeffect.c:1181
>>  sctp_primitive_SEND+0xa0/0xd0 net/sctp/primitive.c:178
>>  sctp_sendmsg+0x1894/0x35e0 net/sctp/socket.c:2029
>>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:764
>>  sock_sendmsg_nosec net/socket.c:630 [inline]
>>  sock_sendmsg+0xca/0x110 net/socket.c:640
>>  sock_write_iter+0x31a/0x5d0 net/socket.c:909
>>  call_write_iter include/linux/fs.h:1781 [inline]
>>  do_iter_readv_writev+0x55c/0x830 fs/read_write.c:653
>>  do_iter_write+0x154/0x540 fs/read_write.c:932
>>  vfs_writev+0x18a/0x340 fs/read_write.c:977
>>  do_writev+0xfc/0x2a0 fs/read_write.c:1012
>>  SYSC_writev fs/read_write.c:1085 [inline]
>>  SyS_writev+0x27/0x30 fs/read_write.c:1082
>>  entry_SYSCALL_64_fastpath+0x29/0xa0
>> RIP: 0033:0x453299
>> RSP: 002b:00007f69cd01ac58 EFLAGS: 00000212 ORIG_RAX: 0000000000000014
>> RAX: ffffffffffffffda RBX: 000000000071bea0 RCX: 0000000000453299
>> RDX: 0000000000000001 RSI: 0000000020f7ffe0 RDI: 0000000000000013
>> RBP: 00000000000005c5 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006f7b18
>> R13: 00000000ffffffff R14: 00007f69cd01b6d4 R15: 0000000000000000
>> Code: 04 01 84 c0 74 04 3c 03 7e 23 8b 8b 80 00 00 00 41 57 48 c7 c7 60 dd
>> 3f 86 52 56 4c 89 ea 41 50 4c 89 e6 45 89 f0 e8 c6 d7 25 fd <0f> 0b 4c 89 4d
>> b8 4c 89 45 c0 48 89 75 c8 48 89 55 d0 e8 47 53
>> RIP: skb_panic+0x162/0x1f0 net/core/skbuff.c:100 RSP: ffff8801c1a6e4e8
>> ---[ end trace c7cd29819a9b12ab ]---
>>
>>
>> ---
>> This bug is generated by a dumb bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for details.
>> Direct all questions to syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this bug report.
>> If you forgot to add the Reported-by tag, once the fix for this bug is
>> merged
>> into any tree, please reply to this email with:
>> #syz fix: exact-commit-title
>> To mark this as a duplicate of another syzbot report, please reply with:
>> #syz dup: exact-subject-of-another-report
>> If it's a one-off invalid bug report, please reply with:
>> #syz invalid
>> Note: if the crash happens again, it will cause creation of a new bug
>> report.
>> Note: all commands must start from beginning of the line in the email body.
