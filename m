From: David Miller <davem@davemloft.net>
Date: Fri, 25 Jan 2019 02:25:41 +0000
Subject: Re: [PATCH net] sctp: set flow sport from saddr only when it's 0
Message-Id: <20190124.182541.341610576126108739.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <91961be2ab833139b1a4b0188ba47c2581b991d4.1548096161.git.lucien.xin@gmail.com>
In-Reply-To: <91961be2ab833139b1a4b0188ba47c2581b991d4.1548096161.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Jan 2019 02:42:41 +0800

> Now sctp_transport_pmtu() passes transport->saddr into .get_dst() to set
> flow sport from 'saddr'. However, transport->saddr is set only when
> transport->dst exists in sctp_transport_route().
> 
> If sctp_transport_pmtu() is called without transport->saddr set, like
> when transport->dst doesn't exists, the flow sport will be set to 0
> from transport->saddr, which will cause a wrong route to be got.
> 
> Commit 6e91b578bf3f ("sctp: re-use sctp_transport_pmtu in
> sctp_transport_route") made the issue be triggered more easily
> since sctp_transport_pmtu() would be called in sctp_transport_route()
> after that.
> 
> In gerneral, fl4->fl4_sport should always be set to
> htons(asoc->base.bind_addr.port), unless transport->asoc doesn't exist
> in sctp_v4/6_get_dst(), which is the case:
> 
>   sctp_ootb_pkt_new() ->
>     sctp_transport_route()
> 
> For that, we can simply handle it by setting flow sport from saddr only
> when it's 0 in sctp_v4/6_get_dst().
> 
> Fixes: 6e91b578bf3f ("sctp: re-use sctp_transport_pmtu in sctp_transport_route")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
