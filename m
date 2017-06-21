From: Joe Perches <joe@perches.com>
Date: Wed, 21 Jun 2017 19:19:10 +0000
Subject: Re: [PATCH] net/sctp/ulpevent.c: Deinline sctp_ulpevent_set_owner, save 1616 bytes
Message-Id: <1498072750.3337.4.camel@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170621162809.4305-1-dvlasenk@redhat.com>
In-Reply-To: <20170621162809.4305-1-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, 2017-06-21 at 18:28 +0200, Denys Vlasenko wrote:
> This function compiles to 147 bytes of machine code. 13 callsites.
>=20
> I'm no expert on SCTP events, but quick reading of SCTP docs tells me that
> SCTP events are not happening on every packet.
> They are ASSOC_CHANGE, PEER_ADDR_CHANGE, REMOTE_ERROR and such.
> Does not look performance critical.

Thanks.

But:

> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
[]
> @@ -88,7 +88,7 @@ int sctp_ulpevent_is_notification(const struct sctp_ulp=
event *event)
>  /* Hold the association in case the msg_name needs read out of
>   * the association.
>   */
> -static inline void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
> +static void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
>  					   const struct sctp_association *asoc)
>  {
>  	struct sctp_chunk *chunk =3D event->chunk;

This now misaligns the next line after the inline removal.

Can you please run your patches through checkpatch?

$ ./scripts/checkpatch.pl -
CHECK: Alignment should match open parenthesis
#86: FILE: net/sctp/ulpevent.c:92:
+static void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
=A0					=A0=A0=A0const struct sctp_association *asoc)

