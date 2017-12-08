From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Fri, 08 Dec 2017 16:02:04 +0000
Subject: Re: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <20171208160204.GU13341@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
 <20171208145630.GE3328@localhost.localdomain>
 <67253734d93744a2b3b05d4a0bbe4a8f@AcuMS.aculab.com>
 <20171208151538.GT13341@localhost.localdomain>
 <60df84ed900b49799782a43c84be0bc4@AcuMS.aculab.com>
In-Reply-To: <60df84ed900b49799782a43c84be0bc4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Dec 08, 2017 at 03:32:54PM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 08 December 2017 15:16
> > On Fri, Dec 08, 2017 at 03:01:31PM +0000, David Laight wrote:
> > > From: Marcelo Ricardo Leitner
> > > > Sent: 08 December 2017 14:57
> > > >
> > > > On Fri, Dec 08, 2017 at 02:06:04PM +0000, David Laight wrote:
> > > > > From: Xin Long
> > > > > > Sent: 08 December 2017 13:04
> > > > > ...
> > > > > > @@ -264,8 +264,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > > > >  				frag |= SCTP_DATA_SACK_IMM;
> > > > > >  		}
> > > > > >
> > > > > > -		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag,
> > > > > > -						 0, GFP_KERNEL);
> > > > > > +		chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
> > > > > > +						       GFP_KERNEL);
> > > > >
> > > > > I know that none of the sctp code is very optimised, but that indirect
> > > > > call is going to be horrid.
> > > >
> > > > Yeah.. but there is no way to avoid the double derreference
> > > > considering we only have the asoc pointer in there and we have to
> > > > reach the contents of the data chunk operations struct, and the .si
> > > > part is the same as 'stream' part as it's a constant offset.
> > > ...
> > >
> > > It isn't only the double indirect, the indirect call itself isn't 'fun'.
> > 
> > I meant in this context.
> > 
> > The indirect call is so we don't have to flood the stack with
> > if (old data chunk fmt) {
> > 	...
> > } else {
> > 	...
> > }
> > 
> > So instead of this, we now have some key operations identified and
> > wrapped up behind this struct, allowing us to abstract whatever data
> > chunk format it is.
> 
> Nothing wrong with:
> #define foo(asoc, ...) \
> 	if (asoc->new_fmt) \

Not all function pointers in sctp_stream_interleave have asoc as
a parameter, so we would have to have something like:

#define foo_asoc(asoc, ...) \
	if (asoc->new_fmt) \
		...

#define foo_chunk(chunk, ...) \
	if (chunk->asoc->new_fmt) \
		...

#define foo_ulpq(ulpq, ...) \
	if (ulpq->asoc->new_fmt) \
		...

and we're pretty much back to double deref.
Maybe some reworking on the parameters could alleviate some of these,
but not all.

> 		foo_new(asoc, __VA_LIST__); \
> 	else \
> 		foo_old(asoc, __VA_LIST__);
> 
> > > I think there are other hot paths where you've replaced a sizeof()
> > > with a ?: clause.
> > > Caching the result might be much better.
> > 
> > The only new ?: clause I could find this patchset is on patch 12 and
> > has nothing to do with sizeof().
> > 
> > The sizeof() results are indeed cached, as you can see in patch 4:
> > +static struct sctp_stream_interleave sctp_stream_interleave_0 = {
> > +       .data_chunk_len         = sizeof(struct sctp_data_chunk),
> > and the two helpers on it at the begining of the patch.
> 
> I was getting two bits mixed up.
> But the code that reads data_chunk_len is following an awful lot of pointers.

From path 4:
        max_data = asoc->pathmtu -
                   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
-                  sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk);
+                  sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream);

You're worried with the double deref in sctp_datachk_len() but on the
line right above it we have 4 derefs. There are several other cases
of double deref in sctp stack even on hot path. Not sure why you're
picking on this one, but ok.

  Marcelo
