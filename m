From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 01 Dec 2009 19:02:58 +0000
Subject: Re: [PATCH] sctp: fix sctp_setsockopt_autoclose compile warning
Message-Id: <4B156862.5020903@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au> <20091130094929.GY10897@shell.iptel.org> <20091130095250.GZ10897@shell.iptel.org>
In-Reply-To: <20091130095250.GZ10897@shell.iptel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrei Pelinescu-Onciul <andrei@iptel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org



Andrei Pelinescu-Onciul wrote:
> Fix the following warning, when building on 64 bits:
> 
> net/sctp/socket.c:2091: warning: large integer implicitly
>                         truncated to unsigned type
> 
> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>

Ack.

-vlad

> ---
>  net/sctp/socket.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 71513b3..8961863 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2088,7 +2088,7 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
>  		return -EFAULT;
>  	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
>  	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
> -		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
> +		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
>  
>  	return 0;
>  }
