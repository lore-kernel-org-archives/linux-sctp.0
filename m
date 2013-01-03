From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 03 Jan 2013 16:52:46 +0000
Subject: Re: Config Loop
Message-Id: <20130103165246.GA6891@shamino.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <50E5AA59.3010109@inktank.com>
In-Reply-To: <50E5AA59.3010109@inktank.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jan 03, 2013 at 09:57:13AM -0600, Alex Elder wrote:
> A commit added in the 3.8-rc1 merge window has resulted in
> my kernel config entering an infinite loop handling the
> "Default SCTP cookie HMAC encoding" option.
> 
>     commit 0d0863b02002c25140a1b9e113b81211bcc780e8
>     sctp: Change defaults on cookie hmac selection
> 
>     http://marc.info/?l=linux-netdev&m5553459303505
> 
> The problem lies in my config file containing this line:
> 
>     CONFIG_SCTP_HMAC_MD5=y
> 
> I normally configure my kernel using fixed config file
> (occasionally updated) using (roughly) this:
> 
>     yes "" | make oldconfig
> 
> The result looks like this:
> 
> . . .
>   DCCP connection probing (NET_DCCPPROBE) [M/n/?] m
> *
> * The SCTP Protocol (EXPERIMENTAL)
> *
> The SCTP Protocol (EXPERIMENTAL) (IP_SCTP) [M/y/?] m
>   SCTP: Association probing (NET_SCTPPROBE) [M/n/?] m
>   SCTP: Debug messages (SCTP_DBG_MSG) [N/y/?] n
>   SCTP: Debug object counts (SCTP_DBG_OBJCNT) [N/y/?] n
>   Default SCTP cookie HMAC encoding
>     1. Enable optional MD5 hmac cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
>     2. Enable optional SHA1 hmac cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
>     3. Use no hmac alg in SCTP cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
>   choice[1-3?]:   Default SCTP cookie HMAC encoding
>     1. Enable optional MD5 hmac cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
>     2. Enable optional SHA1 hmac cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
>     3. Use no hmac alg in SCTP cookie generation
> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
>   choice[1-3?]:   Default SCTP cookie HMAC encoding
> . . .  and so on.
> 
> I find that I can correct this with the patch below.
> I expect others will bump into the same problem.  In
> particular, I notice my Ubuntu config files contain
> that same line.
> 
> I don't know how best to handle this, but I thought
> I would report it in case someone has a good solution.
> 
Thats odd.  It looks like your selection of a defaut value for the sctp cookie
hmac algorithm isn't taking at all.  I just added the old CONFIG_SCTP_HMAC_MD5=y
option to my config and used your:
yes "" | make oldconfig 
setup, and it worked fine for me.  And you say if you remove the old config
option first, you get no loop?

Neil

> 					-Alex
> 
>  arch/x86/configs/autobuild |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/arch/x86/configs/autobuild
> =================================> --- a/arch/x86/configs/autobuild
> +++ b/arch/x86/configs/autobuild
> @@ -940,7 +940,7 @@ CONFIG_NET_SCTPPROBE=m
>  # CONFIG_SCTP_DBG_OBJCNT is not set
>  # CONFIG_SCTP_HMAC_NONE is not set
>  # CONFIG_SCTP_HMAC_SHA1 is not set
> -CONFIG_SCTP_HMAC_MD5=y
> +CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
>  CONFIG_RDS=m
>  CONFIG_RDS_RDMA=m
>  CONFIG_RDS_TCP=m
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
