From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 03 Feb 2010 09:51:56 +0000
Subject: Re: [PATCH] sctp: avoid irq lock inversion while call sk->sk_data_ready()
Message-Id: <4B69473C.6060100@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B6903D6.8070106@cn.fujitsu.com>
In-Reply-To: <4B6903D6.8070106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

>
> sk->sk_data_ready() of sctp socket can be called from both BH and non-BH
> contexts, but the default sk->sk_data_ready(), sock_def_readable(), can
> not be used in this case. Therefore, we have to make a new function
> sctp_data_ready() to grab sk->sk_data_ready() with BH disabling.
>
> ============================> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.33-rc6 #129
> ---------------------------------------------------------
> sctp_darn/1517 just changed the state of lock:
>  (clock-AF_INET){++.?..}, at: [<c06aab60>] sock_def_readable+0x20/0x80
> but this lock took another, SOFTIRQ-unsafe lock in the past:
>  (slock-AF_INET){+.-...}
>
> and interrupts could create inverse lock ordering between them.
>
> other info that might help us debug this:
> 1 lock held by sctp_darn/1517:
>  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<cdfe363d>] sctp_sendmsg+0x23d/0xc00 [sctp]
>   

The full lockdep output message is:

============================[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc6 #129
---------------------------------------------------------
sctp_darn/1517 just changed the state of lock:
 (clock-AF_INET){++.?..}, at: [<c06aab60>] sock_def_readable+0x20/0x80
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (slock-AF_INET){+.-...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by sctp_darn/1517:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<cdfe363d>] sctp_sendmsg+0x23d/0xc00 [sctp]

the shortest dependencies between 2nd lock and 1st lock:
 -> (slock-AF_INET){+.-...} ops: 0 {
    HARDIRQ-ON-W at:
                          [<c04717ff>] __lock_acquire+0x9af/0x1890
                          [<c047275f>] lock_acquire+0x7f/0xf0
                          [<c0762bbd>] _raw_spin_lock_bh+0x3d/0x50
                          [<c06aa723>] lock_sock_nested+0x33/0xf0
                          [<c06ed27a>] tcp_close+0x1a/0x390
                          [<c070eefb>] inet_release+0x3b/0x60
                          [<c06a8030>] sock_release+0x20/0x70
                          [<c06a8097>] sock_close+0x17/0x30
                          [<c04f687b>] __fput+0xfb/0x200
                          [<c04f699d>] fput+0x1d/0x30
                          [<c04f341c>] filp_close+0x4c/0x80
                          [<c04f34c7>] sys_close+0x77/0xc0
                          [<c0402d8c>] sysenter_do_call+0x12/0x32
    IN-SOFTIRQ-W at:
                          [<c04717e3>] __lock_acquire+0x993/0x1890
                          [<c047275f>] lock_acquire+0x7f/0xf0
                          [<c0762968>] _raw_spin_lock+0x38/0x50
                          [<c070601e>] udp_queue_rcv_skb+0xee/0x2c0
                          [<c07067ef>] __udp4_lib_rcv+0x1bf/0x6a0
                          [<c0706ce7>] udp_rcv+0x17/0x20
                          [<c06e194f>] ip_local_deliver_finish+0xdf/0x2c0
                          [<c06e1bbf>] ip_local_deliver+0x8f/0xa0
                          [<c06e12cb>] ip_rcv_finish+0xdb/0x3c0
                          [<c06e17b6>] ip_rcv+0x206/0x2c0
                          [<c06b79ef>] netif_receive_skb+0x34f/0x570
                          [<cc83ac5e>] pcnet32_poll+0x27e/0x7a0 [pcnet32]
                          [<c06b84b0>] net_rx_action+0x150/0x230
                          [<c0449520>] __do_softirq+0xa0/0x1c0
    INITIAL USE at:
                         [<c04711bf>] __lock_acquire+0x36f/0x1890
                         [<c047275f>] lock_acquire+0x7f/0xf0
                         [<c0762bbd>] _raw_spin_lock_bh+0x3d/0x50
                         [<c06aa723>] lock_sock_nested+0x33/0xf0
                         [<c06ed27a>] tcp_close+0x1a/0x390
                         [<c070eefb>] inet_release+0x3b/0x60
                         [<c06a8030>] sock_release+0x20/0x70
                         [<c06a8097>] sock_close+0x17/0x30
                         [<c04f687b>] __fput+0xfb/0x200
                         [<c04f699d>] fput+0x1d/0x30
                         [<c04f341c>] filp_close+0x4c/0x80
                         [<c04f34c7>] sys_close+0x77/0xc0
                         [<c0402d8c>] sysenter_do_call+0x12/0x32
  }
  ... key      at: [<c0f2d8d0>] af_family_slock_keys+0x10/0x140
  ... acquired at:
   [<c0471fc2>] __lock_acquire+0x1172/0x1890
   [<c047275f>] lock_acquire+0x7f/0xf0
   [<c0762c0d>] _raw_write_lock_bh+0x3d/0x50
   [<c06ab3ad>] sk_common_release+0x2d/0xb0
   [<cdfe2ff8>] sctp_close+0xe8/0x1f0 [sctp]
   [<c070eefb>] inet_release+0x3b/0x60
   [<c06a8030>] sock_release+0x20/0x70
   [<c06a8097>] sock_close+0x17/0x30
   [<c04f687b>] __fput+0xfb/0x200
   [<c04f699d>] fput+0x1d/0x30
   [<c04f341c>] filp_close+0x4c/0x80
   [<c04f34c7>] sys_close+0x77/0xc0
   [<c0402d8c>] sysenter_do_call+0x12/0x32

-> (clock-AF_INET){++.?..} ops: 0 {
   HARDIRQ-ON-W at:
                        [<c04717ff>] __lock_acquire+0x9af/0x1890
                        [<c047275f>] lock_acquire+0x7f/0xf0
                        [<c0762c0d>] _raw_write_lock_bh+0x3d/0x50
                        [<c06ed359>] tcp_close+0xf9/0x390
                        [<c070eefb>] inet_release+0x3b/0x60
                        [<c06a8030>] sock_release+0x20/0x70
                        [<c06a8097>] sock_close+0x17/0x30
                        [<c04f687b>] __fput+0xfb/0x200
                        [<c04f699d>] fput+0x1d/0x30
                        [<c04f341c>] filp_close+0x4c/0x80
                        [<c04f34c7>] sys_close+0x77/0xc0
                        [<c0402d8c>] sysenter_do_call+0x12/0x32
   HARDIRQ-ON-R at:
                        [<c0470fd6>] __lock_acquire+0x186/0x1890
                        [<c047275f>] lock_acquire+0x7f/0xf0
                        [<c0762fa8>] _raw_read_lock+0x38/0x50
                        [<c06aaaac>] sock_def_write_space+0x1c/0xb0
                        [<c06ab33a>] sock_wfree+0x4a/0x60
                        [<c06af175>] skb_release_head_state+0x45/0xc0
                        [<c06aeea0>] __kfree_skb+0x10/0x90
                        [<c06b57a9>] net_tx_action+0x59/0x140
                        [<c0449520>] __do_softirq+0xa0/0x1c0
   IN-SOFTIRQ-R at:
                        [<c04717e3>] __lock_acquire+0x993/0x1890
                        [<c047275f>] lock_acquire+0x7f/0xf0
                        [<c0762fa8>] _raw_read_lock+0x38/0x50
                        [<c06aaaac>] sock_def_write_space+0x1c/0xb0
                        [<c06ab33a>] sock_wfree+0x4a/0x60
                        [<c06af175>] skb_release_head_state+0x45/0xc0
                        [<c06aeea0>] __kfree_skb+0x10/0x90
                        [<c06b57a9>] net_tx_action+0x59/0x140
                        [<c0449520>] __do_softirq+0xa0/0x1c0
   SOFTIRQ-ON-R at:
                        [<c0471824>] __lock_acquire+0x9d4/0x1890
                        [<c047275f>] lock_acquire+0x7f/0xf0
                        [<c0762fa8>] _raw_read_lock+0x38/0x50
                        [<c06aab60>] sock_def_readable+0x20/0x80
                        [<cdfdebc4>] sctp_ulpq_tail_event+0x134/0x210 [sctp]
                        [<cdfd253e>] sctp_side_effects+0x8ee/0x10c0 [sctp]
                        [<cdfd2dc0>] sctp_do_sm+0xb0/0x1c0 [sctp]
                        [<cdfe6bc2>] sctp_primitive_ABORT+0x42/0x50 [sctp]
                        [<cdfe3892>] sctp_sendmsg+0x492/0xc00 [sctp]
                        [<c070df9e>] inet_sendmsg+0x2e/0x60
                        [<c06a7527>] sock_sendmsg+0xe7/0x110
                        [<c06a7723>] sys_sendmsg+0x113/0x230
                        [<c06a956b>] sys_socketcall+0xeb/0x2a0
                        [<c0402d8c>] sysenter_do_call+0x12/0x32
   INITIAL USE at:
                       [<c04711bf>] __lock_acquire+0x36f/0x1890
                       [<c047275f>] lock_acquire+0x7f/0xf0
                       [<c0762c0d>] _raw_write_lock_bh+0x3d/0x50
                       [<c06ed359>] tcp_close+0xf9/0x390
                       [<c070eefb>] inet_release+0x3b/0x60
                       [<c06a8030>] sock_release+0x20/0x70
                       [<c06a8097>] sock_close+0x17/0x30
                       [<c04f687b>] __fput+0xfb/0x200
                       [<c04f699d>] fput+0x1d/0x30
                       [<c04f341c>] filp_close+0x4c/0x80
                       [<c04f34c7>] sys_close+0x77/0xc0
                       [<c0402d8c>] sysenter_do_call+0x12/0x32
 }
 ... key      at: [<c0f2da10>] af_callback_keys+0x10/0x128
 ... acquired at:
   [<c04735db>] check_usage_backwards+0x8b/0xd0
   [<c046fd9a>] mark_lock+0x1ba/0x5c0
   [<c0471824>] __lock_acquire+0x9d4/0x1890
   [<c047275f>] lock_acquire+0x7f/0xf0
   [<c0762fa8>] _raw_read_lock+0x38/0x50
   [<c06aab60>] sock_def_readable+0x20/0x80
   [<cdfdebc4>] sctp_ulpq_tail_event+0x134/0x210 [sctp]
   [<cdfd253e>] sctp_side_effects+0x8ee/0x10c0 [sctp]
   [<cdfd2dc0>] sctp_do_sm+0xb0/0x1c0 [sctp]
   [<cdfe6bc2>] sctp_primitive_ABORT+0x42/0x50 [sctp]
   [<cdfe3892>] sctp_sendmsg+0x492/0xc00 [sctp]
   [<c070df9e>] inet_sendmsg+0x2e/0x60
   [<c06a7527>] sock_sendmsg+0xe7/0x110
   [<c06a7723>] sys_sendmsg+0x113/0x230
   [<c06a956b>] sys_socketcall+0xeb/0x2a0
   [<c0402d8c>] sysenter_do_call+0x12/0x32


stack backtrace:
Pid: 1517, comm: sctp_darn Not tainted 2.6.33-rc6 #129
Call Trace:
 [<c075f994>] ? printk+0x1d/0x21
 [<c047353e>] print_irq_inversion_bug.clone.0+0xfe/0x110
 [<c04735db>] check_usage_backwards+0x8b/0xd0
 [<c046fd9a>] mark_lock+0x1ba/0x5c0
 [<c059e513>] ? string+0x33/0xe0
 [<c0473550>] ? check_usage_backwards+0x0/0xd0
 [<c0471824>] __lock_acquire+0x9d4/0x1890
 [<c059e513>] ? string+0x33/0xe0
 [<c0762a4b>] ? _raw_spin_lock_irqsave+0x1b/0x60
 [<c07630cf>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
 [<c046f37b>] ? trace_hardirqs_off+0xb/0x10
 [<c07630cf>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
 [<c044338f>] ? release_console_sem+0x1ef/0x240
 [<c047275f>] lock_acquire+0x7f/0xf0
 [<c06aab60>] ? sock_def_readable+0x20/0x80
 [<c0762fa8>] _raw_read_lock+0x38/0x50
 [<c06aab60>] ? sock_def_readable+0x20/0x80
 [<c06aab60>] sock_def_readable+0x20/0x80
 [<cdfdebc4>] sctp_ulpq_tail_event+0x134/0x210 [sctp]
 [<cdfd253e>] sctp_side_effects+0x8ee/0x10c0 [sctp]
 [<c0762a4b>] ? _raw_spin_lock_irqsave+0x1b/0x60
 [<cdfd2dc0>] sctp_do_sm+0xb0/0x1c0 [sctp]
 [<c044338f>] ? release_console_sem+0x1ef/0x240
 [<cdfe6bc2>] sctp_primitive_ABORT+0x42/0x50 [sctp]
 [<cdfe3892>] sctp_sendmsg+0x492/0xc00 [sctp]
 [<c070df9e>] inet_sendmsg+0x2e/0x60
 [<c06a7527>] sock_sendmsg+0xe7/0x110
 [<c046f37b>] ? trace_hardirqs_off+0xb/0x10
 [<c04d6810>] ? might_fault+0x50/0xa0
 [<c04d6810>] ? might_fault+0x50/0xa0
 [<c04d6856>] ? might_fault+0x96/0xa0
 [<c04d6810>] ? might_fault+0x50/0xa0
 [<c05a140d>] ? _copy_from_user+0x3d/0x130
 [<c06a7723>] sys_sendmsg+0x113/0x230
 [<c06aa6e7>] ? release_sock+0xd7/0xe0
 [<c04704eb>] ? trace_hardirqs_on+0xb/0x10
 [<c0449298>] ? local_bh_enable_ip+0x68/0xd0
 [<cdfe4b0c>] ? sctp_getsockopt+0x9c/0x1010 [sctp]
 [<c0472949>] ? lock_release_non_nested+0x59/0x2f0
 [<c04704eb>] ? trace_hardirqs_on+0xb/0x10
 [<c06093ce>] ? put_ldisc+0x3e/0xc0
 [<c04d6810>] ? might_fault+0x50/0xa0
 [<c04d6810>] ? might_fault+0x50/0xa0
 [<c06a956b>] sys_socketcall+0xeb/0x2a0
 [<c0402dbb>] ? sysenter_exit+0xf/0x16
 [<c0402d8c>] sysenter_do_call+0x12/0x32


