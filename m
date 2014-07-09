From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 09 Jul 2014 18:27:02 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140709182702.GA14509@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jul 09, 2014 at 10:28:14AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 09, 2014 at 11:50:15AM -0400, Neil Horman wrote:
> 
> > Sorry for the delay, busy few days.  I think this fixes up all the
> > required call sites that check v4mapped.  I've not tested it yet,
> > but it builds.  If you could please give it a spin and let me know,
> > I'll officially propose it.
> 
> Thanks, I'll try and run it today..
> 
> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > index 1999592..5261ac5 100644
> > +++ b/net/sctp/ipv6.c
> > @@ -434,12 +434,17 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
> >  /* Initialize sk->sk_rcv_saddr from sctp_addr. */
> >  static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
> >  {
> > -	if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
> > -		sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
> > -		sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
> > -		sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
> > -		sk->sk_v6_rcv_saddr.s6_addr32[3] > > +	if (addr->sa.sa_family = AF_INET) {
> > +		if (sctp_sk(sk)->v4mapped) {
> > +			sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
> > +			sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
> > +			sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
> > +			sk->sk_v6_rcv_saddr.s6_addr32[3] > >  			addr->v4.sin_addr.s_addr;
> > +		} else {
> > +			inet_sk(sk)->inet_rcv_saddr > > +			addr->v4.sin_addr.s_addr;
> 
> Hum, this looks funny without a family assigment, how does the the
> next thing to look at sk know if is a AF_INET vs AF_INET6?
> 
Neither clause has a family assignment.  Hmm, I wonder if they need one.

> > @@ -556,11 +566,10 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
> >  	if (IPV6_ADDR_ANY = type)
> >  		return 1;
> >  	if (type = IPV6_ADDR_MAPPED) {
> > -		if (sp && !sp->v4mapped)
> > -			return 0;
> >  		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
> >  			return 0;
> > -		sctp_v6_map_v4(addr);
> > +		if (sp && sp->v4mapped)
> > +			sctp_v6_map_v4(addr);
> 
> What scenario is required to go into this if? When I run my test I
> did not hit (sp && !sp->v4mapped) ..
> 
Not sure what you mean here.  Just because you're testing didn't hit it doesn't
really mean anything.  if v4_mapped is enabled you want to map the incomming v4
address into a v6 address, otherwise, you just want to pass the address to the
sctp v4 available method.

> > @@ -587,11 +596,10 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
> > -		sctp_v6_map_v4(addr);
> > +		if (sp && sp->v4mapped)
> > +			sctp_v6_map_v4(addr);
> 
> Ditto?
> 
Ditto.

> > @@ -739,12 +749,16 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
> > +			} else {
> > +				sin->sin_addr.s_addr = addr->v4.sin_addr.s_addr;
> > +				sin->sin_family = AF_INET;
> 
> Missing port?
Shoot, I was thinking that was covered by the sin6 port assignment, but they
don't overlap.  Can you add that during your testing?

> 
> +                               sin->sin_port = htons(asoc->peer.port);
> 
> Jason
> 
