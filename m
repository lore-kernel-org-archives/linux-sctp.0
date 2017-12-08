From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Dec 2017 15:01:31 +0000
Subject: RE: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <67253734d93744a2b3b05d4a0bbe4a8f@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
In-Reply-To: <20171208145630.GE3328@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

From: Marcelo Ricardo Leitner
> Sent: 08 December 2017 14:57
> 
> On Fri, Dec 08, 2017 at 02:06:04PM +0000, David Laight wrote:
> > From: Xin Long
> > > Sent: 08 December 2017 13:04
> > ...
> > > @@ -264,8 +264,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > >  				frag |= SCTP_DATA_SACK_IMM;
> > >  		}
> > >
> > > -		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag,
> > > -						 0, GFP_KERNEL);
> > > +		chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
> > > +						       GFP_KERNEL);
> >
> > I know that none of the sctp code is very optimised, but that indirect
> > call is going to be horrid.
> 
> Yeah.. but there is no way to avoid the double derreference
> considering we only have the asoc pointer in there and we have to
> reach the contents of the data chunk operations struct, and the .si
> part is the same as 'stream' part as it's a constant offset.
...

It isn't only the double indirect, the indirect call itself isn't 'fun'.

I think there are other hot paths where you've replaced a sizeof()
with a ?: clause.
Caching the result might be much better.

	David

