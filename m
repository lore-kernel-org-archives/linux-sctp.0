From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Wed, 09 Jul 2014 18:51:09 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140709185109.GA4640@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jul 09, 2014 at 02:27:02PM -0400, Neil Horman wrote:

> > Hum, this looks funny without a family assigment, how does the the
> > next thing to look at sk know if is a AF_INET vs AF_INET6?
> > 
> Neither clause has a family assignment.  Hmm, I wonder if they need one.

I don't know off hand, I think it depends what happens to 'sk' later

> > > @@ -556,11 +566,10 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
> > >  	if (IPV6_ADDR_ANY = type)
> > >  		return 1;
> > >  	if (type = IPV6_ADDR_MAPPED) {
> > > -		if (sp && !sp->v4mapped)
> > > -			return 0;
> > >  		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
> > >  			return 0;
> > > -		sctp_v6_map_v4(addr);
> > > +		if (sp && sp->v4mapped)
> > > +			sctp_v6_map_v4(addr);
> > 
> > What scenario is required to go into this if? When I run my test I
> > did not hit (sp && !sp->v4mapped) ..

> Not sure what you mean here.  Just because you're testing didn't hit it doesn't
> really mean anything.  if v4_mapped is enabled you want to map the incomming v4
> address into a v6 address, otherwise, you just want to pass the address to the
> sctp v4 available method.

Well, I quickly tested many combinations of v4 and v6 interworking and
it never covered that if. So if I want to see that the above is
working properly what do I need to have the test do?

Also, looking at the whole sequence, I just noticed:

-               sctp_v6_map_v4(addr);
+               if (sp && sp->v4mapped)
+                       sctp_v6_map_v4(addr);
                return sctp_get_af_specific(AF_INET)->available(addr, sp);
        }

It doesn't look right to call '(AF_INET)->available(addr' when addr is
an AF_INET6.. Doesn't making the call to sctp_v6_map_v4 conditional
create that possibility now?

> > > @@ -739,12 +749,16 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
> > > +			} else {
> > > +				sin->sin_addr.s_addr = addr->v4.sin_addr.s_addr;
> > > +				sin->sin_family = AF_INET;
> > 
> > Missing port?

> Shoot, I was thinking that was covered by the sin6 port assignment, but they
> don't overlap.  Can you add that during your testing?

Sure

Jason
