From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 19 Dec 2019 16:57:27 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191219165727.GB1159@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191213114934.GB5449@hmswarspite.think-freely.org>
 <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
 <20191219131700.GA1159@hmswarspite.think-freely.org>
 <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
In-Reply-To: <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Colitti <lorenzo@google.com>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>, "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Thu, Dec 19, 2019 at 11:02:32PM +0900, Lorenzo Colitti wrote:
> On Thu, Dec 19, 2019 at 10:17 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > As I understand it, those utilities keep the ports reserved by binding
> > > to them so that no other process can. This doesn't work for Android
> > > because there are conformance tests that probe the device from the
> > > network and check that there are no open ports.
> > >
> > But you can address that with some augmentation to portreserve (i.e. just have
> > it add an iptables rule to drop frames on that port, or respond with a port
> > unreachable icmp message)
> 
> There are also tests that run on device by inspecting
> /proc/net/{tcp,udp} to check that there are no open sockets. We'd have
> to change them as well.
> 
Ok, that seems reasonable.

> But sure. It's not impossible to do this in userspace. We wouldn't use
> portreserve itself because the work to package it and make it work on
> Android (which has no /etc/services file), would likely be greater
> than just adding the code to an existing Android daemon (and because
> the reaction of the portreserve maintainers might be similar to yours:
> "you don't need to add code to portreserve for this, just use a script
> that shells out to iptables").
> 
Possibly, but sure, you could add the same functionality to some other existing
daemon.

> But in any case, the result would be more complicated to use and
> maintain, and it would likely also be less realistic, such that a
> sophisticated conformance test might still find that the port was
> actually bound.
One would think that a sufficiently sophisticated script could understand that a
port was bound not for the purposes of use, but rather for the purposes of
prevention of use by other processes.  But I take your meaning, the fanout here
starts to get large.

> Other users of the kernel wouldn't get to use this
> sysctl, and the userspace code can't be easily reused in other
> open-source projects, so the community gets nothing useful. That
> doesn't seem great.
> 
Well, that assumes you implement this in a non-open daemon, but thats
your perogative.

> Or, we could take this patch and maintain it in the Android kernel
> tree. Android kernels get a tiny bit further from mainline. Other uses
> of the kernel wouldn't get to use this sysctl, and again the community
> gets nothing useful. That doesn't seem great either.
> 
That seems....agressive.  I'm not saying this is a bad feature, I'm really just
trying to think through how else this might be accomplished without the need to
implement and maintain another sysctl.

FWIW, bpf offers hooks in both inet6_bind and inet_bind.  Another option would
be to implement a bfp program at each of those hooks that filtered on the set of
blacklisted ports you want to prevent the use of.  I'm not sure how wide the
scope of this feature is for use, but if its limited to your use case, perhaps
thats an alternative solution.

Neil
