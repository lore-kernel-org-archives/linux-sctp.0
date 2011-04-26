From: David Miller <davem@davemloft.net>
Date: Tue, 26 Apr 2011 21:51:20 +0000
Subject: Re: [PATCH net-next-2.6 0/7] SCTP updates for net-next-2.6
Message-Id: <20110426.145120.28826019.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DB63F85.2090609@cn.fujitsu.com>
	<20110426.001238.183056292.davem@davemloft.net>
In-Reply-To: <20110426.001238.183056292.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org


Wei, while you are re-spinning this patch set I want to bring up
something I just noticed in the SCTP code.

The ->dst_saddr() method is not used by anything, it appears.

The ipv4 variant, sctp_v4_dst_saddr() is called internally by the
ipv4 specific code, but that's it.

So I think the ->dst_saddr member of sctp_pf can be completely
removed, as can sctp_v6_dst_saddr().

The sctp_v4_dst_saddr() function, of course, will need to be retained.
