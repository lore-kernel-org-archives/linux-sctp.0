From: David Miller <davem@davemloft.net>
Date: Wed, 20 Apr 2011 04:47:47 +0000
Subject: Re: [PATCH net-next-2.6 8/8] sctp: Release all routes when
Message-Id: <20110419.214747.58452484.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
	<4DAD1A6A.1090805@cn.fujitsu.com>
In-Reply-To: <4DAD1A6A.1090805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 13:15:22 +0800

> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> When processing an ACK for ADD_IP parameter, we only release
> the routes on non-active transports.  This can cause a wrong
> source address to be used.  We can release the routes and
> cause new route lookups and source address selection so that
> new addresses can be used as source.  Additionally, we don't need
> to lookup routes for all transports at the same time.  We can let
> the transmit code path update the cached route when the transport
> actually sends something.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
