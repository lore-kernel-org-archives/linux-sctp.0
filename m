From: "Dan Rosenberg" <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 02:15:25 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <2129857903-1289528127-cardhu_decombobulator_blackberry.rim.net-1506931048-@bda083.bisx.prod.on.blackberry>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524026.5167.68.camel@dan>
In-Reply-To: <1289524026.5167.68.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: socketcan@hartkopp.net, kuznet@ms2.inr.ac.ru, urs.thuermann@volkswagen.de, yoshfuji@linux-ipv6.org, kaber@trash.net, jmorris@namei.org, remi.denis-courmont@nokia.com, pekkas@netcore.fi, sri@us.ibm.com, vladislav.yasevich@hp.com, tj@kernel.org, eric.dumazet@gmail.com, lizf@cn.fujitsu.com, joe@perches.com, shemminger@vyatta.com, hadi@mojatatu.com, ebiederm@xmission.com, adobriyan@gmail.com, jpirko@redhat.com, johannes.berg@intel.com, daniel.lezcano@free.fr, xemul@openvz.org, socketcan-core@lists.berlios.de, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>


I am willing to do whatever is necessary to make these changes acceptable.  Are you completely set on not removing these addresses from the output?

-Dan
