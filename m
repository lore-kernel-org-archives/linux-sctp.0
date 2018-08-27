From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 27 Aug 2018 13:30:03 +0000
Subject: Re: [PATCH net] sctp: remove useless start_fail from sctp_ht_iter in proc
Message-Id: <20180827133003.GC4591@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <265533f54ceb4684bb8323c9601a743eed409527.1535366418.git.lucien.xin@gmail.com>
In-Reply-To: <265533f54ceb4684bb8323c9601a743eed409527.1535366418.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Aug 27, 2018 at 06:40:18PM +0800, Xin Long wrote:
> After changing rhashtable_walk_start to return void, start_fail would
> never be set other value than 0, and the checking for start_fail is
> pointless, so remove it.
> 
> Fixes: 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to return void")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/proc.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 4d6f1c8..a644292 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -215,7 +215,6 @@ static const struct seq_operations sctp_eps_ops = {
>  struct sctp_ht_iter {
>  	struct seq_net_private p;
>  	struct rhashtable_iter hti;
> -	int start_fail;
>  };
>  
>  static void *sctp_transport_seq_start(struct seq_file *seq, loff_t *pos)
> @@ -224,7 +223,6 @@ static void *sctp_transport_seq_start(struct seq_file *seq, loff_t *pos)
>  
>  	sctp_transport_walk_start(&iter->hti);
>  
> -	iter->start_fail = 0;
>  	return sctp_transport_get_idx(seq_file_net(seq), &iter->hti, *pos);
>  }
>  
> @@ -232,8 +230,6 @@ static void sctp_transport_seq_stop(struct seq_file *seq, void *v)
>  {
>  	struct sctp_ht_iter *iter = seq->private;
>  
> -	if (iter->start_fail)
> -		return;
>  	sctp_transport_walk_stop(&iter->hti);
>  }
>  
> -- 
> 2.1.0
> 
