From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 26 Nov 2015 16:43:16 +0000
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151126164316.GA4495@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
 <20151126151229.GA3412@salvia>
 <20151126152410.GN16828@macbook.localdomain>
 <20151126155426.GA4108@salvia>
 <20151126160227.GQ16828@macbook.localdomain>
 <20151126161529.GA4350@salvia>
 <20151126162528.GS16828@macbook.localdomain>
In-Reply-To: <20151126162528.GS16828@macbook.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>
Cc: Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Thu, Nov 26, 2015 at 04:25:28PM +0000, Patrick McHardy wrote:
> > This doesn't sound so complicated to me:
> > 
> >         add rule filter prerouting \
> >                 ip protocol { tcp, udp, sctp } track
> > 
> > You just specify what you need for stateful tracking.
> 
> Sure, or "filter prerouting track" for everything. Let's stay at that
> example because it will be a common case and we don't know anything about
> protocols.
>
> > The case above you indicate is enabling conntrack for all packets, the
> > -j CT --track is what should govern this IMO.
> 
> How does it prevent exactly that case we're talking about - someone is
> saying "CT --track" without further qualification and means "track
> everything".

That indeed means to me track everything based on what conntrack knows
how to track.

> And the SCTP connection tracking module is not available or not
> loaded.

If the module is not available, then this is a custom kernel
compilation. IMO we should focus on providing good defaults to typical
kernel that are included by most distributors.

If the SCTP tracker becomes part of nf_conntrack by default, then we
don't have to worry about the "SCTP module not loaded" case.
