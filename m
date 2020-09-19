From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 19 Sep 2020 02:05:49 +0000
Subject: Re: [PATCH v2] net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant
Message-Id: <20200919020549.GA70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200918132957.GB82043@localhost.localdomain>
 <20200919001211.355148-1-hptasinski@google.com>
In-Reply-To: <20200919001211.355148-1-hptasinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Henry Ptasinski <hptasinski@google.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Corey Minyard <cminyard@mvista.com>

On Sat, Sep 19, 2020 at 12:12:11AM +0000, Henry Ptasinski wrote:
> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.
> 
> Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

...
>  {
> -	int ancestor_size = sizeof(struct inet_sock) +
> -			    sizeof(struct sctp_sock) -
> -			    offsetof(struct sctp_sock, pd_lobby);
> -
> -	if (sk_from->sk_family = PF_INET6)
> -		ancestor_size += sizeof(struct ipv6_pinfo);
> +	size_t ancestor_size = sizeof(struct inet_sock);
>  
> +	ancestor_size += sk_from->sk_prot->obj_size;

Heh, of course. Nice one.

> +	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
>  	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
>  }
>  
> -- 
> 2.28.0.681.g6f77f65b4e-goog
> 
