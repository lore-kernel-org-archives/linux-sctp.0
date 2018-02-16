From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 16 Feb 2018 12:26:12 +0000
Subject: Re: [PATCH net] sctp: remove the left unnecessary check for chunk in sctp_renege_events
Message-Id: <20180216122612.GA10040@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <0e61bb1ebe6aad2c06f426fec30f69a80d127ad8.1518772713.git.lucien.xin@gmail.com>
In-Reply-To: <0e61bb1ebe6aad2c06f426fec30f69a80d127ad8.1518772713.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>

On Fri, Feb 16, 2018 at 05:18:33PM +0800, Xin Long wrote:
> Commit fb23403536ea ("sctp: remove the useless check in
> sctp_renege_events") forgot to remove another check for
> chunk in sctp_renege_events.
> 
> Dan found this when doing a static check.
> 
> This patch is to remove that check, and also to merge
> two checks into one 'if statement'.
> 
> Fixes: fb23403536ea ("sctp: remove the useless check in sctp_renege_events")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/stream_interleave.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index 65ac03b..d3764c1 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -968,9 +968,8 @@ static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
>  						       needed);
>  	}
>  
> -	if (chunk && freed >= needed)
> -		if (sctp_ulpevent_idata(ulpq, chunk, gfp) <= 0)
> -			sctp_intl_start_pd(ulpq, gfp);
> +	if (freed >= needed && sctp_ulpevent_idata(ulpq, chunk, gfp) <= 0)
> +		sctp_intl_start_pd(ulpq, gfp);
>  
>  	sk_mem_reclaim(asoc->base.sk);
>  }
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
