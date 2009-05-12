From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 12 May 2009 16:14:19 +0000
Subject: Re: [PATCH] sctp: check the unrecognized ASCONF parameter before
Message-Id: <4A09A05B.9060109@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A0980B3.9050106@cn.fujitsu.com>
In-Reply-To: <4A0980B3.9050106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> This patch fix to check the unrecognized ASCONF parameter before
> access it.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_make_chunk.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 61cc607..ab91712 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2861,6 +2861,11 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
>  	addr_param = (union sctp_addr_param *)
>  			((void *)asconf_param + sizeof(sctp_addip_param_t));
>  
> +	if (asconf_param->param_hdr.type != SCTP_PARAM_ADD_IP &&
> +	    asconf_param->param_hdr.type != SCTP_PARAM_DEL_IP &&
> +	    asconf_param->param_hdr.type != SCTP_PARAM_SET_PRIMARY)
> +		return SCTP_ERROR_UNKNOWN_PARAM;
> +
>  	switch (addr_param->v4.param_hdr.type) {
>  	case SCTP_PARAM_IPV6_ADDRESS:
>  		if (!asoc->peer.ipv6_address)

Clean up the 'default' case, since it now becomes dead code.

-vlad
