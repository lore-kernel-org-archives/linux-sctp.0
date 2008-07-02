From: David Miller <davem@davemloft.net>
Date: Wed, 02 Jul 2008 03:06:32 +0000
Subject: Re: [PATCH net-next] sctp: Mark GET_PEER|LOCAL_ADDR_OLD deprecated.
Message-Id: <20080701.200632.139196702.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 21 Jun 2008 12:04:44 -0400

> Socket options SCTP_GET_PEER_ADDR_OLD, SCTP_GET_PEER_ADDR_NUM_OLD,
> SCTP_GET_LOCAL_ADDR_OLD, and SCTP_GET_PEER_LOCAL_ADDR_NUM_OLD
> have been replaced by newer versions a since 2005.  It's time
> to officially deprecate them and schedule them for removal.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks Vlad.
