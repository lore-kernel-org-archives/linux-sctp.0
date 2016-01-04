From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 04 Jan 2016 12:11:49 +0000
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20160104121149.GA3941@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
 <20151210170647.GA1547@salvia>
 <20151215190304.GA3724@mrl.redhat.com>
 <20151217110512.GA1863@salvia>
 <567BEA14.9030007@gmail.com>
 <20151230000317.GA1480@salvia>
 <20151230114918.GA16270@localhost.localdomain>
In-Reply-To: <20151230114918.GA16270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz

Hi Marcelo,

On Wed, Dec 30, 2015 at 09:49:18AM -0200, Marcelo Ricardo Leitner wrote:
> Please don't. Currently there is no other way to do it. The check I want
> to add only works on a corner case of what we already have, on which we
> can do better. It's just that. The way Michal handled the state
> transitions is very good and the fact that the conntrack entries are
> created as NEW, makes them pass the same user validation rules as a real
> new association would do. So there can't be any hitch-hicking...
>
> And for vtag probing, that's not an issue either because SCTP just drops
> such heartbeat requests with invalid vtags (at sctp_sf_beat_8_3).
> 
> The only vector of attack I can think of that the initial multi-homing
> support would allow is a DoS, a flood of incoming heartbeat requests.
> Such flood would _not_ end up on the association buffer because if the
> transport tuple (src ip, dst ip, src port, dst port) doesn't match a
> known association, it's discarded. It's just as any other DoS, but as
> they pass the same user validation rules, there should be rules
> restricting the rate or IP range or something like that if user is
> worried with that. Nothing that could jeopardize the original
> association.
>
> Note that the transport validation is performed before the vtag one, and
> the stack behavior is to also drop out of the blue packets silently.
> Meaning that even if the attacker get a hit at the 32-bit vtag, it will
> be discarded by the transport validation firstly.

Makes sense indeed, thanks for explaining. Then we have to find a
incremental path to extend Michal change to make it fit into what we
have.

> So what my patch add to it, it pulls/adds this vtag check to an earlier
> moment, from the stack itself to the firewall, so that the peer
> firewall will be a bit more stateful.

Please check if you can fit part of this logic into l4proto->error(),
just like ICMP v4 protocol tracker.

BTW, I think these new flows should enter as RELATED, not as NEW, just
like ICMP protocol tracker does.

Your patch basically looks to me like an ad-hoc expectation
infrastructure to handle this case.

Thanks.
