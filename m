From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 30 Nov 2018 18:19:53 +0000
Subject: Re: [PATCH net] sctp: kfree_rcu asoc
Message-Id: <20181130181953.GJ24285@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cbb02c228ba4d3500580bf1fe0792a3b5561517b.1543599419.git.lucien.xin@gmail.com>
In-Reply-To: <cbb02c228ba4d3500580bf1fe0792a3b5561517b.1543599419.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sat, Dec 01, 2018 at 01:36:59AM +0800, Xin Long wrote:
> In sctp_hash_transport/sctp_epaddr_lookup_transport, it dereferences
> a transport's asoc under rcu_read_lock while asoc is freed not after
> a grace period, which leads to a use-after-free panic.
> 
> This patch fixes it by calling kfree_rcu to make asoc be freed after
> a grace period.
> 
> Note that only the asoc's memory is delayed to free in the patch, it
> won't cause sk to linger longer.
> 
> Thanks Neil and Marcelo to make this clear.
> 
Thank you for taking the extra time on this

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> Reported-by: syzbot+0b05d8aa7cb185107483@syzkaller.appspotmail.com
> Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/structs.h | 2 ++
>  net/sctp/associola.c       | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index a11f937..feada35 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -2075,6 +2075,8 @@ struct sctp_association {
>  
>  	__u64 abandoned_unsent[SCTP_PR_INDEX(MAX) + 1];
>  	__u64 abandoned_sent[SCTP_PR_INDEX(MAX) + 1];
> +
> +	struct rcu_head rcu;
>  };
>  
>  
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 6a28b96..3702f48 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -434,7 +434,7 @@ static void sctp_association_destroy(struct sctp_association *asoc)
>  
>  	WARN_ON(atomic_read(&asoc->rmem_alloc));
>  
> -	kfree(asoc);
> +	kfree_rcu(asoc, rcu);
>  	SCTP_DBG_OBJCNT_DEC(assoc);
>  }
>  
> -- 
> 2.1.0
> 
> 
