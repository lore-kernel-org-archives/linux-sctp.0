From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 27 Apr 2011 00:59:16 +0000
Subject: Re: [PATCH net-next-2.6 0/7] SCTP updates for net-next-2.6
Message-Id: <4DB76A64.3020708@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DB63F85.2090609@cn.fujitsu.com>	<20110426.001238.183056292.davem@davemloft.net> <20110426.145120.28826019.davem@davemloft.net>
In-Reply-To: <20110426.145120.28826019.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org


> Wei, while you are re-spinning this patch set I want to bring up
> something I just noticed in the SCTP code.
>
> The ->dst_saddr() method is not used by anything, it appears.
>
> The ipv4 variant, sctp_v4_dst_saddr() is called internally by the
> ipv4 specific code, but that's it.
>
> So I think the ->dst_saddr member of sctp_pf can be completely
> removed, as can sctp_v6_dst_saddr().
>
> The sctp_v4_dst_saddr() function, of course, will need to be retained.

David, thanks to noticed this. I will cleanup it.

And I have a stupid question about the rule of backport.  Since those
patchs have existed so long time, when I backport those patchs, I'd better
fix the bug in the original patch, or create new patch to fix it? Also how
about some thing need to improvement like the ->dst_saddr() method?
