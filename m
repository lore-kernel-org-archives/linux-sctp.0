From: David Miller <davem@davemloft.net>
Date: Sat, 14 Nov 2009 03:57:09 +0000
Subject: Re: [PATCH] sctp: Set source addresses on the association before
Message-Id: <20091113.195709.164224314.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1257879454-31661-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1257879454-31661-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 10 Nov 2009 13:57:34 -0500

> Recent commit 8da645e101a8c20c6073efda3c7cc74eec01b87f
> 	sctp: Get rid of an extra routing lookup when adding a transport
> introduced a regression in the connection setup.  The behavior was
> different between IPv4 and IPv6.  IPv4 case ended up working because the
> route lookup routing returned a NULL route, which triggered another
> route lookup later in the output patch that succeeded.  In the IPv6 case,
> a valid route was returned for first call, but we could not find a valid
> source address at the time since the source addresses were not set on the
> association yet.  Thus resulted in a hung connection.
> 
> The solution is to set the source addresses on the association prior to
> adding peers.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
