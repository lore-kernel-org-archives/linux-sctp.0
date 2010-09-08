From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 08 Sep 2010 20:19:02 +0000
Subject: Re: [PATCH v2] sctp: prevent reading out-of-bounds memory
Message-Id: <4C87EFB6.2000101@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTimtTXpeywA64xUDHZP2RrrtrswyvEB9KeYqhrgU@mail.gmail.com>
In-Reply-To: <AANLkTimtTXpeywA64xUDHZP2RrrtrswyvEB9KeYqhrgU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/03/2010 01:21 PM, Dan Rosenberg wrote:
> Two user-controlled allocations in SCTP are subsequently dereferenced
> as sockaddr structs, without checking if the dereferenced struct
> members fall beyond the end of the allocated chunk.  There doesn't
> appear to be any information leakage here based on how these members
> are used and additional checking, but it's still worth fixing.
> 
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 

Acked-By: Vlad Yasevich <vladislav.yasevich@hp.com>

-vlad

> --- linux-2.6.35.4.orig/net/sctp/socket.c       2010-09-03
> 08:58:48.127080114 -0400
> +++ linux-2.6.35.4/net/sctp/socket.c    2010-09-03 11:52:28.239595395 -0400
> @@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       kfree(kaddrs);
> +                       return -EINVAL;
> +               }
> +
>                sa_addr = (struct sockaddr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa_family);
> 
> @@ -1002,9 +1008,14 @@ static int __sctp_connect(struct sock* s
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       err = -EINVAL;
> +                       goto out_free;
> +               }
> +
>                sa_addr = (union sctp_addr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa.sa_family);
> -               port = ntohs(sa_addr->v4.sin_port);
> 
>                /* If the address family is not supported or if this address
>                 * causes the address buffer to overflow return EINVAL.
> @@ -1013,6 +1024,8 @@ static int __sctp_connect(struct sock* s
>                        err = -EINVAL;
>                        goto out_free;
>                }
> +
> +               port = ntohs(sa_addr->v4.sin_port);
> 
>                /* Save current address so we can work with it */
>                memcpy(&to, sa_addr, af->sockaddr_len);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

