From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 12 Nov 2010 15:09:22 +0000
Subject: Re: [PATCH 2/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289574562.2247.1.camel@achroite.uk.solarflarecom.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524019.5167.66.camel@dan>
In-Reply-To: <1289524019.5167.66.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, James Morris <jmorris@namei.org>, Remi Denis-Courmont <remi.denis-courmont@nokia.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, Sridhar Samudrala <sri@us.ibm.com>, Vlad Yasevich <vladislav.yasevich@hp.com>, Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>, Joe Perches <joe@perches.com>, Stephen Hemminger <shemminger@vyatta.com>, Jamal Hadi Salim <hadi@mojatatu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Jiri Pirko <jpirko@redhat.com>, Johannes Berg <johannes.berg@intel.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Pavel

On Thu, 2010-11-11 at 20:06 -0500, Dan Rosenberg wrote:
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index 08ffe9e..5960ad7 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
[...]
> +		seq_printf(m, ">>> socket %lu", sock_i_ino(sk));

Why decimal here...

[...]
> +		/* unique socket inode as filename */
> +		sprintf(bo->procname, "%lx", sock_i_ino(sk));

...and hexadecimal here?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

