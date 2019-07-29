From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 29 Jul 2019 19:03:52 +0000
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-Id: <20190729190352.GD4064@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564426521-22525-1-git-send-email-info@metux.net>
In-Reply-To: <1564426521-22525-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 08:55:21PM +0200, Enrico Weigelt, metux IT consult wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index aa80cda..9d1f83b 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Walk through the addrs buffer and count the number of addresses. */
> @@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Allow security module to validate connectx addresses. */
> -- 
> 1.9.1
> 
