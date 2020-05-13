From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 13 May 2020 16:01:16 +0000
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Message-Id: <20200513160116.GA2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
In-Reply-To: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonas Falkevik <jonas.falkevik@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Long <lucien.xin@gmail.com>

On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.

How did you get them?

I'm thinking you're fixing a side-effect of another issue here. For
example, in sctp_assoc_update(), it first calls sctp_assoc_add_peer()
to only then call sctp_assoc_set_id(), which would generate the event
you might have seen. In this case, it should be allocating IDR before,
so that the event can be sent with the right assoc_id already.

> 
> These events are described in rfc6458#section-6.1
> SCTP_PEER_ADDR_CHANGE:
> This tag indicates that an address that is
> part of an existing association has experienced a change of
> state (e.g., a failure or return to service of the reachability
> of an endpoint via a specific transport address).
> 
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> ---
>  net/sctp/associola.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 437079a4883d..0c5dd295f9b8 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
>          changeover = 1 ;
> 
>      asoc->peer.primary_path = transport;
> -    sctp_ulpevent_nofity_peer_addr_change(transport,
> -                          SCTP_ADDR_MADE_PRIM, 0);
> +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> +        sctp_ulpevent_nofity_peer_addr_change(transport,
> +                              SCTP_ADDR_MADE_PRIM,
> +                              0);
> 
>      /* Set a default msg_name for events. */
>      memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
> @@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
> sctp_association *asoc,
>      list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
>      asoc->peer.transport_count++;
> 
> -    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
> +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> +        sctp_ulpevent_nofity_peer_addr_change(peer,
> +                              SCTP_ADDR_ADDED,
> +                              0);
> 
>      /* If we do not yet have a primary path, set one.  */
>      if (!asoc->peer.primary_path) {
> --
> 2.25.3
