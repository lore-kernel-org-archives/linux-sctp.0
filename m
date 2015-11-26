From: Florian Westphal <fw@strlen.de>
Date: Thu, 26 Nov 2015 14:33:28 +0000
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151126143328.GC32716@breakpoint.cc>
List-Id: <linux-sctp.vger.kernel.org>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
In-Reply-To: <20151126141552.GH16828@macbook.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Michal Kubecek <mkubecek@suse.cz>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, fw@strlen.de

Patrick McHardy <kaber@trash.net> wrote:
> The way I see it we basically have two options for fixing this:
> 
> * disable the generic protocol entirely

That was the original v1 patch, BUT that means that we do not
support NAT for protocols without l4 tracker anymore (which
is why we did not remove generic protocol).

> * add a helper for every protocol for which we support matching on the identity
>   of a flow and load the helper automatically when conntrack is enabled and
>   the match is used.

Yes, but that might take a while.

The existing way (skip if module) is a compromise to attempt to not break
existing setups.

If e.g. SCTP=n and user has -p sctp --dport 42 -j ACCEPT then all
sctp packets will match the generic entry for sctp, i.e. the --dport 42
is redundant if an ESTABLISHED accept catchall is used.
Thats not nice, but the alternative is to break things when
NAT is used for that protocol...

If we have SCTP=n and its not loaded, we skip the generic tracker and
users need to load the extra module.  Granted, that breaks things as
well in some cases, but at least thats fixable without 'rebuild
kernel'...
