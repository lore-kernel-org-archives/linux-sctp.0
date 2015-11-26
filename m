From: Florian Westphal <fw@strlen.de>
Date: Thu, 26 Nov 2015 15:07:26 +0000
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151126150726.GD32716@breakpoint.cc>
List-Id: <linux-sctp.vger.kernel.org>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
In-Reply-To: <20151126144916.GJ16828@macbook.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, Michal Kubecek <mkubecek@suse.cz>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Patrick McHardy <kaber@trash.net> wrote:
> Yeah, my main concern is that this requires the user to know about protocol
> modules, details about how the distribution build the kernel etc.

Yep, sucks.

> main reason for this problem to exists is exactly because users *don't* know
> about this, so I'm questioning whether this really solves it.
> 
> The =y case is easy, it will work. The =m case should probably at least be
> handled automatically. And then =n case is impossible to solve correctly
> and therefore probably should not be possible.

With you so far.

> I think the question during configuration should be "SCTP support y/n/m".
> We would then select the sctp match, build the SCTP conntrack into the
> conntrack core the SCTP NAT into the NAT core and the problem can not
> occur anymore. Same thing for other protocols. If the user selects n,
> no SCTP conntrack, no SCTP match.

So you'd propose that one can have
SCTP_MATCH=y
CONNTRACK=n

but not:

SCTP_MATCH=y
CONNTRACK=y
SCTP_CONNTRACK=n

IOW, make SCTP_CONNTRACK a non-visible symbol that
just glues sctp conntrack to the conntrack core when
both conntrack and sctp match is selected.

> Alternatively, as I believe Pablo suggested, we can simply put all conntrack
> modules inside the core.

I would prefer to NOT force people to use extra connection tracking code
for sctp if they don't need it.

Most distributions will ship with all of this as '=m', but IMHO its safe
to assume that most users will in fact not use sctp (but conntrack for
udp and tcp).
