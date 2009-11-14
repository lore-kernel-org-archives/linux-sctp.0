From: David Miller <davem@davemloft.net>
Date: Sat, 14 Nov 2009 03:57:24 +0000
Subject: Re: [PATCH] sctp: Set socket source address when additing first
Message-Id: <20091113.195724.05973595.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1257879454-31661-1-git-send-email-vladislav.yasevich@hp.com>
	<1257976477-31326-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1257976477-31326-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 11 Nov 2009 16:54:37 -0500

> Recent commits
> 	sctp: Get rid of an extra routing lookup when adding a transport
> and
> 	sctp: Set source addresses on the association before adding transports
> 
> changed when routes are added to the sctp transports.  As such,
> we didn't set the socket source address correctly when adding the first
> transport.  The first transport is always the primary/active one, so
> when adding it, set the socket source address.  This was causing
> regression failures in SCTP tests.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
