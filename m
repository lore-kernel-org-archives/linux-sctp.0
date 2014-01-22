From: Karl Heiss <kheiss@gmail.com>
Date: Wed, 22 Jan 2014 18:23:21 +0000
Subject: MD5 HMAC in FIPS mode
Message-Id: <CAGugRbVVLAddsidEeBQ879UcMsiaxo3g2kTVqNJUj6VUAYhXkQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When fips=1 is set on the kernel command line, the hmac(md5) algorithm
is not usable.  This leads to errors when listen() is called with the
default configuration.  So this leads me to the following questions:

Does it make sense to change the default value when fips mode is
enabled?  If so, does it make more sense to handle it in userspace via
sysctl, or enforce directly in the SCTP stack?  It seems easy enough
to check for the fips_enabled variable and disallow setting md5
through the kernel directly.

Regards,
Karl
