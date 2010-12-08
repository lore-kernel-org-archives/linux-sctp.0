From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 08 Dec 2010 05:50:45 +0000
Subject: Re: [34/44] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
Message-Id: <1291787445.5324.64.camel@edumazet-laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101208003205.GA4286@kroah.com>
	 <20101208000642.975564500@clark.site>
	 <AANLkTimTw3O-OM-5Cgv0ELNj8SmMjaaeMHMd2NNezxi7@mail.gmail.com>
	 <20101208041656.GA2291@suse.de>
In-Reply-To: <20101208041656.GA2291@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, stable@kernel.org, "David S. Miller" <davem@davemloft.net>, stable-review@kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Robin Holt <holt@sgi.com>, Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>

Le mardi 07 décembre 2010 à 20:16 -0800, Greg KH a écrit :
> On Tue, Dec 07, 2010 at 05:22:34PM -0800, Linus Torvalds wrote:
> > On Tue, Dec 7, 2010 at 4:04 PM, Greg KH <gregkh@suse.de> wrote:
> > >
> > > From: Robin Holt <holt@sgi.com>
> > >
> > > [ Problem was fixed differently upstream. -DaveM ]
> > 
> > Gaah. I'd really like to see more of a description for things like
> > this. A commit ID for the alternate fix, or at least a few words about
> > the different fix or reason why upstream doesn't need the stable
> > commit.
> 
> I'll let David confirm this, he's the one who sent it to me :)

upstream uses commit 8d987e5c7510 (net: avoid limits overflow)

This commit is a bit more untrusive for stable kernels :

It depends on :
a9febbb4bd13 (sysctl: min/max bounds are optional)
27b3d80a7b6a (sysctl: fix min/max handling in __do_proc_doulongvec_minmax())




