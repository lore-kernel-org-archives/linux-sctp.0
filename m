From: marcelo.leitner@gmail.com
Date: Mon, 06 Jun 2016 21:07:50 +0000
Subject: Re: sctp: Add GSO support
Message-Id: <20160606210750.GF22680@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160606201646.GA5425@mwanda>
In-Reply-To: <20160606201646.GA5425@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Mon, Jun 06, 2016 at 11:42:38PM +0300, Dan Carpenter wrote:
> It's fairly tricky to follow actually.  Here is one caller:
>=20
> net/sctp/outqueue.c
>    706  static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, =
gfp_t gfp)
>    707  {
>    708          struct sctp_packet *packet;
>    709          struct sctp_packet singleton;
>    710          struct sctp_association *asoc =3D q->asoc;
>                                          ^^^^^^^^^^^^^^
> asoc is set here.
>=20
>    711          __u16 sport =3D asoc->base.bind_addr.port;
>    712          __u16 dport =3D asoc->peer.port;
>    713          __u32 vtag =3D asoc->peer.i.init_tag;
>    714          struct sctp_transport *transport =3D NULL;
>    715          struct sctp_transport *new_transport;
>    716          struct sctp_chunk *chunk, *tmp;
>    717          sctp_xmit_t status;
>=20
> [ snip ]
>=20
>    800 =20
>    801                  /* Are we switching transports?
>    802                   * Take care of transport locks.
>    803                   */
>    804                  if (new_transport !=3D transport) {
>    805                          transport =3D new_transport;
>    806                          if (list_empty(&transport->send_ready)) {
>    807                                  list_add_tail(&transport->send_re=
ady,
>    808                                                &transport_list);
>    809                          }
>    810                          packet =3D &transport->packet;
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> packet is set here.  How do we know that "packect->transport->asoc" and
> "asoc" are the same?  It's complicated.

Yes agreed, very tricky. It's somewhat redundant information, but that
makes life easier during different stages of its life cycle.

It's like: packets are created at sctp_outq_flush (and some other
places), and then sits on an outq which belongs to a given asoc, just
like the transport. But transports doesn't have queues yet that packet
created is arranged to be sent through a given transport.
And transports always belong to a single asoc, so it's two different
ways of reaching to the same info.
                                                  v
packet->transport->asoc =3D packet->transport->asoc.outq->asoc
                                                ^----------=B4

And to make it even more complicated, with have sctp_do_peeloff(), which
will take all packets belonging to a given asoc from one socket and move
to another, potentially updating asoc pointer during that.

>    811                          sctp_packet_config(packet, vtag,
>    812                                             asoc->peer.ecn_capable=
);
>    813                  }
>=20
> Anyway, maybe eventually we'll figure out a way to make it work but even
> just reading it manually is quite complicated....
>=20
> For now, just ignore the false postive.

Okay. Let me know if I can help any further.

Thanks,
Marcelo

