From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 27 Nov 2017 13:36:40 +0000
Subject: Re: [PATCH net 2/5] sctp: only allow the out stream reset when the stream outq is empty
Message-Id: <20171127133640.GI3473@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Sat, Nov 25, 2017 at 09:05:33PM +0800, Xin Long wrote:
> Now the out stream reset in sctp stream reconf could be done even if
> the stream outq is not empty. It means that users can not be sure
> since which msg the new ssn will be used.
> 
> To make this more synchronous, it shouldn't allow to do out stream
> reset until these chunks in unsent outq all are sent out.
> 
> This patch checks the corresponding stream outqs when sending and
> processing the request . If any of them has unsent chunks in outq,
> it will return -EAGAIN instead or send SCTP_STRRESET_IN_PROGRESS
> back to the sender.
> 
> Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 09c797a..b209037 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -254,6 +254,30 @@ static int sctp_send_reconf(struct sctp_association *asoc,
>  	return retval;
>  }
>  
> +static bool sctp_stream_outq_is_empty(struct sctp_stream *stream,
> +				      __u16 str_nums, __be16 *str_list)
> +{
> +	struct sctp_association *asoc;
> +	__u16 i;
> +
> +	asoc = container_of(stream, struct sctp_association, stream);
> +	if (!asoc->outqueue.out_qlen)
> +		return true;
> +
> +	if (!str_nums)
> +		return false;
> +
> +	for (i = 0; i < str_nums; i++) {
> +		__u16 sid = ntohs(str_list[i]);
> +
> +		if (stream->out[sid].ext &&
> +		    !list_empty(&stream->out[sid].ext->outq))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  int sctp_send_reset_streams(struct sctp_association *asoc,
>  			    struct sctp_reset_streams *params)
>  {
> @@ -317,6 +341,11 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
>  	for (i = 0; i < str_nums; i++)
>  		nstr_list[i] = htons(str_list[i]);
>  
> +	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> +		retval = -EAGAIN;
> +		goto out;
> +	}
> +
>  	chunk = sctp_make_strreset_req(asoc, str_nums, nstr_list, out, in);
>  
>  	kfree(nstr_list);
> @@ -636,6 +665,12 @@ struct sctp_chunk *sctp_process_strreset_inreq(
>  		}
>  	}
>  
> +	if (!sctp_stream_outq_is_empty(stream, nums, str_p)) {
> +		result = SCTP_STRRESET_IN_PROGRESS;
> +		asoc->strreset_inseq--;
> +		goto err;
> +	}
> +
>  	chunk = sctp_make_strreset_req(asoc, nums, str_p, 1, 0);
>  	if (!chunk)
>  		goto out;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
