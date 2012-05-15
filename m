From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2012 18:51:07 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <20120515.145107.834395619191754306.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1337106430.15553.6.camel@jlt3.sipsolutions.net>
	<20120515.142922.1434224550630736456.davem@davemloft.net>
	<1337107245.15553.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1337107245.15553.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: johannes@sipsolutions.net
Cc: joe@perches.com, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 May 2012 20:40:45 +0200

> In the mac80211 case, messages are warnings/hints to the user, we just
> don't want them to flood the logs too much. I'd rather have that kind of
> change (limit cookie per callsite) in the rate limiting semantics than
> the change in the when it gets printed at all.

Then they aren't KERN_DEBUG, they are KERN_INFO or KERN_WARN.
