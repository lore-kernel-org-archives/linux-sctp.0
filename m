From: David Miller <davem@davemloft.net>
Date: Wed, 20 Mar 2019 18:10:28 +0000
Subject: Re: [PATCH net] sctp: use memdup_user instead of vmemdup_user
Message-Id: <20190320.111028.467469471139039452.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <94e635135533b7469c84b0aa4df59ea7818a486a.1553064578.git.lucien.xin@gmail.com>
In-Reply-To: <94e635135533b7469c84b0aa4df59ea7818a486a.1553064578.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 20 Mar 2019 14:49:38 +0800

> In sctp_setsockopt_bindx()/__sctp_setsockopt_connectx(), it allocates
> memory with addrs_size which is passed from userspace. We used flag
> GFP_USER to put some more restrictions on it in Commit cacc06215271
> ("sctp: use GFP_USER for user-controlled kmalloc").
> 
> However, since Commit c981f254cc82 ("sctp: use vmemdup_user() rather
> than badly open-coding memdup_user()"), vmemdup_user() has been used,
> which doesn't check GFP_USER flag when goes to vmalloc_*(). So when
> addrs_size is a huge value, it could exhaust memory and even trigger
> oom killer.
> 
> This patch is to use memdup_user() instead, in which GFP_USER would
> work to limit the memory allocation with a huge addrs_size.
> 
> Note we can't fix it by limiting 'addrs_size', as there's no demand
> for it from RFC.
> 
> Reported-by: syzbot+ec1b7575afef85a0e5ca@syzkaller.appspotmail.com
> Fixes: c981f254cc82 ("sctp: use vmemdup_user() rather than badly open-coding memdup_user()")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks Xin.
