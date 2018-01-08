From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jan 2018 12:09:52 +0000
Subject: Re: WARNING: held lock freed!
Message-Id: <20180108120952.GC727@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a113eb97412e3780562379d43@google.com>
 <CADvbK_d0abDBQwbcuxKNTZphNKYzcBM=gsbjDUuVeifziBGg9A@mail.gmail.com>
In-Reply-To: <CADvbK_d0abDBQwbcuxKNTZphNKYzcBM=gsbjDUuVeifziBGg9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+ac6ea7baa4432811eb50@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Mon, Jan 08, 2018 at 06:01:14PM +0800, Xin Long wrote:
> On Mon, Jan 8, 2018 at 6:58 AM, syzbot
> <syzbot+ac6ea7baa4432811eb50@syzkaller.appspotmail.com> wrote:
> > Hello,
> >
> > syzkaller hit the following crash on
> > 3219e264b984ec0a13923aa66385819c2e98d582
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> >
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+ac6ea7baa4432811eb50@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for
> > details.
> > If you forward the report, please keep this part and the footer.
> >
> >
> > ============> > WARNING: held lock freed!
> > 4.15.0-rc6+ #250 Not tainted
> > -------------------------
> > syzkaller065230/3505 is freeing memory 000000007fcba654-00000000499fef26,
> > with a lock still held there!
> >  (sk_lock-AF_INET6){+.+.}, at: [<00000000abe26b8e>] lock_sock
> > include/net/sock.h:1461 [inline]
> >  (sk_lock-AF_INET6){+.+.}, at: [<00000000abe26b8e>]
> > sctp_wait_for_sndbuf+0x509/0x8d0 net/sctp/socket.c:8042
> > 1 lock held by syzkaller065230/3505:
> >  #0:  (sk_lock-AF_INET6){+.+.}, at: [<00000000abe26b8e>] lock_sock
> > include/net/sock.h:1461 [inline]
> >  #0:  (sk_lock-AF_INET6){+.+.}, at: [<00000000abe26b8e>]
> > sctp_wait_for_sndbuf+0x509/0x8d0 net/sctp/socket.c:8042
> >
> > stack backtrace:
> > CPU: 0 PID: 3505 Comm: syzkaller065230 Not tainted 4.15.0-rc6+ #250
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:17 [inline]
> >  dump_stack+0x194/0x257 lib/dump_stack.c:53
> >  print_freed_lock_bug kernel/locking/lockdep.c:4379 [inline]
> >  debug_check_no_locks_freed+0x32f/0x3c0 kernel/locking/lockdep.c:4412
> >  kmem_cache_free+0x68/0x2a0 mm/slab.c:3743
> >  sk_prot_free net/core/sock.c:1504 [inline]
> >  __sk_destruct+0x622/0x910 net/core/sock.c:1585
> >  sk_destruct+0x47/0x80 net/core/sock.c:1593
> >  __sk_free+0x57/0x230 net/core/sock.c:1601
> >  sk_free+0x2a/0x40 net/core/sock.c:1612
> >  sock_put include/net/sock.h:1656 [inline]
> >  sctp_association_destroy net/sctp/associola.c:424 [inline]
> >  sctp_association_put+0x14c/0x2f0 net/sctp/associola.c:883
> >  sctp_wait_for_sndbuf+0x673/0x8d0 net/sctp/socket.c:8053
> >  sctp_sendmsg+0x277d/0x3360 net/sctp/socket.c:1974
> >  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:763
> >  sock_sendmsg_nosec net/socket.c:636 [inline]
> >  sock_sendmsg+0xca/0x110 net/socket.c:646
> >  SYSC_sendto+0x361/0x5c0 net/socket.c:1727
> >  SyS_sendto+0x40/0x50 net/socket.c:1695
> >  entry_SYSCALL_64_fastpath+0x23/0x9a
> > RIP: 0033:0x445db9
> > RSP: 002b:00007f2467415d98 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> > RAX: ffffffffffffffda RBX: 00000000006dbc84 RCX: 0000000000445db9
> > RDX: 0000000000000001 RSI: 000000002010bf14 RDI: 0000000000000005
> > RBP: 0000000000000000 R08: 00000000204d9000 R09: 000000000000001c
> > R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006dbc80
> > R13: 00000000209a9000 R14: 0100000000000000 R15: 0000000000000001
> > =================================
> > BUG: KASAN: use-after-free in debug_spin_lock_before
> > kernel/locking/spinlock_debug.c:83 [inline]
> > BUG: KASAN: use-after-free in do_raw_spin_lock+0x1e0/0x220
> > kernel/locking/spinlock_debug.c:112
> > Read of size 4 at addr ffff8801c17ab08c by task syzkaller065230/3505
> 
> It seems this commit is buggy:
> commit cea0cc80a6777beb6eb643d4ad53690e1ad1d4ff
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Wed Nov 15 16:57:26 2017 +0800
> 
>     sctp: use the right sk after waking up from wait_buf sleep
> 
> I already had a patch to drop it and fix the old issue with a better way.

Maybe you can quickly share it, so we have an idea what you are
talking about?
