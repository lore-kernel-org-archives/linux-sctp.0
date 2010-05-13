From: Wei Yongjun <xiaow1982@gmail.com>
Date: Thu, 13 May 2010 13:19:25 +0000
Subject: Re: [PATCH 1/3 v2] sctp: check parameter value of length in ERROR
Message-Id: <4BEBFC5D.6090402@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BEBEB13.9080108@cn.fujitsu.com>
In-Reply-To: <4BEBEB13.9080108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> When an endpoint receives ERROR that parameter value is invalid,
> send an ABORT to peer with a Protocol Violation error code.
>
>
> Signed-off-by: Shan Wei<shanwei@cn.fujitsu.com>
> ---
> v1-v2:
> 1. As Vlad's suggestion, use chunk->chunk_end to point to end of chunk.
> ---
>   net/sctp/sm_statefuns.c |   31 +++++++++++++++++++++++++++++++
>   1 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 24b2cd5..d54038b 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -116,6 +116,13 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
>   				     void *arg,
>   				     sctp_cmd_seq_t *commands);
>
> +static sctp_disposition_t sctp_sf_violation_paramvalue(
> +				     const struct sctp_endpoint *ep,
> +				     const struct sctp_association *asoc,
> +				     const sctp_subtype_t type,
> +				     void *arg,
> +				     sctp_cmd_seq_t *commands);
> +
>   static sctp_disposition_t sctp_sf_violation_paramlen(
>   				     const struct sctp_endpoint *ep,
>   				     const struct sctp_association *asoc,
> @@ -3204,6 +3211,7 @@ sctp_disposition_t sctp_sf_operr_notify(const struct sctp_endpoint *ep,
>   					sctp_cmd_seq_t *commands)
>   {
>   	struct sctp_chunk *chunk = arg;
> +	sctp_errhdr_t *err;
>
>   	if (!sctp_vtag_verify(chunk, asoc))
>   		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
> @@ -3213,6 +3221,11 @@ sctp_disposition_t sctp_sf_operr_notify(const struct sctp_endpoint *ep,
>   		return sctp_sf_violation_chunklen(ep, asoc, type, arg,
>   						  commands);
>
> +	sctp_walk_errors(err, chunk->chunk_hdr);
> +	if ((void *)err != (void *)chunk->chunk_end)
> +		return sctp_sf_violation_paramvalue(ep, asoc, type, arg,
> +						    commands);
> +
>    

This check is not for param value, but for param length only, so
you should use sctp_sf_violation_paramlen() instead.

>   	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_OPERR,
>   			SCTP_CHUNK(chunk));
>
> @@ -4343,6 +4356,24 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
>
>   /*
>    * Handle a protocol violation when the parameter length is invalid.
> + * "Invalid" length is identified as the parameter value of length
> + * in a Type-Length-Value format is not match the true length of chunk.
> + */
> +static sctp_disposition_t sctp_sf_violation_paramvalue(
> +				     const struct sctp_endpoint *ep,
> +				     const struct sctp_association *asoc,
> +				     const sctp_subtype_t type,
> +				     void *arg,
> +				     sctp_cmd_seq_t *commands)
> +{
> +	static const char err_str[]="The following chunk had invalid parameter value:";
> +
> +	return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> +					sizeof(err_str));
> +}
> +
> +/*
> + * Handle a protocol violation when the parameter length is invalid.
>    * "Invalid" length is identified as smaller than the minimal length a
>    * given parameter can be.
>    */
>    

