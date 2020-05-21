From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 21 May 2020 16:09:15 +0000
Subject: RE: [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
Message-Id: <a681d1dc056a412bba24b9b4cde37785@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521153729.GB74252@localhost.localdomain>
In-Reply-To: <20200521153729.GB74252@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Christoph Hellwig <hch@lst.de>

From: 'Marcelo Ricardo Leitner'
> Sent: 21 May 2020 16:37
> On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
...
> > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > It is also the only getsockopt() that wants to return a buffer
> > and an error code. It is also definitely abusing getsockopt().
> 
> It should have been a linear buffer. The secondary __user access is
> way worse than having the application to do another allocation. But
> too late..

I think that is SCTP_SOCKOPT_CONNECTX ?

> Other than the comments here, this patch LGTM.

Thanks.

> Assuming a v2 is coming, to appease the buildbot :)

I'd got an definition in sctp.h and an EXPORT() but took them out.
I'll also increase the setsockopt limit.

...
> > +	if (optlen < sizeof (param_buf)) {
> > +		if (copy_from_user(&param_buf, u_optval, optlen))
> > +			return -EFAULT;
> > +		optval = param_buf;
> > +	} else {
> > +		if (optlen > USHRT_MAX)
> > +			optlen = USHRT_MAX;
> 
> There are functions that can work with and expect buffers larger than
> that, such as sctp_setsockopt_auth_key:

I'd assumed the maximums were silly.
But a few more than 64k is enough, the lengths are in bytes.
OTOH 128k is a nice round limit - and plenty AFAICT.

...
> > +	if (len < sizeof (param_buf)) {
> > +		/* Zero first bytes to stop KASAN complaining. */
> > +		param_buf[0] = 0;
> > +		if (copy_from_user(&param_buf, u_optval, len))
> > +			return -EFAULT;
> > +		optval = param_buf;
> > +	} else {
> > +		if (len > USHRT_MAX)
> > +			len = USHRT_MAX;
> 
> This limit is not present today for sctp_getsockopt_local_addrs()
> calls (there may be others).  As is, it will limit it and may mean
> that it can't dump all addresses.  We have discussed this and didn't
> come to a conclusion on what is a safe limit to use here, at least not
> on that time.

It needs some limit. memdup_user() might limit at 32MB.
I couldn't decide is some of the allocators limit it further.
In any case an IPv6 address is what? under 128 bytes.
64k is 512 address, things are going to explode elsewhere first.

I didn't see 'get' requests that did 64k + a bit.

It should be possible to loop using a larger kernel buffer if the
data won't fit.
Doable as a later patch to avoid complications.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
