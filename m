From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:40:25 +0000
Subject: Re: [PATCH 6/6] [SCTP]: Fix ECN markings for IPv6
Message-Id: <20080604.124025.29833100.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-7-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-7-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:51 -0400

> Commit e9df2e8fd8fbc95c57dbd1d33dada66c4627b44c
> ([IPV6]: Use appropriate sock tclass setting for routing lookup.) also
> changed the way that ECN capable transports mark this capability in IPv6.
> As a result, SCTP was not marking ECN capablity because the traffic class
> was never set.  This patch brings back the markings for IPv6 traffic.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Also applied, thanks a lot Vlad!
