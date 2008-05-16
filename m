From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 16 May 2008 12:48:38 +0000
Subject: Re: [PATCH] [SCTP] Fix a type cast bug
Message-Id: <482D82A6.1060704@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482D4A8E.4090903@cn.fujitsu.com>
In-Reply-To: <482D4A8E.4090903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>

Gui

Gui Jianfeng wrote:
> Vlad,
> 
> event_arg can never be the type of "struct sctp_chunk *" 
> if the event_type is SCTP_EVENT_T_OTHER. This fix
> prevents from potential kernel crash by some misuse.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  net/sctp/sm_sideeffect.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index a4763fd..1b4bae9 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1072,7 +1072,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
>  	struct sctp_sackhdr sackh;
>  	int local_cork = 0;
>  
> -	if (SCTP_EVENT_T_TIMEOUT != event_type)
> +	if (SCTP_EVENT_T_TIMEOUT != event_type &&
> +	    SCTP_EVENT_T_OTHER != event_type)
>  		chunk = (struct sctp_chunk *) event_arg;
>  
>  	/* Note:  This whole file is a huge candidate for rework.


This doesn't really fix the bug since the event_arg can be something else during
primitive events and you would still have a typecast issue.

This code is rather ugly, but if we are going to clean it up, we need to do right
and not band-aid to death.

As it is, NACK on this patch, since it doesn't solve the problem.

-vlad

