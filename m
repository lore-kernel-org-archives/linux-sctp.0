From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Tue, 10 Dec 2019 11:46:29 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com> <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com> <20191209161835.7c455fc0@cakuba.netronome.com>
In-Reply-To: <20191209161835.7c455fc0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

> Okay, that's what I was suspecting.  It'd be great if the real
> motivation for a patch was spelled out in the commit message :/

It is, but the commit message is already extremely long.
At some point essays and discussions belong in email and not in the
commit message.

Here's another use case:

A network where firewall policy or network behaviour blocks all
traffic using specific ports.

I've seen generic firewalls that unconditionally drop all BGP or SMTP
port traffic, or all traffic on ports 5060/5061 (regardless of
direction) or on 25/53/80/123/443/853/3128/8000/8080/8088/8888
(usually due to some ill guided security policies against sip or open
proxies or xxx). If you happen to use port XXXX as your source port
your connection just hangs (packets are blackholed).

Sure you can argue the network is broken, but in the real world you
often can't fix it... Go try and convince your ISP that they should
only drop inbound connections to port 8000, but not outgoing
connections from port 8000 - you'll go crazy before you find someone
who even understands what you're talking about - and even if you find
such a person, they'll probably be too busy to change things - and
even though it might be a 1 letter change (port -> dport) - it still
might take months of testing and rollout before it's fully deployed.

I've seen networks where specific ports are automatically classified
as super high priority (network control) so you don't want anything
using these ports without very good reason (common for BGP for
example, or for encap schemes).

Or a specific port number being reserved by GUE or other udp encap
schemes and thus unsafe to use for generic traffic (because the
network or even the kernel itself might for example auto decapsulate
it [via tc ebpf for example], or parse the interior of the packet for
flowhashing purposes...).

[I'll take this opportunity to point out that due to poor flow hashing
behaviour GRE is basically unusable at scale (not to mention poorly
extensible), and thus GUE and other UDP encap schemes are taking over]

Or you might want to forward udp port 4500 from your external IP to a
dedicated ipsec box or some hardware offload engine... etc.

> So some SoCs which run non-vanilla kernels require hacks to steal
> ports from the networking stack for use by proprietary firmware.
> I don't see how merging this patch benefits the community.

I think you're failing to account for the fact that the majority of
Linux users are Android users - there's around 2.5 billion Android
phones in the wild... - but perhaps you don't consider your users (or
Android?) to be part of your community?

btw. Chrome OS is also Linux based (and if a quick google search is to
be believed, about 1/7th of the linux desktop/laptop share), but since
it supports running Android apps, it needs to have all Android
specific generic kernel changes...

The reason Android runs non-vanilla kernels is *because* patches like
this - that make Linux work in the real world - are missing from
vanilla Linux
(I can think of a few other networking patches off the top of my head
where we've been unable to upstream them for no particularly good
reason).

> So the conditions for this are:
>  - in-place upgrade of an existing rack

No that's just an example.  That said in place upgrades aren't
particularly rare.

>  - IPv4 only

Believe it or not most embedded gear is still very much ipv4 only, as
much as I hate that - I've been working on ipv6 deployment for over a
decade now, and the amount of stuff that's IPv4-only is still
staggering.

> Unlike the AP one this sounds like a very rare scenario..

And yet I have 2 ports for 2 different pieces of hardware that I need
to block this way (and a third one for GUE and a fourth one for some
ipsec-like crypto transport).
