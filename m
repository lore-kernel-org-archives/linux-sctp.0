From: David Miller <davem@davemloft.net>
Date: Fri, 08 Jul 2011 16:37:49 +0000
Subject: Re: [PATCHv3] sctp: ABORT if receive, reassmbly, or reodering
Message-Id: <20110708.093749.899388186927369532.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110708105705.GA14583@canuck.infradead.org>
	<4E170B00.9080406@hp.com>
	<20110708143746.GB24249@canuck.infradead.org>
In-Reply-To: <20110708143746.GB24249@canuck.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tgraf@infradead.org
Cc: vladislav.yasevich@hp.com, netdev@vger.kernel.org, yjwei@cn.fujitsu.com, sri@us.ibm.com, linux-sctp@vger.kernel.org

From: Thomas Graf <tgraf@infradead.org>
Date: Fri, 8 Jul 2011 10:37:46 -0400

> Trigger user ABORT if application closes a socket which has data
> queued on the socket receive queue or chunks waiting on the
> reassembly or ordering queue as this would imply data being lost
> which defeats the point of a graceful shutdown.
> 
> This behavior is already practiced in TCP.
> 
> We do not check the input queue because that would mean to parse
> all chunks on it to look for unacknowledged data which seems too
> much of an effort. Control chunks or duplicated chunks may also
> be in the input queue and should not be stopping a graceful
> shutdown.
> 
> Signed-off-by: Thomas Graf <tgraf@infradead.org>

Vlad please ACK/NACK this updated patch.

Thanks.
