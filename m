From: David Miller <davem@davemloft.net>
Date: Fri, 30 Nov 2018 21:13:47 +0000
Subject: Re: [PATCHv2 net] sctp: update frag_point when stream_interleave is set
Message-Id: <20181130.131347.930056639766646783.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <507afa887be8d5be9cc3030f6f21bc40719615e2.1543317110.git.lucien.xin@gmail.com>
In-Reply-To: <507afa887be8d5be9cc3030f6f21bc40719615e2.1543317110.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, jakub.audykowicz@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 27 Nov 2018 19:11:50 +0800

> sctp_assoc_update_frag_point() should be called whenever asoc->pathmtu
> changes, but we missed one place in sctp_association_init(). It would
> cause frag_point is zero when sending data.
> 
> As says in Jakub's reproducer, if sp->pathmtu is set by socketopt, the
> new asoc->pathmtu inherits it in sctp_association_init(). Later when
> transports are added and their pmtu >= asoc->pathmtu, it will never
> call sctp_assoc_update_frag_point() to set frag_point.
> 
> This patch is to fix it by updating frag_point after asoc->pathmtu is
> set as sp->pathmtu in sctp_association_init(). Note that it moved them
> after sctp_stream_init(), as stream->si needs to be set first.
> 
> Frag_point's calculation is also related with datachunk's type, so it
> needs to update frag_point when stream->si may be changed in
> sctp_process_init().
> 
> v1->v2:
>   - call sctp_assoc_update_frag_point() separately in sctp_process_init
>     and sctp_association_init, per Marcelo's suggestion.
> 
> Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
> Reported-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable back to v4.18
