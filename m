From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 15:14:21 +0000
Subject: Re: [PATCH 3/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289574861.3090.290.camel@Dan>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524023.5167.67.camel@dan>
	 <1289574706.2247.4.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1289574706.2247.4.camel@achroite.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, James Morris <jmorris@namei.org>, Remi Denis-Courmont <remi.denis-courmont@nokia.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, Sridhar Samudrala <sri@us.ibm.com>, Vlad Yasevich <vladislav.yasevich@hp.com>, Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Joe Perches <joe@perches.com>, Stephen Hemminger <shemminger@vyatta.com>, Jamal Hadi Salim <hadi@mojatatu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Jiri Pirko <jpirko@redhat.com>, Johannes Berg <johannes.berg@intel.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Pavel


> 
> Similarly for other formats that you want to make conditional on
> CAP_NET_ADMIN.

I wanted to avoid a %p output of "(null)" in case userspace tools
couldn't handle that, but I agree this is much nicer looking.  I'm
currently putting together a new format specifier instead, as per the
suggestions of Eric and David.

-Dan

