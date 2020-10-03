From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 04:07:29 +0000
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port is set
Message-Id: <20201003040729.GF70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

On Tue, Sep 29, 2020 at 09:49:03PM +0800, Xin Long wrote:
> sctp_mtu_payload() is for calculating the frag size before making
> chunks from a msg. So we should only add udphdr size to overhead
> when udp socks are listening, as only then sctp can handling the
                                               "handle"   ^^^^
> incoming sctp over udp packets and outgoing sctp over udp packets
> will be possible.
> 
> Note that we can't do this according to transport->encap_port, as
> different transports may be set to different values, while the
> chunks were made before choosing the transport, we could not be
> able to meet all rfc6951#section-5.6 requires.

I don't follow this last part. I guess you're referring to the fact
that it won't grow back the PMTU if it is not encapsulating anymore.
If that's it, then changelog should be different here.  As is, it
seems it is not abiding by the RFC, but it is, as that's a 'SHOULD'.

Maybe s/requires\.$/recommends./ ?
