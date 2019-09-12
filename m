From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 12 Sep 2019 14:51:47 +0000
Subject: Re: [PATCH v2 net 1/3] sctp: change return type of sctp_get_port_local
Message-Id: <20190912145147.GR3431@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-2-maowenan@huawei.com>
In-Reply-To: <20190912040219.67517-2-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mao Wenan <maowenan@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, Sep 12, 2019 at 12:02:17PM +0800, Mao Wenan wrote:
> Currently sctp_get_port_local() returns a long
> which is either 0,1 or a pointer casted to long.
> It's neither of the callers use the return value since
> commit 62208f12451f ("net: sctp: simplify sctp_get_port").
> Now two callers are sctp_get_port and sctp_do_bind,
> they actually assumend a casted to an int was the same as
> a pointer casted to a long, and they don't save the return
> value just check whether it is zero or non-zero, so
> it would better change return type from long to int for
> sctp_get_port_local.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This Fixes tag is not needed. It's just a cleanup.
Maybe Dave can remove it for us.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks.

> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/sctp/socket.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9d1f83b10c0a..5e1934c48709 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -309,7 +309,7 @@ static int sctp_bind(struct sock *sk, struct sockaddr *addr, int addr_len)
>  	return retval;
>  }
>  
> -static long sctp_get_port_local(struct sock *, union sctp_addr *);
> +static int sctp_get_port_local(struct sock *, union sctp_addr *);
>  
>  /* Verify this is a valid sockaddr. */
>  static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
> @@ -7998,7 +7998,7 @@ static void sctp_unhash(struct sock *sk)
>  static struct sctp_bind_bucket *sctp_bucket_create(
>  	struct sctp_bind_hashbucket *head, struct net *, unsigned short snum);
>  
> -static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
> +static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	bool reuse = (sk->sk_reuse || sp->reuse);
> @@ -8108,7 +8108,7 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
>  
>  			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
>  						    addr, sp2, sp)) {
> -				ret = (long)sk2;
> +				ret = 1;
>  				goto fail_unlock;
>  			}
>  		}
> @@ -8180,7 +8180,7 @@ static int sctp_get_port(struct sock *sk, unsigned short snum)
>  	addr.v4.sin_port = htons(snum);
>  
>  	/* Note: sk->sk_num gets filled in if ephemeral port request. */
> -	return !!sctp_get_port_local(sk, &addr);
> +	return sctp_get_port_local(sk, &addr);
>  }
>  
>  /*
> -- 
> 2.20.1
> 
