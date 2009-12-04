From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 04 Dec 2009 20:52:33 +0000
Subject: Re: pull request: SCTP updates for net-next
Message-Id: <20091204125233.eea7de39.akpm@linux-foundation.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B0AF96A.3050709@hp.com>
	<20091203210050.d886f229.akpm@linux-foundation.org>
	<4B193772.9010109@hp.com>
In-Reply-To: <4B193772.9010109@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: David Miller <davem@davemloft.net>, Linux SCTP Dev Mailing list <linux-sctp@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>

On Fri, 04 Dec 2009 11:23:14 -0500
Vlad Yasevich <vladislav.yasevich@hp.com> wrote:

> > 
> > Overall, it would be way simpler and saner to clamp this value to some
> > explicit time period, IMO.
> > 
> > <pulls number out of thin air>
> > 
> > --- a/net/sctp/socket.c~a
> > +++ a/net/sctp/socket.c
> > @@ -2086,9 +2086,8 @@ static int sctp_setsockopt_autoclose(str
> >  		return -EINVAL;
> >  	if (copy_from_user(&sp->autoclose, optval, optlen))
> >  		return -EFAULT;
> > -	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
> > -	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
> > -		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
> > +	/* make sure it won't exceed one hour */
> > +	sp->autoclose = min_t(u32, sp->autoclose, 60 * 60);
> >  
> 
> But that may not be long enough.  The spec doesn't impose limits
> and it's really up to the application to decide how long it wants
> to keep idle connections open.  Thus any limits shorter the maximum
> supported by kernel are really artificial and may not be sufficient.

Could make ->autoclose a u64?  That fixes any 32bit-vs-64bit
inconsistencies and allows for an effectively infinite period.

