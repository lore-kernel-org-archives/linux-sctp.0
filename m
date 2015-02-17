From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 17 Feb 2015 13:11:27 +0000
Subject: Re: [PATCH 20/45] sctp.h: include stdint.h in userspace
Message-Id: <20150217131127.GB2729@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-21-git-send-email-mikko.rapeli@iki.fi>
In-Reply-To: <1424127948-22484-21-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 17, 2015 at 12:05:23AM +0100, Mikko Rapeli wrote:
> Fixes compilation error:
> 
> linux/sctp.h:652:2: error: unknown type name ‘uint32_t’
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  include/uapi/linux/sctp.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index ce70fe6..9fd31cf 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -53,7 +53,11 @@
>  #ifndef _UAPI_SCTP_H
>  #define _UAPI_SCTP_H
>  
> +#ifdef __KERNEL__
>  #include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
>  #include <linux/socket.h>
>  
>  typedef __s32 sctp_assoc_t;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
