From: David Miller <davem@davemloft.net>
Date: Fri, 08 Mar 2019 19:25:03 +0000
Subject: Re: [PATCH net] sctp: remove sched init from sctp_stream_init
Message-Id: <20190308.112503.775390652844673739.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f6f7a239cbe5a5dc051f605752e03b54d68e878a.1552031356.git.lucien.xin@gmail.com>
In-Reply-To: <f6f7a239cbe5a5dc051f605752e03b54d68e878a.1552031356.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri,  8 Mar 2019 15:49:16 +0800

> syzbot reported a NULL-ptr deref caused by that sched->init() in
> sctp_stream_init() set stream->rr_next = NULL.
> 
>   kasan: GPF could be caused by NULL-ptr deref or user memory access
>   RIP: 0010:sctp_sched_rr_dequeue+0xd3/0x170 net/sctp/stream_sched_rr.c:141
>   Call Trace:
>     sctp_outq_dequeue_data net/sctp/outqueue.c:90 [inline]
>     sctp_outq_flush_data net/sctp/outqueue.c:1079 [inline]
>     sctp_outq_flush+0xba2/0x2790 net/sctp/outqueue.c:1205
> 
> All sched info is saved in sout->ext now, in sctp_stream_init()
> sctp_stream_alloc_out() will not change it, there's no need to
> call sched->init() again, since sctp_outq_init() has already
> done it.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
