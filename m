From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 14 Dec 2017 18:26:17 +0000
Subject: Re: [PATCHv2 net-next 5/8] sctp: implement handle_ftsn for sctp_stream_interleave
Message-Id: <20171214182617.GM3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <d001538d3ff8d80ba726b5443675b7eea6ee09f6.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <d001538d3ff8d80ba726b5443675b7eea6ee09f6.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Fri, Dec 15, 2017 at 12:41:29AM +0800, Xin Long wrote:
> handle_ftsn is added as a member of sctp_stream_interleave, used to skip
> ssn for data or mid for idata, called for SCTP_CMD_PROCESS_FWDTSN cmd.
> 
> sctp_handle_iftsn works for ifwdtsn, and sctp_handle_fwdtsn works for
> fwdtsn. Note that different from sctp_handle_fwdtsn, sctp_handle_iftsn
> could do stream abort pd.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo R. Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/stream_interleave.h |  2 ++
>  net/sctp/sm_sideeffect.c             | 15 ++---------
>  net/sctp/stream_interleave.c         | 49 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
> index 0b55c70..6657711 100644
> --- a/include/net/sctp/stream_interleave.h
> +++ b/include/net/sctp/stream_interleave.h
> @@ -52,6 +52,8 @@ struct sctp_stream_interleave {
>  	void	(*generate_ftsn)(struct sctp_outq *q, __u32 ctsn);
>  	bool	(*validate_ftsn)(struct sctp_chunk *chunk);
>  	void	(*report_ftsn)(struct sctp_ulpq *ulpq, __u32 ftsn);
> +	void	(*handle_ftsn)(struct sctp_ulpq *ulpq,
> +			       struct sctp_chunk *chunk);
>  };
>  
>  void sctp_stream_interleave_init(struct sctp_stream *stream);
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index be7c6dbd..16ddf2c 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1007,18 +1007,6 @@ static void sctp_cmd_process_operr(struct sctp_cmd_seq *cmds,
>  	}
>  }
>  
> -/* Process variable FWDTSN chunk information. */
> -static void sctp_cmd_process_fwdtsn(struct sctp_ulpq *ulpq,
> -				    struct sctp_chunk *chunk)
> -{
> -	struct sctp_fwdtsn_skip *skip;
> -
> -	/* Walk through all the skipped SSNs */
> -	sctp_walk_fwdtsn(skip, chunk) {
> -		sctp_ulpq_skip(ulpq, ntohs(skip->stream), ntohs(skip->ssn));
> -	}
> -}
> -
>  /* Helper function to remove the association non-primary peer
>   * transports.
>   */
> @@ -1372,7 +1360,8 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
>  			break;
>  
>  		case SCTP_CMD_PROCESS_FWDTSN:
> -			sctp_cmd_process_fwdtsn(&asoc->ulpq, cmd->obj.chunk);
> +			asoc->stream.si->handle_ftsn(&asoc->ulpq,
> +						     cmd->obj.chunk);
>  			break;
>  
>  		case SCTP_CMD_GEN_SACK:
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index f62771cc..8c7cf8f 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -1239,6 +1239,53 @@ static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
>  		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
>  }
>  
> +static void sctp_handle_fwdtsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)
> +{
> +	struct sctp_fwdtsn_skip *skip;
> +
> +	/* Walk through all the skipped SSNs */
> +	sctp_walk_fwdtsn(skip, chunk)
> +		sctp_ulpq_skip(ulpq, ntohs(skip->stream), ntohs(skip->ssn));
> +}
> +
> +static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
> +			   __u8 flags)
> +{
> +	struct sctp_stream_in *sin = sctp_stream_in(ulpq->asoc, sid);
> +	struct sctp_stream *stream  = &ulpq->asoc->stream;
> +
> +	if (flags & SCTP_FTSN_U_BIT) {
> +		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
> +			sin->pd_mode_uo = 0;
> +			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
> +						  GFP_ATOMIC);
> +		}
> +		return;
> +	}
> +
> +	if (MID_lt(mid, sctp_mid_peek(stream, in, sid)))
> +		return;
> +
> +	if (sin->pd_mode) {
> +		sin->pd_mode = 0;
> +		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
> +	}
> +
> +	sctp_mid_skip(stream, in, sid, mid);
> +
> +	sctp_intl_reap_ordered(ulpq, sid);
> +}
> +
> +static void sctp_handle_iftsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)
> +{
> +	struct sctp_ifwdtsn_skip *skip;
> +
> +	/* Walk through all the skipped MIDs and abort stream pd if possible */
> +	sctp_walk_ifwdtsn(skip, chunk)
> +		sctp_intl_skip(ulpq, ntohs(skip->stream),
> +			       ntohl(skip->mid), skip->flags);
> +}
> +
>  static struct sctp_stream_interleave sctp_stream_interleave_0 = {
>  	.data_chunk_len		= sizeof(struct sctp_data_chunk),
>  	.ftsn_chunk_len		= sizeof(struct sctp_fwdtsn_chunk),
> @@ -1255,6 +1302,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
>  	.generate_ftsn		= sctp_generate_fwdtsn,
>  	.validate_ftsn		= sctp_validate_fwdtsn,
>  	.report_ftsn		= sctp_report_fwdtsn,
> +	.handle_ftsn		= sctp_handle_fwdtsn,
>  };
>  
>  static struct sctp_stream_interleave sctp_stream_interleave_1 = {
> @@ -1273,6 +1321,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
>  	.generate_ftsn		= sctp_generate_iftsn,
>  	.validate_ftsn		= sctp_validate_iftsn,
>  	.report_ftsn		= sctp_report_iftsn,
> +	.handle_ftsn		= sctp_handle_iftsn,
>  };
>  
>  void sctp_stream_interleave_init(struct sctp_stream *stream)
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
