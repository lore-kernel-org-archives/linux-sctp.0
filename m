From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 27 Nov 2017 12:32:35 +0000
Subject: Re: [PATCH net 1/3] sctp: force SCTP_ERROR_INV_STRM with __u32 when calling sctp_chunk_fail
Message-Id: <20171127123235.GD3473@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511698478.git.lucien.xin@gmail.com>
 <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
In-Reply-To: <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On Sun, Nov 26, 2017 at 08:16:06PM +0800, Xin Long wrote:
> This patch is to force SCTP_ERROR_INV_STRM with right type to
> fit in sctp_chunk_fail to avoid the sparse error.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index a20145b..76ea66b 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -64,7 +64,7 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>  		 */
>  
>  		/* Mark as failed send. */
> -		sctp_chunk_fail(ch, SCTP_ERROR_INV_STRM);
> +		sctp_chunk_fail(ch, (__force __u32)SCTP_ERROR_INV_STRM);
>  		if (asoc->peer.prsctp_capable &&
>  		    SCTP_PR_PRIO_ENABLED(ch->sinfo.sinfo_flags))
>  			asoc->sent_cnt_removable--;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
