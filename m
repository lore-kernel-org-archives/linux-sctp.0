From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 17 Jul 2008 14:49:47 +0000
Subject: Re: SCTP_HMAC_NONE config variable is unused
Message-Id: <487F5C0B.80704@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.LFD.1.10.0807171031190.6160@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807171031190.6160@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Robert P. J. Day wrote:
>   that config variable is defined but unreferenced anywhere in the
> tree.
> 
> rday

Yep.  It could probably be use used here:

include/net/sctp/constants.h:

#if defined (CONFIG_SCTP_HMAC_MD5)
#define SCTP_COOKIE_HMAC_ALG "hmac(md5)"
#elif defined (CONFIG_SCTP_HMAC_SHA1)
#define SCTP_COOKIE_HMAC_ALG "hmac(sha1)"
#else
#define SCTP_COOKIE_HMAC_ALG NULL
#endif


the final '#else' can be:

#elif defined (CONFIG_SCTP_HMAC_NONE)


An alternative would be to change the 'choice' in Kconfig
to something else that allows us to have a 'none' selection.

Is this really a problem?

-vlad
