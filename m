From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 28 May 2020 05:59:06 +0000
Subject: Re: [PATCH v2] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Message-Id: <CADvbK_duBhNhPMrR2ZGkhgAhR555MNHLQM9SS95KVZDnJ=WiQQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200527095640.270986-1-jonas.falkevik@gmail.com>
In-Reply-To: <20200527095640.270986-1-jonas.falkevik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonas Falkevik <jonas.falkevik@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, May 27, 2020 at 5:57 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
>
> Make sure SCTP_ADDR_{MADE_PRIM,ADDED} are sent only for associations
> that have been established.
>
> These events are described in rfc6458#section-6.1
> SCTP_PEER_ADDR_CHANGE:
> This tag indicates that an address that is
> part of an existing association has experienced a change of
> state (e.g., a failure or return to service of the reachability
> of an endpoint via a specific transport address).
>
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>

> ---
> Changes in v2:
>  - Check asoc state to be at least established.
>    Instead of associd being SCTP_FUTURE_ASSOC.
>  - Common check for all peer addr change event
>
>  net/sctp/ulpevent.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index c82dbdcf13f2..77d5c36a8991 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
>         struct sockaddr_storage addr;
>         struct sctp_ulpevent *event;
>
> +       if (asoc->state < SCTP_STATE_ESTABLISHED)
> +               return;
> +
>         memset(&addr, 0, sizeof(struct sockaddr_storage));
>         memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
>
> --
> 2.25.4
>
