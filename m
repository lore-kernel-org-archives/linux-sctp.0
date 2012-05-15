From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 May 2012 18:29:08 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <1337106548.15553.8.camel@jlt3.sipsolutions.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1337105028.15553.3.camel@jlt3.sipsolutions.net>
	 <20120515.141348.892964316296815698.davem@davemloft.net>
	 <1337106094.15553.5.camel@jlt3.sipsolutions.net>
	 <20120515.142405.633851408201128056.davem@davemloft.net>
In-Reply-To: <20120515.142405.633851408201128056.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 14:24 -0400, David Miller wrote:

> > But don't you have to do something in the sources to actually get
> > dynamic_debug enabled? I'm concerned this will make mac80211 debugging
> > inconsistent - the normal bits are just printk() still, and the
> > rate-limited bits need some special enabling? That seems odd.
> 
> You can turn them all off or on with a simple flip of a boolean switch
> at run-time.  Or, alternatively, you can turn them on or off in a
> finer grained manner with other run-time facilities.
> 
> There should be a transition away from explicit KERN_DEBUG.

I support that, but I think it's confusing to have things mixed. Also,
we seem to have printk_ratelimit(), so I'd prefer to have that used in
mac80211 instead until everything there moves over to newer facilities.

johannes

