From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 27 Feb 2013 21:00:42 +0000
Subject: Re: [PATCH v2] net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS
Message-Id: <512E73FA.1090407@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361998651-19354-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1361998651-19354-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>

On 02/27/2013 03:57 PM, Guenter Roeck wrote:
> Building sctp may fail with:
>
> In function ‘copy_from_user’,
>      inlined from ‘sctp_getsockopt_assoc_stats’ at
>      net/sctp/socket.c:5656:20:
> arch/x86/include/asm/uaccess_32.h:211:26: error: call to
>      ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
>      buffer size is not provably correct
>
> if built with W=1 due to a missing parameter size validation
> before the call to copy_from_user.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Fix by moving the existing parameter size validation up
>      in the function instead of adding an additional one.

This works too...

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

>
>   net/sctp/socket.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index cedd9bf..9ef5c73 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -5653,6 +5653,9 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
>   	if (len < sizeof(sctp_assoc_t))
>   		return -EINVAL;
>
> +	/* Allow the struct to grow and fill in as much as possible */
> +	len = min_t(size_t, len, sizeof(sas));
> +
>   	if (copy_from_user(&sas, optval, len))
>   		return -EFAULT;
>
> @@ -5686,9 +5689,6 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
>   	/* Mark beginning of a new observation period */
>   	asoc->stats.max_obs_rto = asoc->rto_min;
>
> -	/* Allow the struct to grow and fill in as much as possible */
> -	len = min_t(size_t, len, sizeof(sas));
> -
>   	if (put_user(len, optlen))
>   		return -EFAULT;
>
>

