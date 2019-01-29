From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 29 Jan 2019 21:17:23 +0000
Subject: Re: [PATCH net-next 02/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_PARAMS sockopt
Message-Id: <20190129211723.GA2592@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Mon, Jan 28, 2019 at 03:08:24PM +0800, Xin Long wrote:
> Check with SCTP_FUTURE_ASSOC instead in
> sctp_/setgetsockopt_peer_addr_params, it's compatible with 0.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index a52d132..4c43b95 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2750,12 +2750,13 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
>  			return -EINVAL;
>  	}
>  
> -	/* Get association, if assoc_id != 0 and the socket is a one
> -	 * to many style socket, and an association was not found, then
> -	 * the id was invalid.
> +	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
> +	 * socket is a one to many style socket, and an association
> +	 * was not found, then the id was invalid.
>  	 */
>  	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
> -	if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP))
> +	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
If we are disallowing SCTP_FUTURE_ASSOC here, why would we allow SCTP_ALL_ASSOC
(which, as noted by patch 0, includes future associations)?

> +	    sctp_style(sk, UDP))
>  		return -EINVAL;
>  
>  	/* Heartbeat demand can only be sent on a transport or
> @@ -5676,12 +5677,13 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
>  		}
>  	}
>  
> -	/* Get association, if assoc_id != 0 and the socket is a one
> -	 * to many style socket, and an association was not found, then
> -	 * the id was invalid.
> +	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
> +	 * socket is a one to many style socket, and an association
> +	 * was not found, then the id was invalid.
>  	 */
>  	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
> -	if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP)) {
> +	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
Same question as above, shouldn't both of these be restricted to specific
associations or to CURRENT associations?

> +	    sctp_style(sk, UDP)) {
>  		pr_debug("%s: failed no association\n", __func__);
>  		return -EINVAL;
>  	}
> -- 
> 2.1.0
> 
> 
