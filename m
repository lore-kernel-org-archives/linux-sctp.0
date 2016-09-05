From: marcelo.leitner@gmail.com
Date: Mon, 05 Sep 2016 23:48:37 +0000
Subject: Re: [PATCH] sctp: Remove some redundant code
Message-Id: <20160905234837.GB27658@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1472981893-8608-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1472981893-8608-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sun, Sep 04, 2016 at 11:38:13AM +0200, Christophe JAILLET wrote:
> In commit 311b21774f13 ("sctp: simplify sk_receive_queue locking"), a call
> to 'skb_queue_splice_tail_init()' has been made explicit. Previously it was
> hidden in 'sctp_skb_list_tail()'
> 
> Now, the code around it looks redundant. The '_init()' part of
> 'skb_queue_splice_tail_init()' should alreday do the same.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Un-tested

Tested here with some netperf combinations, seems good.
Thanks

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/ulpqueue.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index 877e55066f89..84d0fdaf7de9 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -140,11 +140,8 @@ int sctp_clear_pd(struct sock *sk, struct sctp_association *asoc)
>  		 * we can go ahead and clear out the lobby in one shot
>  		 */
>  		if (!skb_queue_empty(&sp->pd_lobby)) {
> -			struct list_head *list;
>  			skb_queue_splice_tail_init(&sp->pd_lobby,
>  						   &sk->sk_receive_queue);
> -			list = (struct list_head *)&sctp_sk(sk)->pd_lobby;
> -			INIT_LIST_HEAD(list);
>  			return 1;
>  		}
>  	} else {
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
