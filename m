From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 10 May 2018 14:10:50 +0000
Subject: Re: [PATCH net] sctp: remove sctp_chunk_put from fail_mark err path in sctp_ulpevent_make_rcvmsg
Message-Id: <20180510141050.GV5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <e4d7cf118c028ed05c9005951e30babc8bb300eb.1525944853.git.lucien.xin@gmail.com>
In-Reply-To: <e4d7cf118c028ed05c9005951e30babc8bb300eb.1525944853.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com

On Thu, May 10, 2018 at 05:34:13PM +0800, Xin Long wrote:
> In Commit 1f45f78f8e51 ("sctp: allow GSO frags to access the chunk too"),
> it held the chunk in sctp_ulpevent_make_rcvmsg to access it safely later
> in recvmsg. However, it also added sctp_chunk_put in fail_mark err path,
> which is only triggered before holding the chunk.
>
> syzbot reported a use-after-free crash happened on this err path, where
> it shouldn't call sctp_chunk_put.
>
> This patch simply removes this call.
>
> Fixes: 1f45f78f8e51 ("sctp: allow GSO frags to access the chunk too")
> Reported-by: syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/ulpevent.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index 84207ad..8cb7d98 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -715,7 +715,6 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
>  	return event;
>
>  fail_mark:
> -	sctp_chunk_put(chunk);
>  	kfree_skb(skb);
>  fail:
>  	return NULL;
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
