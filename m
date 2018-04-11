From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Apr 2018 14:59:10 +0000
Subject: Re: [PATCH net] sctp: do not check port in sctp_inet6_cmp_addr
Message-Id: <20180411145910.GC3711@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <340aad3be762046ca9d02e54edba5bfefa2f4e71.1523451485.git.lucien.xin@gmail.com>
 <20180411143607.GA4141@hmswarspite.think-freely.org>
In-Reply-To: <20180411143607.GA4141@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Wed, Apr 11, 2018 at 10:36:07AM -0400, Neil Horman wrote:
> On Wed, Apr 11, 2018 at 08:58:05PM +0800, Xin Long wrote:
> > pf->cmp_addr() is called before binding a v6 address to the sock. It
> > should not check ports, like in sctp_inet_cmp_addr.
> >
> > But sctp_inet6_cmp_addr checks the addr by invoking af(6)->cmp_addr,
> > sctp_v6_cmp_addr where it also compares the ports.
> >
> > This would cause that setsockopt(SCTP_SOCKOPT_BINDX_ADD) could bind
> > multiple duplicated IPv6 addresses after Commit 40b4f0fd74e4 ("sctp:
> > lack the check for ports in sctp_v6_cmp_addr").
> >
> > This patch is to remove af->cmp_addr called in sctp_inet6_cmp_addr,
> > but do the proper check for both v6 addrs and v4mapped addrs.
> >
> > Fixes: 40b4f0fd74e4 ("sctp: lack the check for ports in sctp_v6_cmp_addr")
> > Reported-by: Jianwen Ji <jiji@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/ipv6.c | 27 ++++++++++++++++++++++++---
> >  1 file changed, 24 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > index f1fc48e..be4b72c 100644
> > --- a/net/sctp/ipv6.c
> > +++ b/net/sctp/ipv6.c
> > @@ -846,8 +846,8 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
> >  			       const union sctp_addr *addr2,
> >  			       struct sctp_sock *opt)
> >  {
> > -	struct sctp_af *af1, *af2;
> >  	struct sock *sk = sctp_opt2sk(opt);
> > +	struct sctp_af *af1, *af2;
> >
> >  	af1 = sctp_get_af_specific(addr1->sa.sa_family);
> >  	af2 = sctp_get_af_specific(addr2->sa.sa_family);
> > @@ -863,10 +863,31 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
> >  	if (sctp_is_any(sk, addr1) || sctp_is_any(sk, addr2))
> >  		return 1;
> >
> > -	if (addr1->sa.sa_family != addr2->sa.sa_family)
> > +	if (addr1->sa.sa_family != addr2->sa.sa_family) {
> > +		if (addr1->sa.sa_family = AF_INET &&
> > +		    addr2->sa.sa_family = AF_INET6 &&
> > +		    ipv6_addr_v4mapped(&addr2->v6.sin6_addr))
> > +			if (addr2->v6.sin6_addr.s6_addr32[3] =
> > +			    addr1->v4.sin_addr.s_addr)
> > +				return 1;
> > +		if (addr2->sa.sa_family = AF_INET &&
> > +		    addr1->sa.sa_family = AF_INET6 &&
> > +		    ipv6_addr_v4mapped(&addr1->v6.sin6_addr))
> > +			if (addr1->v6.sin6_addr.s6_addr32[3] =
> > +			    addr2->v4.sin_addr.s_addr)
> > +				return 1;
> > +		return 0;
> > +	}
> > +
> > +	if (!ipv6_addr_equal(&addr1->v6.sin6_addr, &addr2->v6.sin6_addr))
> > +		return 0;
> > +
> > +	if ((ipv6_addr_type(&addr1->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
> > +	    addr1->v6.sin6_scope_id && addr2->v6.sin6_scope_id &&
> > +	    addr1->v6.sin6_scope_id != addr2->v6.sin6_scope_id)
> >  		return 0;
> >
> > -	return af1->cmp_addr(addr1, addr2);
> > +	return 1;
> >  }
> >
> >  /* Verify that the provided sockaddr looks bindable.   Common verification,
> > --
> > 2.1.0
> >
> This looks correct to me, but is it worth duplicating the comparison code like
> this from the cmp_addr function?  It might be more worthwhile to add a flag to
> the cmp_addr method to direct weather it needs to check port values or not.
> That way you could continue to use the cmp_addr function here.

Adding a flag into sctp_v6_cmp_addr will get us a terrible code to
read. It's already not one of the best looking part of it. Maybe
still duplicate part of it it, but at 'af' level? As in:
- af->cmp_addr
- af->cmp_addr_port

  Marcelo
