From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 14 Dec 2017 18:26:25 +0000
Subject: Re: [PATCHv2 net-next 6/8] sctp: add stream interleave support in stream scheduler
Message-Id: <20171214182625.GN3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <754ccfd8f4be04136dafa1d86deb8ee812638887.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <754ccfd8f4be04136dafa1d86deb8ee812638887.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Fri, Dec 15, 2017 at 12:41:30AM +0800, Xin Long wrote:
> As Marcelo said in the stream scheduler patch:
> 
>   Support for I-DATA chunks, also described in RFC8260, with user message
>   interleaving is straightforward as it just requires the schedulers to
>   probe for the feature and ignore datamsg boundaries when dequeueing.
> 
> All needs to do is just to ignore datamsg boundaries when dequeueing.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo R. Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream_sched.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index d8c162a..f5fcd42 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -242,7 +242,8 @@ int sctp_sched_get_value(struct sctp_association *asoc, __u16 sid,
>  
>  void sctp_sched_dequeue_done(struct sctp_outq *q, struct sctp_chunk *ch)
>  {
> -	if (!list_is_last(&ch->frag_list, &ch->msg->chunks)) {
> +	if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
> +	    !q->asoc->intl_enable) {
>  		struct sctp_stream_out *sout;
>  		__u16 sid;
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
