From: David Miller <davem@davemloft.net>
Date: Thu, 04 Oct 2012 19:54:06 +0000
Subject: Re: [RFC PATCH 2/2] sctp: check src addr when processing SACK to update transport state
Message-Id: <20121004.155406.294964504763861852.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1349279002-4008-1-git-send-email-nicolas.dichtel@6wind.com>
	<1349279002-4008-2-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1349279002-4008-2-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nicolas.dichtel@6wind.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed,  3 Oct 2012 17:43:22 +0200

> Suppose we have an SCTP connection with two paths. After connection is
> established, path1 is not available, thus this path is marked as inactive. Then
> traffic goes through path2, but for some reasons packets are delayed (after
> rto.max). Because packets are delayed, the retransmit mechanism will switch
> again to path1. At this time, we receive a delayed SACK from path2. When we
> update the state of the path in sctp_check_transmitted(), we do not take into
> account the source address of the SACK, hence we update the wrong path.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied.
