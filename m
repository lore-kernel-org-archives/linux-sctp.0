From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 18 Dec 2013 09:38:29 +0000
Subject: Re: [PATCH net-next 2/3] sctp: remove the never used 'return' and, redundant 'break'
Message-Id: <52B16D15.2010501@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B168E0.1060108@huawei.com>
In-Reply-To: <52B168E0.1060108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 2013/12/18 17:20, Wang Weidong wrote:
> In switch() had do return, and never use the 'return NULL'. The
> 'break' after return or goto has no effect. Remove it.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>  net/sctp/input.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 2a192a7..c956dc9 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -1120,15 +1120,10 @@ static struct sctp_association *__sctp_rcv_lookup_harder(struct net *net,
>  	case SCTP_CID_INIT:
>  	case SCTP_CID_INIT_ACK:
>  		return __sctp_rcv_init_lookup(net, skb, laddr, transportp);
> -		break;
>  
>  	default:
>  		return __sctp_rcv_walk_lookup(net, skb, laddr, transportp);
> -		break;
>  	}
> -
> -
> -	return NULL;
>  }
>  
>  /* Lookup an association for an inbound skb. */
> 

Sorry for sending the Subject "[PATCH net-next 2/3] ...".
It is only one patch, not series.

Regards.
Wang

