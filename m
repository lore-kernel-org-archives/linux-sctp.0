From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 26 Nov 2015 15:12:29 +0000
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151126151229.GA3412@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
In-Reply-To: <20151126150726.GD32716@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Westphal <fw@strlen.de>
Cc: Patrick McHardy <kaber@trash.net>, Michal Kubecek <mkubecek@suse.cz>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Thu, Nov 26, 2015 at 04:07:26PM +0100, Florian Westphal wrote:
> I would prefer to NOT force people to use extra connection tracking code
> for sctp if they don't need it.
> 
> Most distributions will ship with all of this as '=m', but IMHO its safe
> to assume that most users will in fact not use sctp (but conntrack for
> udp and tcp).

Enabling features through modprobe seems not to be a good idea
anymore, now we've got namespaces.

We should probably go back to the idea of explicit conntrack
configuration through rules that we discussed many times before.
