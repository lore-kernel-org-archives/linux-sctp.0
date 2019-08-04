From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 04 Aug 2019 19:26:12 +0000
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-Id: <20190804192612.GA17184@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
 <20190731121646.GD9823@hmswarspite.think-freely.org>
 <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
 <20190802.161932.1776993765494484851.davem@davemloft.net>
In-Reply-To: <20190802.161932.1776993765494484851.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, vyasevich@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 02, 2019 at 04:19:32PM -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Fri, 02 Aug 2019 10:47:34 -0700
> 
> > On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
> >> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
> >> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> >> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> >> > > > fallthrough may become a pseudo reserved keyword so this only use of
> >> > > > fallthrough is better renamed to allow it.
> > 
> > Can you or any other maintainer apply this patch
> > or ack it so David Miller can apply it?
> 
> I, like others, don't like the lack of __ in the keyword.  It's kind of
> rediculous the problems it creates to pollute the global namespace like
> that and yes also inconsistent with other shorthands for builtins.
> 
FWIW, I acked the sctp patch, because the use of the word fallthrough as a
label, isn't that important to me, unhendled is just as good, so I'm ok with
that change.

But, as I stated in the other thread, I agree, making a macro out of fallthrough
without clearly naming it using a macro convention like __ is not something I'm
ok with
Neil
