From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 May 2012 18:03:48 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <1337105028.15553.3.camel@jlt3.sipsolutions.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1336981915.git.joe@perches.com>
	 <20120515.134531.530903973750646107.davem@davemloft.net>
	 <1337104765.7050.24.camel@joe2Laptop>
	 (sfid-20120515_195955_463081_DA730895)
In-Reply-To: <1337104765.7050.24.camel@joe2Laptop> (sfid-20120515_195955_463081_DA730895)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:59 -0700, Joe Perches wrote:
> On Tue, 2012-05-15 at 13:45 -0400, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Mon, 14 May 2012 00:56:24 -0700
> > 
> > > net_ratelimit() like __ratelimit() is too easy to misuse.
> > > 
> > > Add simplifying macros similar to pr_<level>_ratelimited
> > > that combines the test of net_ratelimit and logging.
> > > 
> > > Joe Perches (2):
> > >   net: Add net_ratelimited_function and net_<level>_ratelimited macros
> > >   net: Convert net_ratelimit uses to net_<level>_ratelimited
> > 
> > These look fine to me so I've applied them to net-next and am
> > sanity checking the build right now.
> 
> OK, but fyi, there's a possible issue with !CONFIG_DEBUG
> builds because these patches converted some uses of
> 	if (net_ratelimit())
> 		printk(KERN_DEBUG ...
> to
> 	net_dbg_ratelimited()
> 
> These messages are no longer emitted when DEBUG isn't defined
> and not using dynamic_debug.  I'm not sure that's a real
> problem, but it's a difference.
> 
> I could produce a net_printk_ratelimited that would keep
> the original behavior if necessary.
> 
> 	net_printk_ratelimited(KERN_DEBUG etc...)

Oops. Yes, please do that, mac80211 doesn't have DEBUG yet

johannes

