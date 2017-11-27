From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 27 Nov 2017 13:36:26 +0000
Subject: Re: [PATCH net 1/5] sctp: use sizeof(__u16) for each stream number length instead of magic number
Message-Id: <20171127133626.GH3473@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <feb3ee6070cc0f526210fa36752148c0e0704bcf.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <feb3ee6070cc0f526210fa36752148c0e0704bcf.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Sat, Nov 25, 2017 at 09:05:32PM +0800, Xin Long wrote:
> Now in stream reconf part there are still some places using magic
> number 2 for each stream number length. To make it more readable,
> this patch is to replace them with sizeof(__u16).
> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index a11db21..09c797a 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -563,7 +563,7 @@ struct sctp_chunk *sctp_process_strreset_outreq(
>  		flags = SCTP_STREAM_RESET_INCOMING_SSN;
>  	}
>  
> -	nums = (ntohs(param.p->length) - sizeof(*outreq)) / 2;
> +	nums = (ntohs(param.p->length) - sizeof(*outreq)) / sizeof(__u16);
>  	if (nums) {
>  		str_p = outreq->list_of_streams;
>  		for (i = 0; i < nums; i++) {
> @@ -627,7 +627,7 @@ struct sctp_chunk *sctp_process_strreset_inreq(
>  		goto out;
>  	}
>  
> -	nums = (ntohs(param.p->length) - sizeof(*inreq)) / 2;
> +	nums = (ntohs(param.p->length) - sizeof(*inreq)) / sizeof(__u16);
>  	str_p = inreq->list_of_streams;
>  	for (i = 0; i < nums; i++) {
>  		if (ntohs(str_p[i]) >= stream->outcnt) {
> @@ -927,7 +927,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
>  
>  		outreq = (struct sctp_strreset_outreq *)req;
>  		str_p = outreq->list_of_streams;
> -		nums = (ntohs(outreq->param_hdr.length) - sizeof(*outreq)) / 2;
> +		nums = (ntohs(outreq->param_hdr.length) - sizeof(*outreq)) /
> +		       sizeof(__u16);
>  
>  		if (result = SCTP_STRRESET_PERFORMED) {
>  			if (nums) {
> @@ -956,7 +957,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
>  
>  		inreq = (struct sctp_strreset_inreq *)req;
>  		str_p = inreq->list_of_streams;
> -		nums = (ntohs(inreq->param_hdr.length) - sizeof(*inreq)) / 2;
> +		nums = (ntohs(inreq->param_hdr.length) - sizeof(*inreq)) /
> +		       sizeof(__u16);
>  
>  		*evp = sctp_ulpevent_make_stream_reset_event(asoc, flags,
>  			nums, str_p, GFP_ATOMIC);
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
