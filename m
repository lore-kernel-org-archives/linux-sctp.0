From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 11 Dec 2013 14:38:58 +0000
Subject: Re: [PATCH net-next] sctp: remove redundant null check on asoc
Message-Id: <52A87902.8070900@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52A82566.1050601@huawei.com>
In-Reply-To: <52A82566.1050601@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 12/11/2013 03:42 AM, Wang Weidong wrote:
> In sctp_err_lookup, goto out while the asoc is not NULL, so remove the
> check NULL. Also, in sctp_err_finish which called by sctp_v4_err and
> sctp_v6_err, they pass asoc to sctp_err_finish while the asoc is not
> NULL, so remove the check.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>


Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Thanks
-vlad

> ---
>  net/sctp/input.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 6603853..2a192a7 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -536,8 +536,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
>  	return sk;
>  
>  out:
> -	if (asoc)
> -		sctp_association_put(asoc);
> +	sctp_association_put(asoc);
>  	return NULL;
>  }
>  
> @@ -545,8 +544,7 @@ out:
>  void sctp_err_finish(struct sock *sk, struct sctp_association *asoc)
>  {
>  	sctp_bh_unlock_sock(sk);
> -	if (asoc)
> -		sctp_association_put(asoc);
> +	sctp_association_put(asoc);
>  }
>  
>  /*
> 

