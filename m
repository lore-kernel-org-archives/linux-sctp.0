From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 17 Aug 2020 14:35:54 +0000
Subject: Re: sctp: num_ostreams and max_instreams negotiation
Message-Id: <20200817143554.GI3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
 <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
 <20200817142223.GH3399@localhost.localdomain>
In-Reply-To: <20200817142223.GH3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, 'Neil Horman' <nhorman@tuxdriver.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, 'Andrew Morton' <akpm@linux-foundation.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

On Mon, Aug 17, 2020 at 11:22:23AM -0300, Marcelo Ricardo Leitner wrote:
> On Sat, Aug 15, 2020 at 02:49:31PM +0000, David Laight wrote:
> > From: David Laight
> > > Sent: 14 August 2020 17:18
> > > 
> > > > > > At some point the negotiation of the number of SCTP streams
> > > > > > seems to have got broken.
> > > > > > I've definitely tested it in the past (probably 10 years ago!)
> > > > > > but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
> > > > > > returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
> > > > > > rather than the smaller of that value and that configured
> > > > > > at the other end of the connection.
> > > > > >
> > > > > > I'll do a bit of digging.
> > > > >
> > > > > I can't find the code that processes the init_ack.
> > > > > But when sctp_procss_int() saves the smaller value
> > > > > in asoc->c.sinint_max_ostreams.
> > > > >
> > > > > But afe899962ee079 (if I've typed it right) changed
> > > > > the values SCTP_INFO reported.
> > > > > Apparantly adding 'sctp reconfig' had changed things.
> > > > >
> > > > > So I suspect this has all been broken for over 3 years.
> > > >
> > > > It looks like the changes that broke it went into 4.11.
> > > > I've just checked a 3.8 kernel and that negotiates the
> > > > values down in both directions.
> > > >
> > > > I don't have any kernels lurking between 3.8 and 4.15.
> > > > (Yes, I could build one, but it doesn't really help.)
> > > 
> > > Ok, bug located - pretty obvious really.
> > > net/sctp/stream. has the following code:
> > > 
> > > static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> > > 				 gfp_t gfp)
> > > {
> > > 	int ret;
> > > 
> > > 	if (outcnt <= stream->outcnt)
> > > 		return 0;
> > 
> > Deleting this check is sufficient to fix the code.
> > Along with the equivalent check in sctp_stream-alloc_in().
> 
> 2075e50caf5e has:
> 
> -       if (outcnt > stream->outcnt)
> -               fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
> +       if (outcnt <= stream->outcnt)
> +               return 0;
> 
> -       stream->out = out;
> +       ret = genradix_prealloc(&stream->out, outcnt, gfp);
> +       if (ret)
> +               return ret;
> 
> +       stream->outcnt = outcnt;
>         return 0;
> 
> The flip on the if() return missed that stream->outcnt needs to be
> updated later on even if it is reducing the size.
> 
> The proper fix here is to move back to the original if() condition,
> and put genradix_prealloc() inside it again, as was fa_zero() before.
> The if() is not strictly needed, because genradix_prealloc() will
> handle it nicely, but it's a nice-to-have optimization anyway.
> 
> Do you want to send a patch?

Note the thread 'Subject: RE: v5.3.12 SCTP Stream Negotiation Problem'
though.

  Marcelo
