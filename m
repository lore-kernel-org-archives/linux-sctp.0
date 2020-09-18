From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 18 Sep 2020 13:29:57 +0000
Subject: Re: [PATCH] net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant
Message-Id: <20200918132957.GB82043@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200918015610.3596417-1-hptasinski@google.com>
In-Reply-To: <20200918015610.3596417-1-hptasinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Henry Ptasinski <hptasinski@google.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Corey Minyard <cminyard@mvista.com>

On Fri, Sep 18, 2020 at 01:56:10AM +0000, Henry Ptasinski wrote:
> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.

Makes sense.

> 
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Please add a:
Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")

> ---
>  net/sctp/socket.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 836615f71a7d..a6358c81f087 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9220,12 +9220,14 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
>  static inline void sctp_copy_descendant(struct sock *sk_to,
          ^^^^^^  I'll send a patch to fix/remove this.

>  					const struct sock *sk_from)
>  {
> -	int ancestor_size = sizeof(struct inet_sock) +
> -			    sizeof(struct sctp_sock) -
> -			    offsetof(struct sctp_sock, pd_lobby);
                                                       ^^^^^^^^

Then, as this patch is actually fixing the aforementioned commit,
please also update the comment on sctp_sock definition, as pd_lobby
now is also skipped.

> +	size_t ancestor_size = sizeof(struct inet_sock);
>  
>  	if (sk_from->sk_family = PF_INET6)
> -		ancestor_size += sizeof(struct ipv6_pinfo);
> +		ancestor_size += sizeof(struct sctp6_sock);

As you probably noticed by the build bot email already, there need to
be some protection to building without IPv6 enabled.

To avoid ifdefs here, something similar to how
inet_sk_copy_descendant() is done is probably welcomed, but please
feel free to be creative. :-)

> +	else
> +		ancestor_size += sizeof(struct sctp_sock);
> +
> +	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
>  
>  	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
>  }
> -- 
> 2.28.0.681.g6f77f65b4e-goog
> 
