From: Wei Zhao <wallyzhao@gmail.com>
Date: Thu, 31 Oct 2019 01:11:40 +0000
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
Message-Id: <CAFRmqq7=AG3oaWJ-tFQt5+BddSr=e8iiuyDYF703qcDRnmKdYg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com> <c2d0890f-8900-6838-69c4-6b72b2e58062@gmail.com>
In-Reply-To: <c2d0890f-8900-6838-69c4-6b72b2e58062@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com

On Thu, Oct 31, 2019 at 3:03 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/30/19 9:07 AM, Wally Zhao wrote:
> > Unlike tcp_transmit_skb,
> > sctp_packet_transmit does not set ooo_okay explicitly,
> > causing unwanted Tx queue switching when multiqueue is in use;
> > Tx queue switching may cause out-of-order packets.
> > Change sctp_packet_transmit to allow Tx queue switching only for
> > the first in flight packet, to avoid unwanted Tx queue switching.
> >
>
> While the patch seems fine, the changelog is quite confusing.
>
> When skb->ooo_olay is 0 (which is the default for freshly allocated skbs),
> the core networking stack will stick to whatever TX queue was chosen
> at the time the dst_entry was attached to the (connected) socket.
>
> This means no reorder can happen at all by default.
>
> By setting ooo_okay carefully (as you did in your patch), you allow
> core networking stack to _switch_ to another TX queue based on
> current CPU  (XPS selection)
>
> So even without your fix, SCTP should not experience out-of-order packets.

Yes, you are right, as Marcelo also pointed out.
The changelog was given based on incorrect observation of a test
result, as I replied to Marcelo.
Since ooo_okay is default to 0, this is good enough; no need for any
patch from my side.
Thank you for your time on this.


>
> > Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
> > ---
> >  net/sctp/output.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > index dbda7e7..5ff75cc 100644
> > --- a/net/sctp/output.c
> > +++ b/net/sctp/output.c
> > @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
> >       /* neighbour should be confirmed on successful transmission or
> >        * positive error
> >        */
> > +
> > +     /* allow switch tx queue only for the first in flight pkt */
> > +     head->ooo_okay = asoc->outqueue.outstanding_bytes = 0;
> > +
> >       if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
> >           tp->dst_pending_confirm)
> >               tp->dst_pending_confirm = 0;
> >
