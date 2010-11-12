From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 02:34:29 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289529269.3090.207.camel@Dan>
List-Id: <linux-sctp.vger.kernel.org>
References: <2129857903-1289528127-cardhu_decombobulator_blackberry.rim.net-1506931048-@bda083.bisx.prod.on.blackberry>
	 <20101111.182939.258124014.davem@davemloft.net>
In-Reply-To: <20101111.182939.258124014.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: socketcan@hartkopp.net, kuznet@ms2.inr.ac.ru, urs.thuermann@volkswagen.de, yoshfuji@linux-ipv6.org, kaber@trash.net, jmorris@namei.org, remi.denis-courmont@nokia.com, pekkas@netcore.fi, sri@us.ibm.com, vladislav.yasevich@hp.com, tj@kernel.org, eric.dumazet@gmail.com, lizf@cn.fujitsu.com, joe@perches.com, shemminger@vyatta.com, hadi@mojatatu.com, ebiederm@xmission.com, adobriyan@gmail.com, jpirko@redhat.com, johannes.berg@intel.com, daniel.lezcano@free.fr, xemul@openvz.org, socketcan-core@lists.berlios.de, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, torvalds@linux-foundation.org


> I want whatever you replace it with to be equivalent for
> object tracking purposes.

In nearly all of the cases I fixed, the socket inode is already
provided, which serves as a perfectly good unique identifier.  Would you
prefer I include that information twice?

-Dan

