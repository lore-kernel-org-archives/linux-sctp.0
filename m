From: David Miller <davem@davemloft.net>
Date: Thu, 13 Mar 2014 17:24:46 +0000
Subject: Re: [PATCH net-next] net: sctp: remove NULL check in sctp_assoc_update_retran_path
Message-Id: <20140313.132446.1003026026338152564.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1394718326-6415-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1394718326-6415-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davej@redhat.com, dan.carpenter@oracle.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 13 Mar 2014 14:45:26 +0100

> This is basically just to let Coverity et al shut up. Remove an
> unneeded NULL check in sctp_assoc_update_retran_path().
> 
> It is safe to remove it, because in sctp_assoc_update_retran_path()
> we iterate over the list of transports, our own transport which is
> asoc->peer.retran_path included. In the iteration, we skip the
> list head element and transports in state SCTP_UNCONFIRMED.
> 
> Such transports came from peer addresses received in INIT/INIT-ACK
> address parameters. They are not yet confirmed by a heartbeat and
> not available for data transfers.
> 
> We know however that in the list of transports, even if it contains
> such elements, it at least contains our asoc->peer.retran_path as
> well, so even if next to that element, we only encounter
> SCTP_UNCONFIRMED transports, we are always going to fall back to
> asoc->peer.retran_path through sctp_trans_elect_best(), as that is
> for sure not SCTP_UNCONFIRMED as per fbdf501c9374 ("sctp: Do no
> select unconfirmed transports for retransmissions").
> 
> Whenever we call sctp_trans_elect_best() it will give us a non-NULL
> element back, and therefore when we break out of the loop, we are
> guaranteed to have a non-NULL transport pointer, and can remove
> the NULL check.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks Daniel.
