From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 18 Feb 2011 11:26:18 +0000
Subject: Re: [PATCH][RFC] sctp: fix reporting of unknown parameters
Message-Id: <4D5E575A.9000905@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110217231208.GA28281@midget.suse.cz>
In-Reply-To: <20110217231208.GA28281@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Bohac <jbohac@suse.cz>
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

(cc vlad Yasevich)

Jiri Bohac wrote, at 02/18/2011 07:12 AM:
> Hi,
> 
> commit 5fa782c2f5ef6c2e4f04d3e228412c9b4a4c8809 re-worked the 
> handling of unknown parameters. sctp_init_cause_fixed() can now
> return -ENOSPC if there is not enough tailroom in the error
> chunk skb. When this happens, the error header is not appended to
> the error chunk. In that case, the payload of the unknown parameter
> should not be appended either.
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>

For this case, there is no more tailroom in skb, originally
we send incomplete INIT-ACK chunk. With your patch, this chunk also 
can't info the sender of INIT Chunk which parameter is not unrecognized.
So maybe this handle is not perfect. 

So, for this case, i think send ABORT is more appropriate.
Just take same handle with SCTP_IERROR_NOMEM

> 
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 2cc46f0..b23428f 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2029,11 +2029,11 @@ static sctp_ierror_t sctp_process_unk_param(const struct sctp_association *asoc,
>  			*errp = sctp_make_op_error_fixed(asoc, chunk);
>  
>  		if (*errp) {
> -			sctp_init_cause_fixed(*errp, SCTP_ERROR_UNKNOWN_PARAM,
> -					WORD_ROUND(ntohs(param.p->length)));
> -			sctp_addto_chunk_fixed(*errp,
> -					WORD_ROUND(ntohs(param.p->length)),
> -					param.v);
> +			if (!sctp_init_cause_fixed(*errp, SCTP_ERROR_UNKNOWN_PARAM,
> +					WORD_ROUND(ntohs(param.p->length))))
> +				sctp_addto_chunk_fixed(*errp,
> +						WORD_ROUND(ntohs(param.p->length)),
> +						param.v);
>  		} else {
>  			/* If there is no memory for generating the ERROR
>  			 * report as specified, an ABORT will be triggered
> 
> 


-- 

Best Regards
-----
Shan Wei
