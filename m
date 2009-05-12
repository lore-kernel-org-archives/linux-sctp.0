From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 12 May 2009 16:08:38 +0000
Subject: Re: [PATCH] sctp: avoid overwrite the return value of sctp_process_asconf_ack()
Message-Id: <4A099F06.2020903@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A098061.6000509@cn.fujitsu.com>
In-Reply-To: <4A098061.6000509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> The return value of sctp_process_asconf_ack() may be
> overwritten while process parameters with no error.
> This patch fixed the problem.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_make_chunk.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ab91712..06ad732 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3271,7 +3271,8 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
>  
>  		switch (err_code) {
>  		case SCTP_ERROR_NO_ERROR:
> -			retval = sctp_asconf_param_success(asoc, asconf_param);
> +			if (sctp_asconf_param_success(asoc, asconf_param))
> +				retval = 1;
>  			break;
>  
>  		case SCTP_ERROR_RSRC_LOW:

Hmm... As long as you are cleaning up, looks like sctp_asconf_param_success
can easily become a void and we avoid this whole thing.  Right now, that function
will never return 'TRUE'.

-vlad
