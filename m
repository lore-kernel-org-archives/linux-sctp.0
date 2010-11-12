From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:20:01 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289524801.5167.76.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524026.5167.68.camel@dan>
	 <20101111.171024.242132239.davem@davemloft.net>
In-Reply-To: <20101111.171024.242132239.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: socketcan@hartkopp.net, kuznet@ms2.inr.ac.ru, urs.thuermann@volkswagen.de, yoshfuji@linux-ipv6.org, kaber@trash.net, jmorris@namei.org, remi.denis-courmont@nokia.com, pekkas@netcore.fi, sri@us.ibm.com, vladislav.yasevich@hp.com, tj@kernel.org, eric.dumazet@gmail.com, lizf@cn.fujitsu.com, joe@perches.com, shemminger@vyatta.com, hadi@mojatatu.com, ebiederm@xmission.com, adobriyan@gmail.com, jpirko@redhat.com, johannes.berg@intel.com, daniel.lezcano@free.fr, xemul@openvz.org, socketcan-core@lists.berlios.de, netdev@vger.kernel.org, linux-sctp@vger.kernel.org


> This will print zero once a socket enters various closing states or
> similar, since the sk->sk_socket is released and turns NULL.
> 
> Thus making the debugging information next to useless.
> 
> I'm still largely against these changes, and will not apply them
> to my tree.

Would you care to offer any suggestions that would both solve the
problem and be acceptable to you?

If not, then you have committed to leaving a permanent easy target for
exploits.  Please think carefully about this.

-Dan

