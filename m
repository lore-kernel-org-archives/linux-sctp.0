From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2012 17:45:31 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <20120515.134531.530903973750646107.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1336981915.git.joe@perches.com>
In-Reply-To: <cover.1336981915.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 14 May 2012 00:56:24 -0700

> net_ratelimit() like __ratelimit() is too easy to misuse.
> 
> Add simplifying macros similar to pr_<level>_ratelimited
> that combines the test of net_ratelimit and logging.
> 
> Joe Perches (2):
>   net: Add net_ratelimited_function and net_<level>_ratelimited macros
>   net: Convert net_ratelimit uses to net_<level>_ratelimited

These look fine to me so I've applied them to net-next and am
sanity checking the build right now.

Thanks Joe.
