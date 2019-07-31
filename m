From: Joe Perches <joe@perches.com>
Date: Wed, 31 Jul 2019 16:35:31 +0000
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-Id: <b93bbb17b407e27bb1dc196af84e4f289d9dfd93.camel@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
         <20190731111932.GA9823@hmswarspite.think-freely.org>
         <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
         <20190731121646.GD9823@hmswarspite.think-freely.org>
In-Reply-To: <20190731121646.GD9823@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> > > > fallthrough may become a pseudo reserved keyword so this only use of
> > > > fallthrough is better renamed to allow it.
> > > > 
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > Are you referring to the __attribute__((fallthrough)) statement that gcc
> > > supports?  If so the compiler should by all rights be able to differentiate
> > > between a null statement attribute and a explicit goto and label without the
> > > need for renaming here.  Or are you referring to something else?
> > 
> > Hi.
> > 
> > I sent after this a patch that adds
> > 
> > # define fallthrough                    __attribute__((__fallthrough__))
> > 
> > https://lore.kernel.org/patchwork/patch/1108577/
> > 
> > So this rename is a prerequisite to adding this #define.
> > 
> why not just define __fallthrough instead, like we do for all the other
> attributes we alias (i.e. __read_mostly, __protected_by, __unused, __exception,
> etc)

Because it's not as intelligible when used as a statement.
