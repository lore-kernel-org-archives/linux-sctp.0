From: David Miller <davem@davemloft.net>
Date: Mon, 30 Mar 2020 04:58:20 +0000
Subject: Re: [PATCH v6] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200329.215820.1352705339130655350.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200327030751.19404-1-hqjagain@gmail.com>
In-Reply-To: <20200327030751.19404-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hqjagain@gmail.com
Cc: marcelo.leitner@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anenbupt@gmail.com

From: Qiujun Huang <hqjagain@gmail.com>
Date: Fri, 27 Mar 2020 11:07:51 +0800

> We should iterate over the datamsgs to move
> all chunks(skbs) to newsk.
> 
> The following case cause the bug:
> for the trouble SKB, it was in outq->transmitted list
> 
> sctp_outq_sack
>         sctp_check_transmitted
>                 SKB was moved to outq->sacked list
>         then throw away the sack queue
>                 SKB was deleted from outq->sacked
> (but it was held by datamsg at sctp_datamsg_to_asoc
> So, sctp_wfree was not called here)
> 
> then migrate happened
> 
>         sctp_for_each_tx_datachunk(
>         sctp_clear_owner_w);
>         sctp_assoc_migrate();
>         sctp_for_each_tx_datachunk(
>         sctp_set_owner_w);
> SKB was not in the outq, and was not changed to newsk
> 
> finally
> 
> __sctp_outq_teardown
>         sctp_chunk_put (for another skb)
>                 sctp_datamsg_put
>                         __kfree_skb(msg->frag_list)
>                                 sctp_wfree (for SKB)
> 	SKB->sk was still oldsk (skb->sk != asoc->base.sk).
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

Applied and queued up for -stable, thanks.
