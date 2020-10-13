From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 13 Oct 2020 17:19:56 +0000
Subject: Re: [PATCHv3 net-next 02/16] udp6: move the mss check after udp gso tunnel processing
Message-Id: <CA+FuTSc1FRRZS8Yt0U7bt6M9Qjvi+xrQTefvMuOxF6=FL3dPPw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com> <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, David Miller <davem@davemloft.net>, gnault@redhat.com, Paolo Abeni <pabeni@redhat.com>

On Tue, Oct 13, 2020 at 3:28 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
> gso_size. When using UDP to encapsulate its packet, it will
> return error in udp6_ufo_fragment() as skb->len < gso_size,
> and it will never go to the gso tunnel processing.
>
> So we should move this check after udp gso tunnel processing,
> the same as udp4_ufo_fragment() does.
>
> v1->v2:
>   - no change.
> v2->v3:
>   - not do any cleanup.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for revising
