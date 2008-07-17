From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Date: Thu, 17 Jul 2008 15:04:40 +0000
Subject: Re: SCTP_HMAC_NONE config variable is unused
Message-Id: <alpine.LFD.1.10.0807171104070.6567@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.LFD.1.10.0807171031190.6160@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807171031190.6160@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, 17 Jul 2008, Vlad Yasevich wrote:

> Robert P. J. Day wrote:
> >   that config variable is defined but unreferenced anywhere in the
> > tree.
> >
> > rday
>
> Yep.  It could probably be use used here:
>
> include/net/sctp/constants.h:
>
> #if defined (CONFIG_SCTP_HMAC_MD5)
> #define SCTP_COOKIE_HMAC_ALG "hmac(md5)"
> #elif defined (CONFIG_SCTP_HMAC_SHA1)
> #define SCTP_COOKIE_HMAC_ALG "hmac(sha1)"
> #else
> #define SCTP_COOKIE_HMAC_ALG NULL
> #endif
>
>
> the final '#else' can be:
>
> #elif defined (CONFIG_SCTP_HMAC_NONE)
>
>
> An alternative would be to change the 'choice' in Kconfig
> to something else that allows us to have a 'none' selection.
>
> Is this really a problem?

no, sorry, i just didn't look closely enough to note that it was a
default selection.  just ignore that last noise.

rday
--
====================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
====================================
