From: David Miller <davem@davemloft.net>
Date: Sun, 03 Feb 2019 22:31:39 +0000
Subject: Re: [PATCHv3 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <20190203.143139.2186062220005546704.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <91ab89c95836cfcacbe823f4bc0ecd2568bad113.1549222078.git.lucien.xin@gmail.com>
In-Reply-To: <91ab89c95836cfcacbe823f4bc0ecd2568bad113.1549222078.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  4 Feb 2019 03:27:58 +0800

> Now when using stream reconfig to add out streams, stream->out
> will get re-allocated, and all old streams' information will
> be copied to the new ones and the old ones will be freed.
> 
> So without stream->out_curr updated, next time when trying to
> send from stream->out_curr stream, a panic would be caused.
> 
> This patch is to check and update stream->out_curr when
> allocating stream_out.
> 
> v1->v2:
>   - define fa_index() to get elem index from stream->out_curr.
> v2->v3:
>   - repost with no change.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.

Thanks!
