From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 21 Jul 2014 11:15:45 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140721111545.GB9040@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 10, 2014 at 01:58:56PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 10, 2014 at 07:33:22AM -0400, Neil Horman wrote:
> > On Wed, Jul 09, 2014 at 12:51:09PM -0600, Jason Gunthorpe wrote:
> > > On Wed, Jul 09, 2014 at 02:27:02PM -0400, Neil Horman wrote:
> > > 
> > > > > Hum, this looks funny without a family assigment, how does the the
> > > > > next thing to look at sk know if is a AF_INET vs AF_INET6?
> > > > > 
> > > > Neither clause has a family assignment.  Hmm, I wonder if they need one.
> > > 
> > > I don't know off hand, I think it depends what happens to 'sk' later
> > > 
> > Ah, its filled out in the protocols from_sk method, and ipv6 doesn't curently
> > have one, so we don't need to worry about it (yet).
> 
> Hurm. 
> 
> No, it is just more deeply broken then that..
> 
> getpeername() and getsockname() just don't work properly at all with
> V6, it returns garbage with a v4 address becomes involved.
> 
> For an AF_INET6 socket the local and peer address should always be
> stored in the inet6_sk as a mapped address, the inet_sk stuff
> shouldn't really be used..
> 
> I fixed this in the revised patch by making to_sk_daddr/saddr part of
> the pf and removing all sensitivity on the address af. The conversion
> now uniformly stores any value as AF_INET6.
> 
> Instead I get the v4mapped behavior at the new getname entry point,
> which fixes all the problems I could see here.
> 
> > Ah, sorry, didn't understand what you were getting at.  You will
> > enter the above path if you have an ipv6 socket created and try to
> > bind it to a local ipv4 address.  Test that with and without
> > v4mapped set, and you should get complete coverage of that
> > conditional.
> 
> No, I am already testing that.. 
> 
> Hurm, there is more that needs fixing..
> 
> Testing binding to ::ffff:127.0.0.1 and ::1 (ie both are passed into
> the kernel as AF_INET6) causes a behavior difference based on
> v4mapped, when 0 we get 'sctp_bindx - 99: Cannot assign requested
> address'
> 
> 1) Bind should not be sensitive to v4mapped or not, so lets drop this
>    test:
> 
> @@ -880,9 +872,6 @@ static int sctp_inet6_bind_verify(struct sctp_sock *opt, union sctp_addr *addr)
>                                 return 0;
>                         }
>                         rcu_read_unlock();
> -               } else if (type = IPV6_ADDR_MAPPED) {
> -                       if (!opt->v4mapped)
> -                               return 0;
>                 }
>  
> 
>   That fixes the bindx failure, and now we hit coverage in
>   sctp_v6_available
> 
> 2) I added a BUG_ON(addr->v4.sin_family != AF_INET) to
>    sctp_v4_available, and now it triggers, as I said, the flow
>    changed in the patch. So drop the test for mapped in available, and
>    unconditionally map.
> 
> @@ -554,12 +564,10 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
>  
>  	type = ipv6_addr_type(in6);
>  	if (IPV6_ADDR_ANY = type)
>  		return 1;
>  	if (type = IPV6_ADDR_MAPPED) {
> -		if (sp && !sp->v4mapped)
> -			return 0;
>  		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
>  			return 0;
>  		sctp_v6_map_v4(addr);
>  		return sctp_get_af_specific(AF_INET)->available(addr, sp);
>  	}
> 
>   Note, this makes sense because none of these routines are generating
>   addresses to be passed back to user space, so none should be looking
>   at mapped.
>  
> The attached patch fixes all my test cases, and having looked it very
> carefully now, I'm pretty comfortable with the bulk, what worries me
> is other stuff that might be missed...
> 
> I'm a little worried about sctp_addr_id2transport, I'm not sure it
> should be calling addr_v4map, that probably should be an unconditional
> promotion?
> 
> I also wonder if sctp_v6_addr_v4map should demote mapped v6 back into
> v4? I suspect yes it should.


ok, I've looked at this over the weekend, and for the most part I think it looks
ok.  Regarding your questions, I think sctp_id2transport is ok as it is, since
that path is used for both ipv4 and ipv6, making unconditional promotion a bad
idea.  Calling the addr_map method lets us choose the v4 mapping function
(empty), or the v6 mapping function, which only does a map if a v4 address is
passed in.

And I don't think we need to do any demotion of addresses as sctp_v6_addr_v4map
is only called if the socket is AF_INET6, and can handle v6 addresses
transparently.  If the socket was created as AF_INET, we're safe, because that
will reject AF_INET6 addresses anyway.

If you're testing in the interviening week hasn't shown any further problems,
I'd say officially post this with my signed off please.
Neil

