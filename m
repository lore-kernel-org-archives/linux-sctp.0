From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2012 18:13:48 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <20120515.141348.892964316296815698.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20120515.134531.530903973750646107.davem@davemloft.net>
	<1337104765.7050.24.camel@joe2Laptop>
	<1337105028.15553.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1337105028.15553.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: johannes@sipsolutions.net
Cc: joe@perches.com, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 May 2012 20:03:48 +0200

> Oops. Yes, please do that, mac80211 doesn't have DEBUG yet

If you want debugging messages you would turn on dynamic_debug
via sysctl or whatever, not define DEBUG in your sources.

I don't think we should add yet another interface just to get
KERN_DEBUG in there.
