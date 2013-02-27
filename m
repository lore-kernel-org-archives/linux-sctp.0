From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 27 Feb 2013 20:09:31 +0000
Subject: Re: [PATCH] net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS control message
Message-Id: <20130227200931.GB7993@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361994231-5355-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1361994231-5355-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>

On Wed, Feb 27, 2013 at 11:43:51AM -0800, Guenter Roeck wrote:
> Building sctp may fail with:
> 
> In function ‘copy_from_user’,
>     inlined from ‘sctp_getsockopt_assoc_stats’ at
>     net/sctp/socket.c:5656:20:
> arch/x86/include/asm/uaccess_32.h:211:26: error: call to
>     ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
>     buffer size is not provably correct
> 
> if built with W=1 due to a missing parameter size validation.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  net/sctp/socket.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index cedd9bf..0a5f2bf 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -5652,6 +5652,8 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
>  	/* User must provide at least the assoc id */
>  	if (len < sizeof(sctp_assoc_t))
>  		return -EINVAL;
> +	if (len > sizeof(struct sctp_assoc_stats))
> +		len = sizeof(struct sctp_assoc_stats);
>  
>  	if (copy_from_user(&sas, optval, len))
>  		return -EFAULT;
> -- 
> 1.7.9.7
> 
> 

Theres more than that going on here.  This will fix the warning, but the
function is written such that, if you pass in a size that is greater than the
size of a struct sctp_association, but less than a struct sctp_assoc_stats.  I'm
not sure that a partial stat struct is really that useful to people.  What if
you were to check for max(struct sctp_association, struct sctp_assoc_stats) as
your minimum length check, then just did a copy_from_user of that length.  It
would save you having to compute two lengths separately, since you could then
just do a copy_to_user(...,sizeof(struct sctp_assoc_stats), at the bottom of
that function.

Thanks!
Neil

