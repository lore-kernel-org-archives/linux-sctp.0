From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 22 Jan 2014 18:46:02 +0000
Subject: Re: MD5 HMAC in FIPS mode
Message-Id: <52E011EA.8010802@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVVLAddsidEeBQ879UcMsiaxo3g2kTVqNJUj6VUAYhXkQ@mail.gmail.com>
In-Reply-To: <CAGugRbVVLAddsidEeBQ879UcMsiaxo3g2kTVqNJUj6VUAYhXkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/22/2014 07:23 PM, Karl Heiss wrote:
> When fips=1 is set on the kernel command line, the hmac(md5) algorithm
> is not usable.  This leads to errors when listen() is called with the
> default configuration.  So this leads me to the following questions:
>
> Does it make sense to change the default value when fips mode is
> enabled?  If so, does it make more sense to handle it in userspace via
> sysctl, or enforce directly in the SCTP stack?  It seems easy enough
> to check for the fips_enabled variable and disallow setting md5
> through the kernel directly.

Indeed it seems easy enough, but I think we should not do any
special treatment in SCTP whereas the rest of the code is not
handling fips_enabled, imho.

You can choose default alg in Kconfig at compile time or select
a different algorithm through cookie_hmac_alg sysctl already.
If a kernel is specifically built for fips mode, then that would
be the better option in my opinion.
