From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Sep 2016 17:16:05 +0000
Subject: Re: [PATCHv2 net 0/6] sctp: fix the transmit err process
Message-Id: <20160914171605.GG17689@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1473789537.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1473789537.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

On Wed, Sep 14, 2016 at 02:04:17AM +0800, Xin Long wrote:
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

Looks good to me, thanks

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

