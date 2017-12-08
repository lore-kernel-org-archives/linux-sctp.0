From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 08 Dec 2017 16:00:01 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <20171208160001.GF3328@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <20171208153734.GB6955@hmswarspite.think-freely.org>
In-Reply-To: <20171208153734.GB6955@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Laight <David.Laight@ACULAB.COM>, 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Dec 08, 2017 at 10:37:34AM -0500, Neil Horman wrote:
> On Fri, Dec 08, 2017 at 12:56:30PM -0200, Marcelo Ricardo Leitner wrote:
> > On Fri, Dec 08, 2017 at 02:06:04PM +0000, David Laight wrote:
> > > From: Xin Long
> > > > Sent: 08 December 2017 13:04
> > > ...
> > > > @@ -264,8 +264,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > >  				frag |= SCTP_DATA_SACK_IMM;
> > > >  		}
> > > > 
> > > > -		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag,
> > > > -						 0, GFP_KERNEL);
> > > > +		chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
> > > > +						       GFP_KERNEL);
> > > 
> > > I know that none of the sctp code is very optimised, but that indirect
> > > call is going to be horrid.
> > 
> > Yeah.. but there is no way to avoid the double derreference
> > considering we only have the asoc pointer in there and we have to
> > reach the contents of the data chunk operations struct, and the .si
> > part is the same as 'stream' part as it's a constant offset.
> > 
> > Due to the for() in there, we could add a variable to store
> > asoc->stream.si outside the for and then we can do only a single deref
> > inside it. Xin, can you please try and see if the generated code is
> > different?
> > 
> > Other suggestions?
> > 
> Is it worth replacing the si struct with an index/enum value, and indexing an
> array of method pointer structs?  That would save you at least one dereference.

Hmmm, maybe, yes. It would be like
sctp_stream_interleave[asoc->stream.si].make_datafrag(...)

Then same goes for pf->af, probably.

> 
> Alternatively you could preform the dereference in two steps (i.e. declare an si
> pointer on the stack and set it equal to asoc->stream.si, then deref
> si->make_datafrag at call time.  That will at least give the compiler an
> opportunity to preload the first pointer.

Yep, that was my 2nd paragraph above :-) but it only works for cases
such as this one.

  Marcelo

> 
> Neil
> 
> >   Marcelo
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
