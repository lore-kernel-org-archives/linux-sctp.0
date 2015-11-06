From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 06 Nov 2015 14:26:10 +0000
Subject: Re: When will Linux implement SCTP protocol conforming to RFC4960?
Message-Id: <20151106142610.GB3644@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001c01d11891$db652ae0$922f80a0$@tom.com>
In-Reply-To: <001c01d11891$db652ae0$922f80a0$@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Fri, Nov 06, 2015 at 08:51:20PM +0800, lemonskin wrote:
> Dear experts,
> 
> From comments of Linux source code v4.2.3, I find the SCTP code is
> implemented still conforming to RFC2960.
> Do we have any plan to implement the latest RFC4960 standard in Linux? If
> so, when can we expect it to be done?

What makes you think so? We do support RFC4960. It's even listed in
http://lksctp.sourceforge.net/  that's the site for the userspace lib
but it's minimal, 99% of the implementation is on kernel and should be
compliant with RFC4960.

  Marcelo
