From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 21 Jun 2008 15:55:19 +0000
Subject: Re: [PATCH]: SCTP length validation.
Message-Id: <485D2467.7020300@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080620.221205.183623344.davem@davemloft.net>
In-Reply-To: <20080620.221205.183623344.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

David Miller wrote:
> I just checked in the following SCTP bug fix to net-2.6 and will make
> sure it gets into -stable as well.
> 
> sctp: Make sure N * sizeof(union sctp_addr) does not overflow.
> 
> As noticed by Gabriel Campana, the kmalloc() length arg
> passed in by sctp_getsockopt_local_addrs_old() can overflow
> if ->addr_num is large enough.
> 
> Therefore, enforce an appropriate limit.

Hi David

The same vulnerability also exists in sctp_getsockopt_peer_addrs_old().
It's a bit more difficult to trigger since there is a dependency on
the peer being multihomed as well, but it's still possible to cause the
overwrite.

-vlad

> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/sctp/socket.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index e7e3baf..0dbcde6 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4401,7 +4401,9 @@ static int sctp_getsockopt_local_addrs_old(struct sock *sk, int len,
>  	if (copy_from_user(&getaddrs, optval, len))
>  		return -EFAULT;
>  
> -	if (getaddrs.addr_num <= 0) return -EINVAL;
> +	if (getaddrs.addr_num <= 0 ||
> +	    getaddrs.addr_num >= (INT_MAX / sizeof(union sctp_addr)))
> +		return -EINVAL;
>  	/*
>  	 *  For UDP-style sockets, id specifies the association to query.
>  	 *  If the id field is set to the value '0' then the locally bound

