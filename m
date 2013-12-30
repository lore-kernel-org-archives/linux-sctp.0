From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 30 Dec 2013 11:32:54 +0000
Subject: Re: [RFC PATCH net-next 0/3] sctp accept socket fix
Message-Id: <52C159E6.9080802@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387891183-21169-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1387891183-21169-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 2013/12/24 21:19, Daniel Borkmann wrote:
> lksctp-tools test suite seems to work just fine with this set.
> 
> Found a bit of time, so I continued on this, still on TODO for after Xmas:
> 
>   - Peeled-off sockets, shall we treat them just like accepted sockets
>     and do a flat copy here, or do we want to avoid this for some reasons?
>   - Polish up commit messages, further stress tests
> 
> Daniel Borkmann (3):
>   net: sock: introduce sock_sanitize
>   net: sock: add sk_copy_sanitize for use in modules
>   net: sctp: use sk_copy_sanitize for accept sockets
> 
>  include/net/sctp/sctp.h |   4 +-
>  include/net/sock.h      |   1 +
>  net/core/sock.c         | 197 ++++++++++++++++++++++++++----------------------
>  net/sctp/ipv6.c         |  11 ++-
>  net/sctp/protocol.c     |  13 ++--
>  net/sctp/socket.c       | 102 +++++++++++++++----------
>  6 files changed, 182 insertions(+), 146 deletions(-)
> 
Hi Daniel,

I test them on my machine. I open the LOCKDEP and got the result below:

