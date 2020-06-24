From: Corey Minyard <cminyard@mvista.com>
Date: Wed, 24 Jun 2020 20:53:27 +0000
Subject: Re: [PATCH net] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Message-Id: <20200624205327.GK3258@minyard.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200623160417.12418-1-minyard@acm.org>
 <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
In-Reply-To: <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Michael Tuexen <Michael.Tuexen@lurchi.franken.de>, Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jun 24, 2020 at 05:34:18PM -0300, Marcelo Ricardo Leitner wrote:
> If a socket is set ipv6only, it will still send IPv4 addresses in the
> INIT and INIT_ACK packets. This potentially misleads the peer into using
> them, which then would cause association termination.
> 
> The fix is to not add IPv4 addresses to ipv6only sockets.

Fixes the issue for me.

Tested-by: Corey Minyard <cminyard@mvista.com>

Thanks a bunch.

-corey

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Corey Minyard <cminyard@mvista.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  include/net/sctp/constants.h | 8 +++++---
>  net/sctp/associola.c         | 5 ++++-
>  net/sctp/bind_addr.c         | 1 +
>  net/sctp/protocol.c          | 3 ++-
>  4 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> index 15b4d9aec7ff278e67a7183f10c14be237227d6b..122d9e2d8dfde33b787d575fc42d454732550698 100644
> --- a/include/net/sctp/constants.h
> +++ b/include/net/sctp/constants.h
> @@ -353,11 +353,13 @@ enum {
>  	 ipv4_is_anycast_6to4(a))
>  
>  /* Flags used for the bind address copy functions.  */
> -#define SCTP_ADDR6_ALLOWED	0x00000001	/* IPv6 address is allowed by
> +#define SCTP_ADDR4_ALLOWED	0x00000001	/* IPv4 address is allowed by
>  						   local sock family */
> -#define SCTP_ADDR4_PEERSUPP	0x00000002	/* IPv4 address is supported by
> +#define SCTP_ADDR6_ALLOWED	0x00000002	/* IPv6 address is allowed by
> +						   local sock family */
> +#define SCTP_ADDR4_PEERSUPP	0x00000004	/* IPv4 address is supported by
>  						   peer */
> -#define SCTP_ADDR6_PEERSUPP	0x00000004	/* IPv6 address is supported by
> +#define SCTP_ADDR6_PEERSUPP	0x00000008	/* IPv6 address is supported by
>  						   peer */
>  
>  /* Reasons to retransmit. */
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 72315137d7e7f20d5182291ef4b01102f030078b..8d735461fa196567ab19c583703aad098ef8e240 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1565,12 +1565,15 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned int len)
>  int sctp_assoc_set_bind_addr_from_ep(struct sctp_association *asoc,
>  				     enum sctp_scope scope, gfp_t gfp)
>  {
> +	struct sock *sk = asoc->base.sk;
>  	int flags;
>  
>  	/* Use scoping rules to determine the subset of addresses from
>  	 * the endpoint.
>  	 */
> -	flags = (PF_INET6 = asoc->base.sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
> +	flags = (PF_INET6 = sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
> +	if (!inet_v6_ipv6only(sk))
> +		flags |= SCTP_ADDR4_ALLOWED;
>  	if (asoc->peer.ipv4_address)
>  		flags |= SCTP_ADDR4_PEERSUPP;
>  	if (asoc->peer.ipv6_address)
> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
> index 53bc61537f44f4e766c417fcef72234df52ecd04..701c5a4e441d9c248df9472f22db5b78987f9e44 100644
> --- a/net/sctp/bind_addr.c
> +++ b/net/sctp/bind_addr.c
> @@ -461,6 +461,7 @@ static int sctp_copy_one_addr(struct net *net, struct sctp_bind_addr *dest,
>  		 * well as the remote peer.
>  		 */
>  		if ((((AF_INET = addr->sa.sa_family) &&
> +		      (flags & SCTP_ADDR4_ALLOWED) &&
>  		      (flags & SCTP_ADDR4_PEERSUPP))) ||
>  		    (((AF_INET6 = addr->sa.sa_family) &&
>  		      (flags & SCTP_ADDR6_ALLOWED) &&
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 092d1afdee0d23cd974210839310fbf406dd443f..cde29f3c7fb3c40ee117636fa3b4b7f0a03e4fba 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -148,7 +148,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
>  		 * sock as well as the remote peer.
>  		 */
>  		if (addr->a.sa.sa_family = AF_INET &&
> -		    !(copy_flags & SCTP_ADDR4_PEERSUPP))
> +		    (!(copy_flags & SCTP_ADDR4_ALLOWED) ||
> +		     !(copy_flags & SCTP_ADDR4_PEERSUPP)))
>  			continue;
>  		if (addr->a.sa.sa_family = AF_INET6 &&
>  		    (!(copy_flags & SCTP_ADDR6_ALLOWED) ||
> -- 
> 2.25.4
> 
