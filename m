From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 17 May 2010 06:14:48 +0000
Subject: Re: [PATCH CLEANUP] sctp: fix the comment of  sctp_sf_violation_paramlen()
Message-Id: <4BF0DED8.40503@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BF0DD56.70105@cn.fujitsu.com>
In-Reply-To: <4BF0DD56.70105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org



于 2010年05月17日 14:08, Shan Wei 写道:
> The comment about sctp_sf_violation_paramlen() is wrong.
>
> Invalid length should be identified as it does not equal actual length
> of a given parameter. The actual length of a given parameter is not including
> the padding part.
>   

Not right. If the param length is larger then what is request, we
also treat it as correct. And for unkonw params, we just check
the length larger then the minimal length.

>
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_statefuns.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index edb71e6..8774a6e 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -4355,8 +4355,8 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
>  
>  /*
>   * Handle a protocol violation when the parameter length is invalid.
> - * "Invalid" length is identified as smaller than the minimal length a
> - * given parameter can be.
> + * "Invalid" length is identified as it does not equal actual length
> + * of a given parameter.
>   */
>  static sctp_disposition_t sctp_sf_violation_paramlen(
>  				     const struct sctp_endpoint *ep,
>   
