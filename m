From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 May 2018 12:04:43 +0000
Subject: Re: [PATCH net] sctp: fix the issue that the cookie-ack with auth can't get processed
Message-Id: <20180502120443.GH4977@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <aec2a2b5bff80a4d8eb6a9db96a36a92e429e574.1525239912.git.lucien.xin@gmail.com>
In-Reply-To: <aec2a2b5bff80a4d8eb6a9db96a36a92e429e574.1525239912.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, May 02, 2018 at 01:45:12PM +0800, Xin Long wrote:
> When auth is enabled for cookie-ack chunk, in sctp_inq_pop, sctp
> processes auth chunk first, then continues to the next chunk in
> this packet if chunk_end + chunk_hdr size < skb_tail_pointer().
> Otherwise, it will go to the next packet or discard this chunk.
>
> However, it missed the fact that cookie-ack chunk's size is equal
> to chunk_hdr size, which couldn't match that check, and thus this
> chunk would not get processed.
>
> This patch fixes it by changing the check to chunk_end + chunk_hdr
> size <= skb_tail_pointer().
>
> Fixes: 26b87c788100 ("net: sctp: fix remote memory pressure from excessive queueing")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/inqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
> index 23ebc53..eb93ffe 100644
> --- a/net/sctp/inqueue.c
> +++ b/net/sctp/inqueue.c
> @@ -217,7 +217,7 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
>  	skb_pull(chunk->skb, sizeof(*ch));
>  	chunk->subh.v = NULL; /* Subheader is no longer valid.  */
>
> -	if (chunk->chunk_end + sizeof(*ch) < skb_tail_pointer(chunk->skb)) {
> +	if (chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb)) {
>  		/* This is not a singleton */
>  		chunk->singleton = 0;
>  	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {
> --
> 2.1.0
>
