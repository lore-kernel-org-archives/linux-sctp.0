From: David Miller <davem@davemloft.net>
Date: Sun, 22 Jun 2008 19:32:32 +0000
Subject: Re: [PATCH]: SCTP length validation.
Message-Id: <20080622.123232.71141502.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080620.221205.183623344.davem@davemloft.net>
	<485D2467.7020300@hp.com>
In-Reply-To: <485D2467.7020300@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 21 Jun 2008 11:55:19 -0400

> The same vulnerability also exists in sctp_getsockopt_peer_addrs_old().
> It's a bit more difficult to trigger since there is a dependency on
> the peer being multihomed as well, but it's still possible to cause the
> overwrite.

I can't see how that's possible.  This case looks harmless to
me.

The kernel side accesses are perfectly protected.  The kernel
will only access the actual address list stored via:

	list_for_each_entry(from, &asoc->peer.transport_addr_list,
				transports) {
 ...
		cnt ++;
		if (cnt >= getaddrs.addr_num) break;
	}
	getaddrs.addr_num = cnt;

Copies are only made to userspace, and the given ->addr_num only
serves as an early break-out from that loop.  I mean, take a look,
those lines in the above are the only aaccesses made to the user's
provided addr_num value.

There is no possibility to use strange ->addr_num values
in order to read or write kernel memory outside of the
intended bounds.

I don't even see any value to adding new checks here.
