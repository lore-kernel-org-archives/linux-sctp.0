From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Thu, 21 May 2020 14:36:53 +0000
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
Message-Id: <20200521143653.GA74252@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521001725.GW2491@localhost.localdomain>
 <e777874fbd0e4ccb813e08145f3c3359@AcuMS.aculab.com>
In-Reply-To: <e777874fbd0e4ccb813e08145f3c3359@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

On Thu, May 21, 2020 at 07:32:14AM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 21 May 2020 01:17
> > On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> > ...
> > > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > > It is also the only getsockopt() that wants to return a buffer
> > > and an error code. It is also definitely abusing getsockopt().
> > ...
> > > @@ -1375,11 +1350,11 @@ struct compat_sctp_getaddrs_old {
> > >  #endif
> > >
> > >  static int sctp_getsockopt_connectx3(struct sock *sk, int len,
> > > -				     char __user *optval,
> > > -				     int __user *optlen)
> > > +				     struct sctp_getaddrs_old *param,
> > > +				     int *optlen)
> > >  {
> > > -	struct sctp_getaddrs_old param;
> > >  	sctp_assoc_t assoc_id = 0;
> > > +	struct sockaddr *addrs;
> > >  	int err = 0;
> > >
> > >  #ifdef CONFIG_COMPAT
> ..
> > >  	} else
> > >  #endif
> > >  	{
> > > -		if (len < sizeof(param))
> > > +		if (len < sizeof(*param))
> > >  			return -EINVAL;
> > > -		if (copy_from_user(&param, optval, sizeof(param)))
> > > -			return -EFAULT;
> > >  	}
> > >
> > > -	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
> > > -					 param.addrs, param.addr_num,
> > > +	addrs = memdup_user(param->addrs, param->addr_num);
> > 
> > I'm staring at this for a while now but I don't get this memdup_user.
> > AFAICT, params->addrs is not __user anymore here, because
> > sctp_getsockopt() copied the whole thing already, no?
> > Also weird because it is being called from kernel_sctp_getsockopt(),
> > which now has no knowledge of __user buffers.
> > Maybe I didn't get something from the patch description.
> 
> The connectx3 sockopt buffer contains a pointer to the user buffer
> that contains the actual addresses.
> So a second copy_from_user() is needed.

Oh, I see now. Thanks.

> 
> This does mean that this option can only be actioned from userspace.
> 
> Kernel code can get the same functionality using one of the
> other interfaces to connectx().
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
