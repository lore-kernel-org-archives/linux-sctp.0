From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 09 Dec 2017 11:58:14 +0000
Subject: Re: KASAN: slab-out-of-bounds Read in sctp_send_reset_streams
Message-Id: <CADvbK_c4k23T=UortHm4rFiRirJmwAE1PGaBgn0q+CoVfsdf2w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1140b830592056055fe5ec80@google.com> <CADvbK_d1oFckAyAWUk-UOxZ4nL=315cdochQqcOFnGD13NPMkA@mail.gmail.com>
In-Reply-To: <CADvbK_d1oFckAyAWUk-UOxZ4nL=315cdochQqcOFnGD13NPMkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+0665d43fa62276c7a5e3372929aa0bab96260979@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Sat, Dec 9, 2017 at 7:35 PM, Xin Long <lucien.xin@gmail.com> wrote:
> On Sat, Dec 9, 2017 at 6:40 PM, syzbot
> <bot+0665d43fa62276c7a5e3372929aa0bab96260979@syzkaller.appspotmail.com>
> wrote:
>> Hello,
>>
>> syzkaller hit the following crash on
>> 328b4ed93b69a6f2083d52f31a240a09e5de386a
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached
>> Raw console output is attached.
>> C reproducer is attached
>> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
>> for information about syzkaller reproducers
>>
>>
>> =================================
>> BUG: KASAN: slab-out-of-bounds in sctp_send_reset_streams+0xadf/0xc10
>> net/sctp/stream.c:314
>> Read of size 2 at addr ffff8801d8a6c048 by task syzkaller104411/3085
>>
>> CPU: 0 PID: 3085 Comm: syzkaller104411 Not tainted 4.15.0-rc2+ #119
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:17 [inline]
>>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>>  kasan_report_error mm/kasan/report.c:351 [inline]
>>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>>  __asan_report_load2_noabort+0x14/0x20 mm/kasan/report.c:428
>>  sctp_send_reset_streams+0xadf/0xc10 net/sctp/stream.c:314
>>  sctp_setsockopt_reset_streams net/sctp/socket.c:3905 [inline]
>>  sctp_setsockopt+0x70d/0x5d50 net/sctp/socket.c:4195
>>  compat_sock_common_setsockopt+0x104/0x140 net/core/sock.c:2981
>>  C_SYSC_setsockopt net/compat.c:403 [inline]
>>  compat_SyS_setsockopt+0x17c/0x410 net/compat.c:386
>>  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
>>  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
>>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:125
>> RIP: 0023:0xf7f1bc79
>> RSP: 002b:00000000ff9893bc EFLAGS: 00000282 ORIG_RAX: 000000000000016e
>> RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000000084
>> RDX: 0000000000000077 RSI: 000000002018b000 RDI: 0000000000000008
>> RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>
>> Allocated by task 3085:
>>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>>  set_track mm/kasan/kasan.c:459 [inline]
>>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>>  __do_kmalloc mm/slab.c:3711 [inline]
>>  __kmalloc_track_caller+0x15e/0x760 mm/slab.c:3726
>>  memdup_user+0x2c/0x90 mm/util.c:164
>>  sctp_setsockopt_reset_streams net/sctp/socket.c:3897 [inline]
>>  sctp_setsockopt+0x6a6/0x5d50 net/sctp/socket.c:4195
>>  compat_sock_common_setsockopt+0x104/0x140 net/core/sock.c:2981
>>  C_SYSC_setsockopt net/compat.c:403 [inline]
>>  compat_SyS_setsockopt+0x17c/0x410 net/compat.c:386
>>  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
>>  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
>>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:125
>>
>> Freed by task 16:
>>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>>  set_track mm/kasan/kasan.c:459 [inline]
>>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>>  __cache_free mm/slab.c:3491 [inline]
>>  kfree+0xca/0x250 mm/slab.c:3806
>>  selinux_cred_free+0x48/0x70 security/selinux/hooks.c:3814
>>  security_cred_free+0x48/0x80 security/security.c:995
>>  put_cred_rcu+0x106/0x400 kernel/cred.c:117
>>  __rcu_reclaim kernel/rcu/rcu.h:195 [inline]
>>  rcu_do_batch kernel/rcu/tree.c:2758 [inline]
>>  invoke_rcu_callbacks kernel/rcu/tree.c:3012 [inline]
>>  __rcu_process_callbacks kernel/rcu/tree.c:2979 [inline]
>>  rcu_process_callbacks+0xd74/0x17d0 kernel/rcu/tree.c:2996
>>  __do_softirq+0x29d/0xbb2 kernel/softirq.c:285
>>
>> The buggy address belongs to the object at ffff8801d8a6c040
>>  which belongs to the cache kmalloc-32 of size 32
>> The buggy address is located 8 bytes inside of
>>  32-byte region [ffff8801d8a6c040, ffff8801d8a6c060)
>> The buggy address belongs to the page:
>> page:000000006b05592a count:1 mapcount:0 mapping:000000001ca7267d
>> index:0xffff8801d8a6cfc1
>> flags: 0x2fffc0000000100(slab)
>> raw: 02fffc0000000100 ffff8801d8a6c000 ffff8801d8a6cfc1 000000010000003f
>> raw: ffffea000762f920 ffffea00076133e0 ffff8801db0001c0 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff8801d8a6bf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff8801d8a6bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>
>>> ffff8801d8a6c000: fb fb fb fb fc fc fc fc 00 fc fc fc fc fc fc fc
>>
>>                                               ^
>>  ffff8801d8a6c080: fb fb fb fb fc fc fc fc 00 00 00 00 fc fc fc fc
>>  ffff8801d8a6c100: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>> =================================
>>
>>
>> ---
>> This bug is generated by a dumb bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for details.
>> Direct all questions to syzkaller@googlegroups.com.
>> Please credit me with: Reported-by: syzbot <syzkaller@googlegroups.com>
>>
>> syzbot will keep track of this bug report.
>> Once a fix for this bug is merged into any tree, reply to this email with:
>> #syz fix: exact-commit-title
>> If you want to test a patch for this bug, please reply with:
>> #syz test: git://repo/address.git branch
>> and provide the patch inline or as an attachment.
>> To mark this as a duplicate of another syzbot report, please reply with:
>> #syz dup: exact-subject-of-another-report
>> If it's a one-off invalid bug report, please reply with:
>> #syz invalid
>> Note: if the crash happens again, it will cause creation of a new bug
>> report.
>> Note: all commands must start from beginning of the line in the email body.
> the check:
> if (optlen < sizeof(struct sctp_reset_streams))
> in sctp_setsockopt_reset_streams() is not correct, the srs_stream_list
> memory should have been counted as well.
Fix:

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ac6338f..1532a49 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3930,6 +3930,10 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
        if (IS_ERR(params))
                return PTR_ERR(params);

+       if (params->srs_number_streams * sizeof(__u16) >
+           optlen - sizeof(*params))
+               goto out;
+
