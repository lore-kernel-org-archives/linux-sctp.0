From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 07 Jan 2013 17:41:22 +0000
Subject: Re: [PATCH] sctp: fix Kconfig bug in default cookie hmac selection
Message-Id: <20130107174122.GG31577@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <50EAFC32.9030104@inktank.com>
In-Reply-To: <50EAFC32.9030104@inktank.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jan 07, 2013 at 10:47:46AM -0600, Alex Elder wrote:
> The following commit added a "choice" to the sctp Kconfig file.  It
> introduced a bug which led to an infinite loop when while running
> "make oldconfig".
> 
>     0d0863b0 sctp: Change defaults on cookie hmac selection
> 
> The problem is that the wrong symbol was defined as the default
> value for the choice.  Using the correct value gets rid of the
> infinite loop.
> 
> Note:  if CONFIG_SCTP_COOKIE_HMAC_SHA1=y was present in the input
> config file, both that and CONFIG_SCTP_COOKIE_HMAC_MD5=y be present
> in the generated config file.
> 
> Signed-off-by: Alex Elder <elder@inktank.com>
> ---
>  net/sctp/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
> index c262106..7521d94 100644
> --- a/net/sctp/Kconfig
> +++ b/net/sctp/Kconfig
> @@ -68,7 +68,7 @@ config SCTP_DBG_OBJCNT
>  	  If unsure, say N
>  choice
>  	prompt "Default SCTP cookie HMAC encoding"
> -	default SCTP_COOKIE_HMAC_MD5
> +	default SCTP_DEFAULT_COOKIE_HMAC_MD5
>  	help
>  	  This option sets the default sctp cookie hmac algorithm
>  	  when in doubt select 'md5'
> -- 
> 1.7.9.5
> 
> 
I really, _really_ don't like this.  This does exactly what I was talking about
before, in that it resolves the loop, but it does so by silently overriding the
pre-existing configuration, which I think is wrong.  Vlad and I have discussed
it though, and he's convinced me that, despite the silent override, the rest of
the kernel behaves the same arguably broken way, so we may as well have this
operate in the same way.  I would really far prefer that the config looped to
make you select a default that was't in conflict with your existing config, but
I guess those who care to select non-deafult options will catch the change
anyway, and if you just hit enter, you have to expect changes.

Acked-by: Neil Horman <nhorman@tuxriver.com>

