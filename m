From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Fri, 25 Oct 2019 13:21:51 +0000
Subject: Re: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock and asoc
Message-Id: <20191025132151.GF4326@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
 <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
In-Reply-To: <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Oct 25, 2019 at 09:00:45AM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 25 October 2019 04:24
> ...
> > > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> > >
> > >  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> > >  					   pinfo.spinfo_assoc_id);
> > > -	if (!transport)
> > > -		return -EINVAL;
> > > +	if (!transport) {
> > > +		retval = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (transport->state = SCTP_PF &&
> > > +	    transport->asoc->pf_expose = SCTP_PF_EXPOSE_DISABLE) {
> > > +		retval = -EACCES;
> > > +		goto out;
> > > +	}
> > 
> > As is on v3, this is NOT an UAPI violation. The user has to explicitly
> > set the system or the socket into the disabled state in order to
> > trigger this new check.
> 
> Only because the default isn't to be backwards compatible with the
                           ^^^^^

You meant "is", right? Then we're agreeing.

> old kernel and old applications.
> 
> An old application running on a system that has the protocol parts of
> PF enabled mustn't see any PF events, states or obscure error returns.

Yes. With the patchset, the application will only see the new error
return if it (the app or the sysadmin) explicitly choose to be more
compliant to the RFC. There's no harm in that.
