From: Max Matveev <makc@redhat.com>
Date: Tue, 21 Jun 2011 01:29:17 +0000
Subject: Re: [PATCH] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem
Message-Id: <19967.62445.750971.946481@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <19967.385.752160.374716@regina.usersys.redhat.com>
In-Reply-To: <19967.385.752160.374716@regina.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, 20 Jun 2011 17:41:07 +0800, Shan Wei wrote:

 shanwei> Max Matveev wrote, at 06/20/2011 04:36 PM:
 >> On Mon, 20 Jun 2011 16:29:25 +0800, Shan Wei wrote:
 >> 
 >> +	Default: 1 page

 shanwei> how about 4K?

Not everybody uses 4K pages. I can change it to 4K but it will be
(technically) incorrect.

 >> 
 >> sctp_wmem  - vector of 3 INTEGERs: min, default, max
 >> -	See tcp_wmem for a description.
 >> +	Only the first value ("min") is used, "default" and "max" are
 >> +	ignored and may be removed in the future versions.

 shanwei> sctp_wmem parameter include all three fields never be used
 shanwei> by sctp protocol.  The min value is not used.

I was trying to avoid the embarrassment of admitting that there is a
tunable which does nothing. Should I add another patch to remove
the tunable?

max
