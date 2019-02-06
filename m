From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 06 Feb 2019 20:49:42 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190206204942.GB16887@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
In-Reply-To: <20190206201430.18830-1-julien@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julien Gomes <julien@arista.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, marcelo.leitner@gmail.com, vyasevich@gmail.com, lucien.xin@gmail.com

On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> structures longer than the current definitions.
> 
> This should prevent unjustified setsockopt() failures due to struct
> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> binaries that should be compatible, but were built with later kernel
> uapi headers.
> 
> Signed-off-by: Julien Gomes <julien@arista.com>
> ---
>  net/sctp/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9644bdc8e85c..f9717e2789da 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2311,7 +2311,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
>  	int i;
>  
>  	if (optlen > sizeof(struct sctp_event_subscribe))
> -		return -EINVAL;
> +		optlen = sizeof(struct sctp_event_subscribe);
>  
I'm not sure I like this.  If you have a userspace application built against
more recent uapi headers than the kernel you are actually running on, then by
defintion you won't have this check in place, and you'll get EINVAL returns
anyway.  If you just backport this patch to an older kernel, you'll not get the
EINVAL return, but you will get silent failures on event subscriptions that your
application thinks exists, but the kernel doesn't recognize.  

This would make sense if you had a way to communicate back to user space the
unrecognized options, but since we don't (currently) have that, I would rather
see the EINVAL returned than just have things not work.

Neil

>  	if (copy_from_user(&subscribe, optval, optlen))
>  		return -EFAULT;
> -- 
> 2.20.1
> 
> 
