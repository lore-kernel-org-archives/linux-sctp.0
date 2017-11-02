From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 02 Nov 2017 12:07:27 +0000
Subject: Re: KASAN: use-after-free Read in sctp_association_free
Message-Id: <CADvbK_fyuKe4ehMD_Jb=5UMF8FpfEuiCG6-FEzBiM-r=FX_Y-Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a114a7bc0111534055cef92a3@google.com>
In-Reply-To: <001a114a7bc0111534055cef92a3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+df9412138a14678abd73a2b70a57241f63563ed1@syzkaller.appspotmail.com>
Cc: davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, ChunYu Wang <chunwang@redhat.com>

On Thu, Nov 2, 2017 at 1:55 AM, syzbot
<bot+df9412138a14678abd73a2b70a57241f63563ed1@syzkaller.appspotmail.com>
wrote:
> Hello,
>
> syzkaller hit the following crash on
> 25a5d23b47994cdb451dcd2bc8ac310a1492f71b
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
>
>
> =================================
> BUG: KASAN: use-after-free in sctp_association_free+0x7b7/0x930
> net/sctp/associola.c:333
> Read of size 8 at addr ffff8801d21d4720 by task syzkaller504854/3007
>
> CPU: 0 PID: 3007 Comm: syzkaller504854 Not tainted 4.14.0-rc6+ #62
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:16 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:52
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>  sctp_association_free+0x7b7/0x930 net/sctp/associola.c:333
asoc  could have been freed by sctp_stop_t1_and_abort or elsewhere
when waiting for buf without holding sk lock.

One possible fix:

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c75acdf..e2ea12a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2015,7 +2015,7 @@ static int sctp_sendmsg(struct sock *sk, struct
msghdr *msg, size_t msg_len)
        goto out_unlock;

 out_free:
-       if (new_asoc)
+       if (new_asoc && err != -ESRCH)
                sctp_association_free(asoc);
 out_unlock:
        release_sock(sk);
@@ -7976,10 +7976,11 @@ static int sctp_wait_for_sndbuf(struct
sctp_association *asoc, long *timeo_p,
        for (;;) {
                prepare_to_wait_exclusive(&asoc->wait, &wait,
                                          TASK_INTERRUPTIBLE);
+               if (asoc->base.dead)
+                       goto do_dead;
                if (!*timeo_p)
                        goto do_nonblock;
-               if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING ||
-                   asoc->base.dead)
+               if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING)
                        goto do_error;
                if (signal_pending(current))
                        goto do_interrupted;
@@ -8004,6 +8005,10 @@ static int sctp_wait_for_sndbuf(struct
sctp_association *asoc, long *timeo_p,

        return err;

+do_dead:
+       err = -ESRCH;
+       goto out;
+
 do_error:
        err = -EPIPE;
        goto out;

will check for sure before posting. thanks.

>  sctp_sendmsg+0x2311/0x31f0 net/sctp/socket.c:2011
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:762
>  sock_sendmsg_nosec net/socket.c:633 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:643
>  SYSC_sendto+0x352/0x5a0 net/socket.c:1750
>  SyS_sendto+0x40/0x50 net/socket.c:1718
>  do_syscall_32_irqs_on arch/x86/entry/common.c:329 [inline]
>  do_fast_syscall_32+0x3f2/0xf05 arch/x86/entry/common.c:391
>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:124
> RIP: 0023:0xf7fd2c79
> RSP: 002b:00000000f5fca1ec EFLAGS: 00000292 ORIG_RAX: 0000000000000171
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020925000
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000209e1000
> RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>
> Allocated by task 3007:
>  save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x136/0x750 mm/slab.c:3627
>  kmalloc include/linux/slab.h:493 [inline]
>  kzalloc include/linux/slab.h:666 [inline]
>  sctp_association_new+0x114/0x21e0 net/sctp/associola.c:309
>  sctp_sendmsg+0x128c/0x31f0 net/sctp/socket.c:1838
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:762
>  sock_sendmsg_nosec net/socket.c:633 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:643
>  SYSC_sendto+0x352/0x5a0 net/socket.c:1750
>  SyS_sendto+0x40/0x50 net/socket.c:1718
>  do_syscall_32_irqs_on arch/x86/entry/common.c:329 [inline]
>  do_fast_syscall_32+0x3f2/0xf05 arch/x86/entry/common.c:391
>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:124
>
> Freed by task 3007:
>  save_stack_trace+0x16/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3503 [inline]
>  kfree+0xca/0x250 mm/slab.c:3820
>  sctp_association_destroy net/sctp/associola.c:435 [inline]
>  sctp_association_put+0x21c/0x2f0 net/sctp/associola.c:884
>  sctp_wait_for_sndbuf+0x5e3/0x7c0 net/sctp/socket.c:7836
>  sctp_sendmsg+0x2750/0x31f0 net/sctp/socket.c:1935
>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:762
>  sock_sendmsg_nosec net/socket.c:633 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:643
>  SYSC_sendto+0x352/0x5a0 net/socket.c:1750
>  SyS_sendto+0x40/0x50 net/socket.c:1718
>  do_syscall_32_irqs_on arch/x86/entry/common.c:329 [inline]
>  do_fast_syscall_32+0x3f2/0xf05 arch/x86/entry/common.c:391
>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:124
>
> The buggy address belongs to the object at ffff8801d21d4700
>  which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 32 bytes inside of
>  4096-byte region [ffff8801d21d4700, ffff8801d21d5700)
> The buggy address belongs to the page:
> page:ffffea0007487500 count:1 mapcount:0 mapping:ffff8801d21d4700 index:0x0
> compound_mapcount: 0
> flags: 0x200000000008100(slab|head)
> raw: 0200000000008100 ffff8801d21d4700 0000000000000000 0000000100000001
> raw: ffffea0007487420 ffff8801dac01a48 ffff8801dac00dc0 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801d21d4600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8801d21d4680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>
>> ffff8801d21d4700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>
>                                ^
>  ffff8801d21d4780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801d21d4800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =================================
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> Please credit me with: Reported-by: syzbot <syzkaller@googlegroups.com>
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
> Note: all commands must start from beginning of the line.
