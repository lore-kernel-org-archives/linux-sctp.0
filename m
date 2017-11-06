From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 06 Nov 2017 22:09:22 +0000
Subject: Re: [PATCH] sctp: Fix len returned by getsockopt(sk, SCTP_GET_LOCAL_ADDRS, opt, &len)
Message-Id: <20171106220921.GB20024@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171106133955.GA31556@bordel.klfree.net>
In-Reply-To: <20171106133955.GA31556@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Nov 06, 2017 at 02:39:56PM +0100, Petr Malat wrote:
> A call to
>   getsockopt(sk, SCTP_GET_LOCAL_ADDRS, opt, &optlen)
> returns a wrong value in optlen, because it doesn't account struct sctp_getaddrs
> preceding the actual addresses.
> 
> Signed-off-by: Petr Malat <petr.malat.ext@nokia.com>
> ---
>  net/sctp/socket.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 6f45d17..9082269 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -5560,6 +5560,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
>  		err = -EFAULT;
>  		goto out;
>  	}
> +	bytes_copied += offsetof(struct sctp_getaddrs, addrs);
>  	if (put_user(bytes_copied, optlen))
>  		err = -EFAULT;
Acked-by: Neil Horman <nhorman@tuxdriver.com>

>  out:
> -- 
> 1.7.11.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
