From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Mar 2019 12:21:36 +0000
Subject: Re: [PATCH net] sctp: remove sched init from sctp_stream_init
Message-Id: <20190308122136.GA982@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <f6f7a239cbe5a5dc051f605752e03b54d68e878a.1552031356.git.lucien.xin@gmail.com>
In-Reply-To: <f6f7a239cbe5a5dc051f605752e03b54d68e878a.1552031356.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Fri, Mar 08, 2019 at 03:49:16PM +0800, Xin Long wrote:
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
> ---
>  net/sctp/stream.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 2936ed1..3b47457 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -230,8 +230,6 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>  	for (i = 0; i < stream->outcnt; i++)
>  		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
>  
> -	sched->init(stream);
> -
>  in:
>  	sctp_stream_interleave_init(stream);
>  	if (!incnt)
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
