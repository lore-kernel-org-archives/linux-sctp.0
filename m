From: David Miller <davem@davemloft.net>
Date: Tue, 15 Mar 2011 21:03:59 +0000
Subject: Re: [PATCH 11/17] net,rcu: convert call_rcu(sctp_local_addr_free)
Message-Id: <20110315.140359.39186121.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D7F3610.6000809@cn.fujitsu.com>
	<4D7F39CE.80403@cn.fujitsu.com>
In-Reply-To: <4D7F39CE.80403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: laijs@cn.fujitsu.com
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, axboe@kernel.dk, Trond.Myklebust@netapp.com, vladislav.yasevich@hp.com, sri@us.ibm.com, viro@zeniv.linux.org.uk, eparis@redhat.com, menage@google.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, johannes@sipsolutions.net, linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, hadi-fAAogVwAN2Kw5LPnMra/2Q@public.gmane.org, jpirko@redhat.com, eric.dumazet@gmail.com, hagen-GvnIQ6b/HdU@public.gmane.org, randy.dunlap@oracle.com, jkosina@suse.cz, joe@perches.com, u.kleine-koenig@pengutronix.de, ebiederm@xmission.com, gregkh@suse.de, xemul@openvz.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, containers@lists.linux-foundation.org, linux-decnet-user@lists.sourceforge.net, linux-wireless@vger.kernel.org, linux-security-module@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 15 Mar 2011 18:05:02 +0800

> 
> 
> The rcu callback sctp_local_addr_free() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(sctp_local_addr_free).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
