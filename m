From: David Miller <davem@davemloft.net>
Date: Thu, 18 Sep 2008 09:49:07 +0000
Subject: Re: [PATCH] sctp: set the skb->ip_summed correctly when sending
Message-Id: <20080918.024907.185077492.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080917101130.GU6798@shell>
	<1221681781-1904-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1221681781-1904-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, lksctp-developers@lists.sourceforge.net, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 17 Sep 2008 16:03:01 -0400

> Loopback used to clobber the ip_summed filed which sctp then used
> to figure out if it needed to do checksumming or not.  Now that
> loopback doesn't do that any more, sctp needs to set the ip_summed
> field correctly.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

That's a silly regression, sorry about that Vlad.

Applied to net-2.6, thanks!
