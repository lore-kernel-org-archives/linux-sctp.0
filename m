From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 15:28:32 +0000
Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-Id: <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
In-Reply-To: <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 08 October 2019 12:25
> >
> > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > the Potentially Failed Path State", by which users can change
> > pf_expose per sock and asoc.
>
> If I read these patches correctly the default for this sockopt in 'enabled'.
> Doesn't this mean that old application binaries will receive notifications
> that they aren't expecting?
>
> I'd have thought that applications would be required to enable it.
If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
