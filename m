From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 27 Mar 2020 02:35:34 +0000
Subject: Re: [PATCH v5 RESEND] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200327023534.GJ3756@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200327012832.19193-1-hqjagain@gmail.com>
In-Reply-To: <20200327012832.19193-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiujun Huang <hqjagain@gmail.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anenbupt@gmail.com

On Fri, Mar 27, 2020 at 09:28:32AM +0800, Qiujun Huang wrote:
> We should iterate over the datamsgs to modify

Just two small things now.
s/modify/move/  , it's more accurate.
But mainly because...

...
> 
> Reported-and-tested-by:syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

checkpatch.pl is warning that there should be an empty space after the
':' here.

Otherwise, looks very good.

Btw, I learned a lot about syzbot new features with your tests, thanks :-)

> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc440606..f68076713162 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -147,29 +147,44 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
>  	skb_orphan(chunk->skb);
>  }
>  
> +#define traverse_and_process()	\
> +do {				\
> +	msg = chunk->msg;	\
> +	if (msg = prev_msg)	\
> +		continue;	\
> +	list_for_each_entry(c, &msg->chunks, frag_list) {	\
> +		if ((clear && asoc->base.sk = c->skb->sk) ||	\
> +		    (!clear && asoc->base.sk != c->skb->sk))	\
> +		    cb(c);	\
> +	}			\
> +	prev_msg = msg;		\
> +} while (0)
> +
>  static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> +				       bool clear,
>  				       void (*cb)(struct sctp_chunk *))
>  
>  {
> +	struct sctp_datamsg *msg, *prev_msg = NULL;
>  	struct sctp_outq *q = &asoc->outqueue;
> +	struct sctp_chunk *chunk, *c;
>  	struct sctp_transport *t;
> -	struct sctp_chunk *chunk;
>  
>  	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
>  		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
> -			cb(chunk);
> +			traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->sacked, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->out_chunk_list, list)
> -		cb(chunk);
> +		traverse_and_process();
>  }
>  
>  static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
> @@ -9574,9 +9589,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  	 * paths won't try to lock it and then oldsk.
>  	 */
>  	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> -	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
> +	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
>  	sctp_assoc_migrate(assoc, newsk);
> -	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
> +	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
>  
>  	/* If the association on the newsk is already closed before accept()
>  	 * is called, set RCV_SHUTDOWN flag.
> -- 
> 2.17.1
> 
