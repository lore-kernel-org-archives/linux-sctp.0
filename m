From: David Miller <davem@davemloft.net>
Date: Mon, 14 Apr 2014 20:48:39 +0000
Subject: Re: [PATCH net] Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver'
Message-Id: <20140414.164839.2032159104530481155.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397504717-19566-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1397504717-19566-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, matija.glavinic-pecotic.ext@nsn.com, alexander.sverdlin@nsn.com, vyasevich@gmail.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 14 Apr 2014 21:45:17 +0200

> This reverts commit ef2820a735f7 ("net: sctp: Fix a_rwnd/rwnd management
> to reflect real state of the receiver's buffer") as it introduced a
> serious performance regression on SCTP over IPv4 and IPv6, though a not
> as dramatic on the latter. Measurements are on 10Gbit/s with ixgbe NICs.
> 
> Current state:
 ...
> With the reverted patch applied, the SCTP/IPv4 performance is back
> to normal on latest upstream for IPv4 and IPv6 and has same throughput
> as 3.4.2 test kernel, steady and interval reports are smooth again.
> 
> Fixes: ef2820a735f7 ("net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer")
> Reported-by: Peter Butler <pbutler@sonusnet.com>
> Reported-by: Dongsheng Song <dongsheng.song@gmail.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Tested-by: Peter Butler <pbutler@sonusnet.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable.
