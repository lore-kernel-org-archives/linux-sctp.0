From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 27 Nov 2017 13:58:42 +0000
Subject: Re: [PATCH net 0/3] a couple of fixes for chunks abandoned in prsctp
Message-Id: <20171127135842.GC8850@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511615658.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1511615658.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sat, Nov 25, 2017 at 09:18:33PM +0800, Xin Long wrote:
> Now when abandoning chunks in prsctp, it doesn't consider for frags in
> one msg, which would cause peer can never receive the whole frags for
> one msg to get them reassembled, these pieces of this msg will stay in
> the reasm queue forever and block the following chunks' receiving.
> 
> This patchset is to fix them in patch 2 and 3, and also fix another
> issue for prsctp in patch 1.
> 
> Xin Long (3):
>   sctp: only update outstanding_bytes for transmitted queue when doing
>     prsctp_prune
>   sctp: abandon the whole msg if one part of a fragmented message is
>     abandoned
>   sctp: do not abandon the other frags in unsent outq if one msg has
>     outstanding frags
> 
>  include/net/sctp/structs.h |  3 ++-
>  net/sctp/chunk.c           | 11 +++++++++++
>  net/sctp/outqueue.c        | 19 +++++++++++++------
>  3 files changed, 26 insertions(+), 7 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
