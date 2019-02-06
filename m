From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 06 Feb 2019 20:37:54 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190206203754.GC13621@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
In-Reply-To: <20190206201430.18830-1-julien@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julien Gomes <julien@arista.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com, vyasevich@gmail.com, lucien.xin@gmail.com

On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> structures longer than the current definitions.
> 
> This should prevent unjustified setsockopt() failures due to struct
> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> binaries that should be compatible, but were built with later kernel
> uapi headers.

Not sure if we support backwards compatibility like this?

My issue with this change is that by doing this, application will have
no clue if the new bits were ignored or not and it may think that an
event is enabled while it is not.

A workaround would be to do a getsockopt and check the size that was
returned. But then, it might as well use the right struct here in the
first place.

I'm seeing current implementation as an implicitly versioned argument:
it will always accept setsockopt calls with an old struct (v4.11 or
v4.12), but if the user tries to use v3 on a v1-only system, it will
be rejected. Pretty much like using a newer setsockopt on an old
system.

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
>  	if (copy_from_user(&subscribe, optval, optlen))
>  		return -EFAULT;
> -- 
> 2.20.1
> 
