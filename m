From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 12 Feb 2018 13:59:35 +0000
Subject: Re: [PATCH net] sctp: do not pr_err for the duplicated node in transport rhlist
Message-Id: <20180212135935.GA21383@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <f5a0c541d1e47f66d3513ab7974a6e9262ebe09d.1518431346.git.lucien.xin@gmail.com>
In-Reply-To: <f5a0c541d1e47f66d3513ab7974a6e9262ebe09d.1518431346.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Feb 12, 2018 at 06:29:06PM +0800, Xin Long wrote:
> The pr_err in sctp_hash_transport was supposed to report a sctp bug
> for using rhashtable/rhlist.
> 
> The err '-EEXIST' introduced in Commit cd2b70875058 ("sctp: check
> duplicate node before inserting a new transport") doesn't belong
> to that case.
> 
> So just return -EEXIST back without pr_err any kmsg.
> 
> Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> Reported-by: Wei Chen <weichen@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/input.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 141c9c4..0247cc4 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -897,15 +897,12 @@ int sctp_hash_transport(struct sctp_transport *t)
>  	rhl_for_each_entry_rcu(transport, tmp, list, node)
>  		if (transport->asoc->ep = t->asoc->ep) {
>  			rcu_read_unlock();
> -			err = -EEXIST;
> -			goto out;
> +			return -EEXIST;
>  		}
>  	rcu_read_unlock();
>  
>  	err = rhltable_insert_key(&sctp_transport_hashtable, &arg,
>  				  &t->node, sctp_hash_params);
> -
> -out:
>  	if (err)
>  		pr_err_once("insert transport fail, errno %d\n", err);
>  
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
