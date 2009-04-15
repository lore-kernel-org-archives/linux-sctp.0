From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 15 Apr 2009 13:17:55 +0000
Subject: Re: [PATCH] sctp: fix the format of invalid mandatory parameter format
Message-Id: <49E5DE83.2000509@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <49E59612.70504@cn.fujitsu.com>
In-Reply-To: <49E59612.70504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> RFC 4960 defined the format of invalid mandatory parameter:
> 
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>    |     Cause Code=7              |      Cause Length=4           |
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> But invalid mandatory parameter sent in ASCONF-ACK chunk include the
> invalid paramter complete with TLV.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_make_chunk.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 6851ee9..46de41a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2822,7 +2822,7 @@ static void sctp_add_asconf_response(struct sctp_chunk *chunk, __be32 crr_id,
>  	} else {
>  		response_type = SCTP_PARAM_ERR_CAUSE;
>  		err_param_len = sizeof(err_param);
> -		if (asconf_param)
> +		if (asconf_param && err_code != SCTP_ERROR_INV_PARAM)
>  			asconf_param_len >  				 ntohs(asconf_param->param_hdr.length);
>  	}
> @@ -2844,7 +2844,7 @@ static void sctp_add_asconf_response(struct sctp_chunk *chunk, __be32 crr_id,
>  	sctp_addto_chunk(chunk, err_param_len, &err_param);
>  
>  	/* Add the failed TLV copied from ASCONF chunk. */
> -	if (asconf_param)
> +	if (asconf_param && err_code != SCTP_ERROR_INV_PARAM)
>  		sctp_addto_chunk(chunk, asconf_param_len, asconf_param);
>  }
>  

This is not the right solution.  The problem this introduces is that now will
not be able to distinguish what went wrong during the ASCONF operation.

Looking further, it seems that we send SCTP_ERROR_INV_PARAM any time we
are handling a bad or unsupported address.  By definition, address parameters
are not mandatory in the ASCONF chunk, so sending back an "Invalid Mandatory Parameter"
error is not the right thing to do.  Looking through the errors, a more appropriate
error to send back is "Unresolvable Address (5)" error.  The description of that error
code is:

   Unresolvable Address: Indicates that the sender is not able to
   resolve the specified address parameter (e.g., type of address is not
   supported by the sender).  This is usually sent in combination with

This fits perfectly with all the verifications that sctp_process_asconf_param() does
on the address.  Granted, our symbol for this error parameter is rather one-sided, so that
might need an update as well.

-vlad
