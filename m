From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 25 Oct 2019 14:26:57 +0000
Subject: RE: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock and asoc
Message-Id: <715b91a4a86547eb874874eda125c2ba@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
 <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
 <20191025132151.GF4326@localhost.localdomain>
In-Reply-To: <20191025132151.GF4326@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

From: 'Marcelo Ricardo Leitner'
> Sent: 25 October 2019 14:22
> On Fri, Oct 25, 2019 at 09:00:45AM +0000, David Laight wrote:
> > From: Marcelo Ricardo Leitner
> > > Sent: 25 October 2019 04:24
> > ...
> > > > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> > > >
> > > >  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> > > >  					   pinfo.spinfo_assoc_id);
> > > > -	if (!transport)
> > > > -		return -EINVAL;
> > > > +	if (!transport) {
> > > > +		retval = -EINVAL;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (transport->state = SCTP_PF &&
> > > > +	    transport->asoc->pf_expose = SCTP_PF_EXPOSE_DISABLE) {
> > > > +		retval = -EACCES;
> > > > +		goto out;
> > > > +	}
> > >
> > > As is on v3, this is NOT an UAPI violation. The user has to explicitly
> > > set the system or the socket into the disabled state in order to
> > > trigger this new check.
> >
> > Only because the default isn't to be backwards compatible with the
>                            ^^^^^
> 
> You meant "is", right? Then we're agreeing.

No, I meant isn't.
The application must see a backwards compatible interface unless
the application itself requests something different.
The sysadmin can't be allowed to change the API seen by old applications.

AFAICT if the protocol part of PF is enabled (which handles primary path
failure better than the older version) and ' transport->state = SCTP_PF'
is true then an old application binary will  get a completely unexpected -EACCESS
rather than a valid state (out of the old valid states) if it requests 'peer addr_info'.

You cannot assume that just because some sysctl is set (because someone
building a distribution suddenly decided it was a 'good idea') that an
application binary will not fall in a big heap due to an error condition
that couldn't ever happen before.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
