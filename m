From: "David Laight" <David.Laight@ACULAB.COM>
Date: Mon, 29 Oct 2012 15:07:07 +0000
Subject: RE: [PATCH] sctp: Clean up type-punning in sctp_cmd_t union
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B7076@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20121026132422.GA25087@hmsreliant.think-freely.org><508AE08B.8070303@gmail.com><20121026203504.GD25087@hmsreliant.think-freely.org> <20121026.171019.702275326710216395.davem@davemloft.net>
In-Reply-To: <20121026.171019.702275326710216395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, nhorman@tuxdriver.com
Cc: vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

> > On Fri, Oct 26, 2012 at 03:12:11PM -0400, Vlad Yasevich wrote:
> >> Look at commit 19c7e9ee that introduced this.  I don't remember all
> >> the details any more, but the problem only occurred on ia64
> >> (probably due its speculative load handling).
> >>
> >> -vlad
> >>
> > Thanks Vlad, I'll have a look see.
> 
> Ok, so this IA64 issue is all about accesses to uninitialized memory.
> 
> I think Neil's change is thus the most desirable thing to do.  Simple
> memset the object to zero.

I'd guess it an artifact of the C memory aliasing rules and unions.
If you write to a location as a one type but read it as another type
(and neither type is char) then the compiler is generally allowed to
schedule the read before the write (and may even optimise the write away).
This shouldn't happen if the fields are both members of the same union,
but casting some other address to a 'union *' separately for the
write and read isn't enough.

This probably means that this entire type-punning argument passing
scheme is actually broken.

	David



