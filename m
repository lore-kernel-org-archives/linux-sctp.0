From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Oct 2020 21:23:38 +0000
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <20201020212338.GG11030@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain>
 <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
In-Reply-To: <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <tuexen@fh-muenster.de>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>

On Tue, Oct 20, 2020 at 11:15:26PM +0200, Michael Tuexen wrote:
> > On 20. Oct 2020, at 23:11, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > On Tue, Oct 20, 2020 at 05:12:06PM +0800, Xin Long wrote:
> >> On Tue, Oct 20, 2020 at 6:15 AM Marcelo Ricardo Leitner
> >> <marcelo.leitner@gmail.com> wrote:
> >>> 
> >>> On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> >>>> --- a/Documentation/networking/ip-sysctl.rst
> >>>> +++ b/Documentation/networking/ip-sysctl.rst
> >>>> @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
> >>>> 
> >>>>      Default: 1
> >>>> 
> >>>> +udp_port - INTEGER
> >>> 
> >>> Need to be more verbose here, and also mention the RFC.
> >>> 
> >>>> +     The listening port for the local UDP tunneling sock.
> >>>        , shared by all applications in the same net namespace.
> >>>> +     UDP encapsulation will be disabled when it's set to 0.
> >>> 
> >>>        "Note, however, that setting just this is not enough to actually
> >>>        use it. ..."
> >> When it's a client, yes,  but when it's a server, the encap_port can
> >> be got from the incoming packet.
> >> 
> >>> 
> >>>> +
> >>>> +     Default: 9899
> >>>> +
> >>>> encap_port - INTEGER
> >>>>      The default remote UDP encapsalution port.
> >>>>      When UDP tunneling is enabled, this global value is used to set
> >>> 
> >>> When is it enabled, which conditions are needed? Maybe it can be
> >>> explained only in the one above.
> >> Thanks!
> >> pls check if this one will be better:
> > 
> > It is. Verbose enough now, thx.
> > (one other comment below)
> > 
> >> 
> >> udp_port - INTEGER
> >> 
> >> The listening port for the local UDP tunneling sock.
> >> 
> >> This UDP sock is used for processing the incoming UDP-encapsulated
> >> SCTP packets (from RFC6951), and shared by all applications in the
> >> same net namespace. This UDP sock will be closed when the value is
> >> set to 0.
> >> 
> >> The value will also be used to set the src port of the UDP header
> >> for the outgoing UDP-encapsulated SCTP packets. For the dest port,
> >> please refer to 'encap_port' below.
> >> 
> >> Default: 9899
> > 
> > I'm now wondering if this is the right default. I mean, it is the
> > standard port for it, yes, but at the same time, it means loading SCTP
> > module will steal/use that UDP port on all net namespaces and can lead
> > to conflicts with other apps. A more conservative approach here is to
> > document the standard port, but set the default to 0 and require the
> > user to set it in if it is expected to be used.
> > 
> > Did FreeBSD enable it by default too?
> No. The default is 0, which means that the encapsulation is turned off.
> Setting this sysctl variable to a non-zero value enables the UDP tunneling
> with the given port.

Thanks Michael.
Xin, then we should change this default value (and update the
documentation above accordingly, to still have the standard port #
readily available in there).

Cheers,
Marcelo
