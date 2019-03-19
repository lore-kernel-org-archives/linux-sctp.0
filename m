From: David Miller <davem@davemloft.net>
Date: Tue, 19 Mar 2019 01:24:31 +0000
Subject: Re: [PATCH net] sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant
Message-Id: <20190318.182431.545997926960587440.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <130ce0bbbc015f9fb47f97b51c650843e2ac39a3.1552910309.git.lucien.xin@gmail.com>
In-Reply-To: <130ce0bbbc015f9fb47f97b51c650843e2ac39a3.1552910309.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 19:58:29 +0800

> Now sctp_copy_descendant() copies pd_lobby from old sctp scok to new
> sctp sock. If sctp_sock_migrate() returns error, it will panic when
> releasing new sock and trying to purge pd_lobby due to the incorrect
> pointers in pd_lobby.
> 
>   [  120.485116] kasan: CONFIG_KASAN_INLINE enabled
>   [  120.486270] kasan: GPF could be caused by NULL-ptr deref or user
>   [  120.509901] Call Trace:
>   [  120.510443]  sctp_ulpevent_free+0x1e8/0x490 [sctp]
>   [  120.511438]  sctp_queue_purge_ulpevents+0x97/0xe0 [sctp]
>   [  120.512535]  sctp_close+0x13a/0x700 [sctp]
>   [  120.517483]  inet_release+0xdc/0x1c0
>   [  120.518215]  __sock_release+0x1d2/0x2a0
>   [  120.519025]  sctp_do_peeloff+0x30f/0x3c0 [sctp]
> 
> We fix it by not copying sctp_sock pd_lobby in sctp_copy_descendan(),
> and skb_queue_head_init() can also be removed in sctp_sock_migrate().
> 
> Reported-by: syzbot+85e0b422ff140b03672a@syzkaller.appspotmail.com
> Fixes: 89664c623617 ("sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and looks to not need -stable backporting.  Let me know if you
disagree.
