From: David Miller <davem@redhat.com>
Date: Thu, 28 May 2020 19:47:51 +0000
Subject: Re: [PATCH v2] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Message-Id: <20200528.124751.1622700747294014742.davem@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200527095640.270986-1-jonas.falkevik@gmail.com>
In-Reply-To: <20200527095640.270986-1-jonas.falkevik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jonas.falkevik@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Jonas Falkevik <jonas.falkevik@gmail.com>
Date: Wed, 27 May 2020 11:56:40 +0200

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
> ---
> Changes in v2:
>  - Check asoc state to be at least established.
>    Instead of associd being SCTP_FUTURE_ASSOC.
>  - Common check for all peer addr change event

Applied and queued up for -stable, thanks.

 
