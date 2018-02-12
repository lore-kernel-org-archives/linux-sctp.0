From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 12 Feb 2018 12:35:10 +0000
Subject: Re: [PATCH net] sctp: remove the useless check in sctp_renege_events
Message-Id: <20180212123510.GK7402@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <8db12ad85c54e5b56bc871e977bd71a1f6ea2e99.1518431484.git.lucien.xin@gmail.com>
In-Reply-To: <8db12ad85c54e5b56bc871e977bd71a1f6ea2e99.1518431484.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Feb 12, 2018 at 06:31:24PM +0800, Xin Long wrote:
> Remove the 'if (chunk)' check in sctp_renege_events for idata process,
> as all renege commands are generated in sctp_eat_data and it can't be
> NULL.
> 
> The same thing we already did for common data in sctp_ulpq_renege.
> 
> Fixes: 94014e8d871a ("sctp: implement renege_events for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

For future reference, I don't think the Fixes tag is needed here, as
it was working and without performance impact.

> ---
>  net/sctp/stream_interleave.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index c19fd42..65ac03b 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -955,12 +955,8 @@ static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
>  	__u32 freed = 0;
>  	__u16 needed;
>  
> -	if (chunk) {
> -		needed = ntohs(chunk->chunk_hdr->length);
> -		needed -= sizeof(struct sctp_idata_chunk);
> -	} else {
> -		needed = SCTP_DEFAULT_MAXWINDOW;
> -	}
> +	needed = ntohs(chunk->chunk_hdr->length) -
> +		 sizeof(struct sctp_idata_chunk);
>  
>  	if (skb_queue_empty(&asoc->base.sk->sk_receive_queue)) {
>  		freed = sctp_ulpq_renege_list(ulpq, &ulpq->lobby, needed);
> -- 
> 2.1.0
> 
