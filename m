From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 18 Feb 2015 15:48:04 +0000
Subject: Re: [PATCH 20/45] sctp.h: include stdint.h in userspace
Message-Id: <54E4B434.3030302@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-21-git-send-email-mikko.rapeli@iki.fi>
In-Reply-To: <1424127948-22484-21-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/17/2015 12:05 AM, Mikko Rapeli wrote:
> Fixes compilation error:
>
> linux/sctp.h:652:2: error: unknown type name ‘uint32_t’
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>

I have no idea where the rest of this series went (neither netdev, nor
lkml, nor linux-sctp) and what user space application making use of the
header you are trying to fix !?

> ---
>   include/uapi/linux/sctp.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index ce70fe6..9fd31cf 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -53,7 +53,11 @@
>   #ifndef _UAPI_SCTP_H
>   #define _UAPI_SCTP_H
>
> +#ifdef __KERNEL__
>   #include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
>   #include <linux/socket.h>

Looks ugly, but could also be resolved in user space.
