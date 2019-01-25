From: David Miller <davem@davemloft.net>
Date: Fri, 25 Jan 2019 02:25:32 +0000
Subject: Re: [PATCH net] sctp: set chunk transport correctly when it's a new asoc
Message-Id: <20190124.182532.1983690003554983866.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d08f8708003363950333c0690960ce3d97897bd4.1548096129.git.lucien.xin@gmail.com>
In-Reply-To: <d08f8708003363950333c0690960ce3d97897bd4.1548096129.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Jan 2019 02:42:09 +0800

> In the paths:
> 
>   sctp_sf_do_unexpected_init() ->
>     sctp_make_init_ack()
>   sctp_sf_do_dupcook_a/b()() ->
>     sctp_sf_do_5_1D_ce()
> 
> The new chunk 'retval' transport is set from the incoming chunk 'chunk'
> transport. However, 'retval' transport belong to the new asoc, which
> is a different one from 'chunk' transport's asoc.
> 
> It will cause that the 'retval' chunk gets set with a wrong transport.
> Later when sending it and because of Commit b9fd683982c9 ("sctp: add
> sctp_packet_singleton"), sctp_packet_singleton() will set some fields,
> like vtag to 'retval' chunk from that wrong transport's asoc.
> 
> This patch is to fix it by setting 'retval' transport correctly which
> belongs to the right asoc in sctp_make_init_ack() and
> sctp_sf_do_5_1D_ce().
> 
> Fixes: b9fd683982c9 ("sctp: add sctp_packet_singleton")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
