From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 29 Jan 2019 12:05:32 +0000
Subject: Re: [PATCHv2 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <20190129120531.GC10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <8a5df8eb5cc41dfc3d08e294147b9729bbe90aa0.1543473776.git.lucien.xin@gmail.com>
In-Reply-To: <8a5df8eb5cc41dfc3d08e294147b9729bbe90aa0.1543473776.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Thu, Nov 29, 2018 at 02:42:56PM +0800, Xin Long wrote:
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
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

We are sort of mixing things up here. We have a bug on SCTP stack that
triggers panics. As good practices recommends, the code should be as
generic as possible and the SCTP-only was dropped in favor of a more
generic one, fixing rhashtables instead. Okay. But then we discovered
rhashtables are going away and we are now waiting on a restructing
to fix the panic. That's not good, especially because it cannot and
should not be backported into -stable trees.

That said, we should not wait for the restructuring to _implicitly_
fix the bug. We should pursuit both fixes here:
- Apply this patch, to fix SCTP stack and allow it to be easily
  backportable.
- Apply the generic fix, which is the restructuring, whenever it
  actually lands.

Thoughts?

Thanks,
Marcelo
