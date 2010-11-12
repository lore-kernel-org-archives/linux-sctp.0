From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:24:09 +0000
Subject: Re: [PATCH 3/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289525049.5167.82.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524023.5167.67.camel@dan>
	 <20101112012039.GB4683@canuck.infradead.org>
In-Reply-To: <20101112012039.GB4683@canuck.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Graf <tgraf@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, James Morris <jmorris@namei.org>, Remi Denis-Courmont <remi.denis-courmont@nokia.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, Sridhar Samudrala <sri@us.ibm.com>, Vlad Yasevich <vladislav.yasevich@hp.com>, Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Joe Perches <joe@perches.com>, Stephen Hemminger <shemminger@vyatta.com>, Jamal Hadi Salim <hadi@mojatatu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Jiri Pirko <jpirko@redhat.com>, Johannes Berg <johannes.berg@intel.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Pavel


> 
> If we really have to do this. At least don't duplicate all this code. Do
> the check in the printf argument:
> 
> 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
> 		...
> 		capable(CAP_NET_ADMIN) ? sp : 0,
> 
> I would even move the decision whether to expose kernel addresses or not
> to a function so we can change behavior in one place.

I wrote it this way because the format specifier must also be changed,
or the %p output will print "(null)", which cannot be parsed by
userspace programs expecting "(nil)" or 0.  I could include another
check inside the format specifier, but that seemed pretty ugly.  But
then again, it's ugly either way.

-Dan

