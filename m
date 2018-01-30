From: Eric Biggers <ebiggers3@gmail.com>
Date: Tue, 30 Jan 2018 21:57:44 +0000
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in sctp_cmp_addr_exact
Message-Id: <20180130215744.kansfggbyabkajfi@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1146f1143233340560c0d18a@google.com>
In-Reply-To: <001a1146f1143233340560c0d18a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+07ea76fffac26ec31e0f0bf349d7859a91b55a85@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Tue, Dec 19, 2017 at 11:49:03PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> binder: 23647:23660 DecRefs 0 refcount change on invalid ref 4 ret -22
> binder: 23647:23660 BC_CLEAR_DEATH_NOTIFICATION invalid ref 0
> binder: 23647:23660 BC_REQUEST_DEATH_NOTIFICATION invalid ref 3
> binder: 23647:23660 got reply transaction with no transaction stack
> binder: 23647:23660 transaction failed 29201/-71, size 24-16 line 2747
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> IP: sctp_cmp_addr_exact+0x14/0x60 net/sctp/associola.c:911
> PGD 1dde2b067 P4D 1dde2b067 PUD 1ddf17067 PMD 0
> Oops: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 23653 Comm: syz-executor1 Not tainted 4.15.0-rc3-next-20171214+
> #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:sctp_cmp_addr_exact+0x14/0x60 net/sctp/associola.c:911
> RSP: 0018:ffffc90000da7b38 EFLAGS: 00010216
> RAX: 0000000000010000 RBX: fffffffffffffff0 RCX: ffffffff823e3464
> RDX: 0000000000000731 RSI: ffffc90003199000 RDI: 0000000000000078
> RBP: ffffc90000da7b50 R08: 0000000000000001 R09: 0000000000000002
> R10: ffffc90000da7b18 R11: 0000000000000002 R12: 0000000000000078
> R13: ffff8801d9231488 R14: ffffc90000da7bc8 R15: ffffffff831e6c20
> FS:  00007f601f498700(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000078 CR3: 00000001d9071000 CR4: 00000000001426f0
> DR0: 0000000020000008 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  sctp_hash_cmp+0x2b/0xb0 net/sctp/input.c:807
>  __rhashtable_lookup include/linux/rhashtable.h:633 [inline]
>  rhltable_lookup include/linux/rhashtable.h:716 [inline]
>  sctp_hash_transport+0x179/0xb00 net/sctp/input.c:890
>  sctp_assoc_add_peer+0x31d/0x450 net/sctp/associola.c:718
>  sctp_sendmsg+0xd59/0x14d0 net/sctp/socket.c:1921
>  inet_sendmsg+0x54/0x250 net/ipv4/af_inet.c:763
>  sock_sendmsg_nosec net/socket.c:636 [inline]
>  sock_sendmsg+0x51/0x70 net/socket.c:646
>  SYSC_sendto+0x17f/0x1d0 net/socket.c:1727
>  SyS_sendto+0x40/0x50 net/socket.c:1695
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a39
> RSP: 002b:00007f601f497c58 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00000000007580d8 RCX: 0000000000452a39
> RDX: 0000000000000001 RSI: 0000000020aaff09 RDI: 000000000000001a
> RBP: 00000000000003a1 R08: 000000002030bfe4 R09: 000000000000001c
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006f37b8
> R13: 00000000ffffffff R14: 00007f601f4986d4 R15: 0000000000000002
> Code: 00 01 8d 50 01 89 93 34 06 00 00 5b 5d c3 66 0f 1f 84 00 00 00 00 00
> 55 48 89 e5 41 55 41 54 53 49 89 fc 49 89 f5 e8 dc 6e ed fe <41> 0f b7 3c 24
> e8 92 e3 ff ff 48 85 c0 74 21 48 89 c3 e8 c5 6e
> RIP: sctp_cmp_addr_exact+0x14/0x60 net/sctp/associola.c:911 RSP:
> ffffc90000da7b38
> CR2: 0000000000000078
> ---[ end trace 436f7126566693ea ]---

Invalidating this bug since it hasn't been seen again, and it was reported while
KASAN was accidentally disabled in the syzbot kconfig due to a change to the
kconfig menus in linux-next (so this crash was possibly caused by slab
corruption elsewhere).

#syz invalid
