From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 09 Dec 2011 17:38:19 +0000
Subject: Re: [PATCH RESEND] sctp: fix incorrect overflow check on autoclose
Message-Id: <4EE2478B.5010409@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323393883-3759-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1323393883-3759-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xi Wang <xi.wang@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>, "David S. Miller" <davem@davemloft.net>

On 12/08/2011 08:24 PM, Xi Wang wrote:
> The commit 8ffd3208 voids the previous patches f6778aab and 810c0719
> for limiting the maximum autoclose value.  If userspace passes in -1
> on 32-bit platform, the overflow check didn't work and autoclose
> would be set to 0xffffffff.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrei Pelinescu-Onciul <andrei@iptel.org>
> Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/sctp/socket.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 13bf5fc..bb91281 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2201,7 +2201,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
>  	if (copy_from_user(&sp->autoclose, optval, optlen))
>  		return -EFAULT;
>  	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
> -	sp->autoclose = min_t(long, sp->autoclose, MAX_SCHEDULE_TIMEOUT / HZ);
> +	sp->autoclose = min_t(unsigned long, sp->autoclose,
> +			      MAX_SCHEDULE_TIMEOUT / HZ);

I think this should be u32 since that's what sp->autoclose is.

-vlad

>  
>  	return 0;
>  }

