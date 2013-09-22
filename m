From: "George Spelvin" <linux@horizon.com>
Date: Sun, 22 Sep 2013 08:09:59 +0000
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Message-Id: <20130922080959.384.qmail@science.horizon.com>
List-Id: <linux-sctp.vger.kernel.org>
In-Reply-To: <201309210928.JCF90671.OtOFLFQSOJVFMH@I-love.SAKURA.ne.jp>
References: <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
In-Reply-To: <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jslaby@suse.cz, keescook@chromium.org, penguin-kernel@I-love.SAKURA.ne.jp
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, geert@linux-m68k.org, JBeulich@suse.com, joe@perches.com, kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, linux@horizon.com, netdev@vger.kernel.org, remi.denis-courmont@nokia.com, viro@zeniv.linux.org.uk, xemul@openvz.org

> If you want, we can rename seq_pad() to seq_pad_and_putc(). Also we can pass
> both the padding character (e.g. ' ') and the trailing character (e.g. '\n')
> like seq_pad_and_putc((' ' << 8) | '\n'), though I wonder someone wants to
> use '\0', '\t', '\n' etc. as the padding character...

How about let that complexity wait until it's needed?  It's not like
it's that big a PITA of a patch to write, and there's a significant
chance it will *never* be needed.
