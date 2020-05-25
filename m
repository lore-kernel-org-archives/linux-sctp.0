From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 25 May 2020 21:18:47 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-Id: <20200525211847.GD2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
In-Reply-To: <20200523071929.GA10466@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>
Cc: David Laight <David.Laight@aculab.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Sat, May 23, 2020 at 09:19:29AM +0200, 'Christoph Hellwig' wrote:
> On Fri, May 22, 2020 at 11:36:23AM -0300, Marcelo Ricardo Leitner wrote:
...
> > What if you two work on a joint patchset for this? The proposals are
> > quite close. The differences around the setsockopt handling are
> > minimal already. It is basically variable naming, indentation and one
> > or another small change like:
> 
> I don't really want to waste too much time on this, as what I really
> need is to get the kernel_setsockopt removal series in ASAP.  I'm happy
> to respin this once or twice with clear maintainer guidance (like the
> memzero_explicit), but I have no idea what you even meant with your
> other example or naming.  Tell me what exact changes you want, and
> I can do a quick spin, but I don't really want a huge open ended
> discussion on how to paint the bikeshed..

What I meant is that the 2 proposals were very close already, with
only minimal differences. As David had posted his set first and you
didn't add a RFC tag nor stated that you were just sharing the
patches, I understood it was an alternative approach to David's, which
is not optimal here. This topic is far from being that polemic, that
could benefit from having 2 competing approaches. So first I wanted a
joint approach, and then build on it.

For now lets see how David's new patchset will look like. It was
almost there already.

> 
> Alternatively I'll also happily only do a partial conversion for what
> I need for the kernel_setsockopt removal and let you and Dave decided
> what you guys prefer for the rest.
