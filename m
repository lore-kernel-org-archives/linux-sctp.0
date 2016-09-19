From: David Miller <davem@davemloft.net>
Date: Mon, 19 Sep 2016 02:03:08 +0000
Subject: Re: [PATCHv2 net 0/6] sctp: fix the transmit err process
Message-Id: <20160918.220308.1356173755824789782.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1473789537.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1473789537.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 14 Sep 2016 02:04:17 +0800

> This patchset is to improve the transmit err process and also fix some
> issues.
> 
> After this patchset, once the chunks are enqueued successfully, even
> if the chunks fail to send out, no matter because of nodst or nomem,
> no err retruns back to users any more. Instead, they are taken care
> of by retransmit.
> 
> v1->v2:
>   - add more details to the changelog in patch 1/6
>   - add Fixes: tag in patch 2/6, 3/6
>   - also revert 69b5777f2e57 in patch 3/6

Since SCTP's behavior has been like this for a long time I've applied
this series to net-next, thanks.