------------
[   74.750256] sctp: Hash tables configured (established 52428 bind 52428)
[   92.173914] 
[   92.173923] ================[   92.173930] [ INFO: inconsistent lock state ]
[   92.173938] 3.13.0-rc4-0.27-default+ #2 Not tainted
[   92.173944] ---------------------------------
[   92.173953] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[   92.173963] test_1_to_1_acc/3321 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   92.173972]  (slock-AF_INET){+.?...}, at: [<ffffffff81437f31>] sock_sanitize+0xc1/0x3e0
[   92.173995] {IN-SOFTIRQ-W} state was registered at:
[   92.174003]   [<ffffffff810a2546>] mark_irqflags+0xf6/0x190
[   92.174017]   [<ffffffff810a40cc>] __lock_acquire+0x53c/0x670
[   92.174027]   [<ffffffff810a42e2>] lock_acquire+0xe2/0x110
[   92.174037]   [<ffffffff8152a6e1>] _raw_spin_lock+0x31/0x70
[   92.174050]   [<ffffffff814b1763>] tcp_write_timer+0x23/0x90
[   92.174063]   [<ffffffff810599e7>] call_timer_fn+0xb7/0x160
[   92.174076]   [<ffffffff8105a937>] run_timer_softirq+0x267/0x280
[   92.174087]   [<ffffffff810519bb>] __do_softirq+0x11b/0x290
[   92.174099]   [<ffffffff81051c55>] irq_exit+0xd5/0xe0
[   92.174109]   [<ffffffff81032a75>] smp_apic_timer_interrupt+0x45/0x60
[   92.174121]   [<ffffffff81534c6f>] apic_timer_interrupt+0x6f/0x80
[   92.174133]   [<ffffffff8100b52e>] arch_cpu_idle+0x1e/0x30
[   92.174146]   [<ffffffff810b5b8b>] cpu_idle_loop+0x7b/0x240
[   92.174158]   [<ffffffff810b5d6e>] cpu_startup_entry+0x1e/0x20
[   92.174168]   [<ffffffff810305ae>] start_secondary+0x7e/0x80
[   92.174181] irq event stamp: 19389
[   92.174187] hardirqs last  enabled at (19389): [<ffffffff810a2ca3>] debug_check_no_locks_freed+0x93/0xd0
[   92.174202] hardirqs last disabled at (19388): [<ffffffff810a2c3d>] debug_check_no_locks_freed+0x2d/0xd0
[   92.174216] softirqs last  enabled at (19370): [<ffffffff81435465>] lock_sock_nested+0x75/0x90
[   92.174229] softirqs last disabled at (19368): [<ffffffff8152a9d3>] _raw_spin_lock_bh+0x13/0x70
[   92.174241] 
[   92.174241] other info that might help us debug this:
[   92.174251]  Possible unsafe locking scenario:
[   92.174251] 
[   92.174260]        CPU0
[   92.174265]        ----
[   92.174270]   lock(slock-AF_INET);
[   92.174277]   <Interrupt>
[   92.174282]     lock(slock-AF_INET);
[   92.174290] 
[   92.174290]  *** DEADLOCK ***
[   92.174290] 
[   92.174301] 1 lock held by test_1_to_1_acc/3321:
[   92.174308]  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffffa0291b46>] sctp_accept+0x36/0xf0 [sctp]
[   92.174337] 
[   92.174337] stack backtrace:
[   92.174347] CPU: 3 PID: 3321 Comm: test_1_to_1_acc Not tainted 3.13.0-rc4-0.27-default+ #2
[   92.174358] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   92.174366]  ffffffff821bc6d8 ffff880037583b58 ffffffff81524e7b ffff880037583bb8
[   92.174381]  ffffffff810a1a27 0000000000000000 0000000000000001 ffff880000000001
[   92.174394]  0000000000000046 ffffffff817d631c 0000000000000004 0000000000000006
[   92.174408] Call Trace:
[   92.174419]  [<ffffffff81524e7b>] dump_stack+0x6a/0x77
[   92.174429]  [<ffffffff810a1a27>] print_usage_bug+0x197/0x1a0
[   92.174440]  [<ffffffff810a1260>] ? check_usage_forwards+0x110/0x110
[   92.174451]  [<ffffffff810a212c>] mark_lock_irq+0xfc/0x220
[   92.174461]  [<ffffffff810a2375>] mark_lock+0x125/0x200
[   92.174471]  [<ffffffff810a2594>] mark_irqflags+0x144/0x190
[   92.174481]  [<ffffffff810a40cc>] __lock_acquire+0x53c/0x670
[   92.174491]  [<ffffffff810a42e2>] lock_acquire+0xe2/0x110
[   92.174501]  [<ffffffff81437f31>] ? sock_sanitize+0xc1/0x3e0
[   92.174511]  [<ffffffff8152a6e1>] _raw_spin_lock+0x31/0x70
[   92.174520]  [<ffffffff81437f31>] ? sock_sanitize+0xc1/0x3e0
[   92.174530]  [<ffffffff81437f31>] sock_sanitize+0xc1/0x3e0
[   92.174540]  [<ffffffff814382f8>] sk_copy_sanitize+0xa8/0xc0
[   92.174550]  [<ffffffff8143833e>] sk_clone_lock+0x2e/0x40
[   92.174560]  [<ffffffff81096580>] ? bit_waitqueue+0xe0/0xe0
[   92.174579]  [<ffffffffa028db92>] sctp_clone_lock+0x12/0xb0 [sctp]
[   92.174597]  [<ffffffffa027b777>] sctp_v4_create_accept_sk+0x17/0x90 [sctp]
[   92.174617]  [<ffffffffa0291bd3>] sctp_accept+0xc3/0xf0 [sctp]
[   92.174630]  [<ffffffff814cf978>] inet_accept+0x28/0x270
[   92.174642]  [<ffffffff81431d31>] SyS_accept4+0x141/0x1e0
[   92.174652]  [<ffffffff81534047>] ? sysret_check+0x1b/0x56
[   92.174663]  [<ffffffff8142f2db>] SyS_accept+0xb/0x10
[   92.174672]  [<ffffffff81534022>] system_call_fastpath+0x16/0x1b
-------------------

I am not sure what happen to it, So I post it here.

Regards, 
Wang



