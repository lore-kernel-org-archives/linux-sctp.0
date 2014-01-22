From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 22 Jan 2014 19:45:41 +0000
Subject: Re: MD5 HMAC in FIPS mode
Message-Id: <20140122194541.GB14646@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVVLAddsidEeBQ879UcMsiaxo3g2kTVqNJUj6VUAYhXkQ@mail.gmail.com>
In-Reply-To: <CAGugRbVVLAddsidEeBQ879UcMsiaxo3g2kTVqNJUj6VUAYhXkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jan 22, 2014 at 07:46:02PM +0100, Daniel Borkmann wrote:
> On 01/22/2014 07:23 PM, Karl Heiss wrote:
> >When fips=1 is set on the kernel command line, the hmac(md5) algorithm
> >is not usable.  This leads to errors when listen() is called with the
> >default configuration.  So this leads me to the following questions:
> >
> >Does it make sense to change the default value when fips mode is
> >enabled?  If so, does it make more sense to handle it in userspace via
> >sysctl, or enforce directly in the SCTP stack?  It seems easy enough
> >to check for the fips_enabled variable and disallow setting md5
> >through the kernel directly.
> 
> Indeed it seems easy enough, but I think we should not do any
> special treatment in SCTP whereas the rest of the code is not
> handling fips_enabled, imho.
> 
> You can choose default alg in Kconfig at compile time or select
> a different algorithm through cookie_hmac_alg sysctl already.
> If a kernel is specifically built for fips mode, then that would
> be the better option in my opinion.
Daniel is exactly right here.  We modified the config method so that at build
time the default cookie algorithm can be selected, specifcially so people could
build sctp in such a way as to work by default in FIPS mode.

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
