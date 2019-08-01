From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 01 Aug 2019 20:48:04 +0000
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-Id: <20190801204804.GB11487@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
 <20190731111932.GA9823@hmswarspite.think-freely.org>
 <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
 <20190731121646.GD9823@hmswarspite.think-freely.org>
 <b93bbb17b407e27bb1dc196af84e4f289d9dfd93.camel@perches.com>
 <20190731205804.GE9823@hmswarspite.think-freely.org>
 <d68403ce9f7e8a68fff09d6b17e5d1327eb1e12d.camel@perches.com>
 <20190801105051.GA11487@hmswarspite.think-freely.org>
 <a9d003ddd0d59fb144db3ecda3453b3d9c0cb139.camel@perches.com>
In-Reply-To: <a9d003ddd0d59fb144db3ecda3453b3d9c0cb139.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 01, 2019 at 10:42:31AM -0700, Joe Perches wrote:
> On Thu, 2019-08-01 at 06:50 -0400, Neil Horman wrote:
> > On Wed, Jul 31, 2019 at 03:23:46PM -0700, Joe Perches wrote:
> []
> > You can say that if you want, but you made the point that your think the macro
> > as you have written is more readable.  You example illustrates though that /*
> > fallthrough */ is a pretty common comment, and not prefixing it makes it look
> > like someone didn't add a comment that they meant to.  The __ prefix is standard
> > practice for defining macros to attributes (212 instances of it by my count).  I
> > don't mind rewriting the goto labels at all, but I think consistency is
> > valuable.
> 
> Hey Neil.
> 
> Perhaps you want to make this argument on the RFC patch thread
> that introduces the fallthrough pseudo-keyword.
> 
> https://lore.kernel.org/patchwork/patch/1108577/
> 
> 
> 
Sure, but it will have to wait for tomorrow at this point, as I need to run to
an appointment.

Best
Neil
