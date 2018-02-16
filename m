From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Feb 2018 21:51:02 +0000
Subject: Re: [PATCH V6 2/4] sctp: Add ip option support
Message-Id: <20180216215102.GC4625@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180213205444.4559-1-richard_c_haines@btinternet.com>
	<20180215141539.GA21419@hmswarspite.think-freely.org>
	<20180216125607.GC4718@localhost.localdomain>
	<20180216201435.GB10040@hmswarspite.think-freely.org>
In-Reply-To: <20180216201435.GB10040@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Fri, Feb 16, 2018 at 03:14:35PM -0500, Neil Horman wrote:
> On Fri, Feb 16, 2018 at 10:56:07AM -0200, Marcelo Ricardo Leitner wrote:
> > On Thu, Feb 15, 2018 at 09:15:40AM -0500, Neil Horman wrote:
> > > On Tue, Feb 13, 2018 at 08:54:44PM +0000, Richard Haines wrote:
> > > > Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
> > > > and CALIPSO/IPv6 services.
> > > > 
> > > > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > ---
> > > >  include/net/sctp/sctp.h    |  4 +++-
> > > >  include/net/sctp/structs.h |  2 ++
> > > >  net/sctp/chunk.c           | 12 +++++++-----
> > > >  net/sctp/ipv6.c            | 42 +++++++++++++++++++++++++++++++++++-------
> > > >  net/sctp/output.c          |  5 ++++-
> > > >  net/sctp/protocol.c        | 36 ++++++++++++++++++++++++++++++++++++
> > > >  net/sctp/socket.c          | 14 ++++++++++----
> > > >  7 files changed, 97 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> > > > index f7ae6b0..25c5c87 100644
> > > > --- a/include/net/sctp/sctp.h
> > > > +++ b/include/net/sctp/sctp.h
> > > > @@ -441,9 +441,11 @@ static inline int sctp_list_single_entry(struct list_head *head)
> > > >  static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
> > > >  {
> > > >  	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
> > > > +	struct sctp_af *af = sp->pf->af;
> > > >  	int frag = pmtu;
> > > >  
> > > > -	frag -= sp->pf->af->net_header_len;
> > > > +	frag -= af->ip_options_len(asoc->base.sk);
> > > > +	frag -= af->net_header_len;
> > > >  	frag -= sizeof(struct sctphdr) + sctp_datachk_len(&asoc->stream);
> > > >  
> > > >  	if (asoc->user_frag)
> > > > diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> > > > index 03e92dd..ead5fce 100644
> > > > --- a/include/net/sctp/structs.h
> > > > +++ b/include/net/sctp/structs.h
> > > > @@ -491,6 +491,7 @@ struct sctp_af {
> > > >  	void		(*ecn_capable)(struct sock *sk);
> > > >  	__u16		net_header_len;
> > > >  	int		sockaddr_len;
> > > > +	int		(*ip_options_len)(struct sock *sk);
> > > >  	sa_family_t	sa_family;
> > > >  	struct list_head list;
> > > >  };
> > > > @@ -515,6 +516,7 @@ struct sctp_pf {
> > > >  	int (*addr_to_user)(struct sctp_sock *sk, union sctp_addr *addr);
> > > >  	void (*to_sk_saddr)(union sctp_addr *, struct sock *sk);
> > > >  	void (*to_sk_daddr)(union sctp_addr *, struct sock *sk);
> > > > +	void (*copy_ip_options)(struct sock *sk, struct sock *newsk);
> > > >  	struct sctp_af *af;
> > > >  };
> > > >  
> > > > diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> > > > index 991a530..d5c0ef7 100644
> > > > --- a/net/sctp/chunk.c
> > > > +++ b/net/sctp/chunk.c
> > > > @@ -154,7 +154,6 @@ static void sctp_datamsg_assign(struct sctp_datamsg *msg, struct sctp_chunk *chu
> > > >  	chunk->msg = msg;
> > > >  }
> > > >  
> > > > -
> > > >  /* A data chunk can have a maximum payload of (2^16 - 20).  Break
> > > >   * down any such message into smaller chunks.  Opportunistically, fragment
> > > >   * the chunks down to the current MTU constraints.  We may get refragmented
> > > > @@ -171,6 +170,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > >  	struct list_head *pos, *temp;
> > > >  	struct sctp_chunk *chunk;
> > > >  	struct sctp_datamsg *msg;
> > > > +	struct sctp_sock *sp;
> > > > +	struct sctp_af *af;
> > > >  	int err;
> > > >  
> > > >  	msg = sctp_datamsg_new(GFP_KERNEL);
> > > > @@ -189,9 +190,11 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > >  	/* This is the biggest possible DATA chunk that can fit into
> > > >  	 * the packet
> > > >  	 */
> > > > -	max_data = asoc->pathmtu -
> > > > -		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
> > > > -		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream);
> > > > +	sp = sctp_sk(asoc->base.sk);
> > > > +	af = sp->pf->af;
> > > > +	max_data = asoc->pathmtu - af->net_header_len -
> > > > +		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream) -
> > > > +		   af->ip_options_len(asoc->base.sk);
> > > >  	max_data = SCTP_TRUNC4(max_data);
> > > >  
> > > >  	/* If the the peer requested that we authenticate DATA chunks
> > > > @@ -211,7 +214,6 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > > >  
> > > >  	/* Set first_len and then account for possible bundles on first frag */
> > > >  	first_len = max_data;
> > > > -
> > > >  	/* Check to see if we have a pending SACK and try to let it be bundled
> > > >  	 * with this message.  Do this if we don't have any data queued already.
> > > >  	 * To check that, look at out_qlen and retransmit list.
> > > > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > > > index e35d4f7..0b0f895 100644
> > > > --- a/net/sctp/ipv6.c
> > > > +++ b/net/sctp/ipv6.c
> > > > @@ -427,6 +427,38 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
> > > >  	rcu_read_unlock();
> > > >  }
> > > >  
> > > > +/* Copy over any ip options */
> > > > +static void sctp_v6_copy_ip_options(struct sock *sk, struct sock *newsk)
> > > > +{
> > > > +	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
> > > > +	struct ipv6_txoptions *opt;
> > > > +
> > > > +	newnp = inet6_sk(newsk);
> > > > +
> > > > +	rcu_read_lock();
> > > > +	opt = rcu_dereference(np->opt);
> > > > +	if (opt)
> > > > +		opt = ipv6_dup_options(newsk, opt);
> > > 		do you want to print a warning here in the event the allocation
> > > for the dup operation fails?
> > > 
> > > > +	RCU_INIT_POINTER(newnp->opt, opt);
> > > > +	rcu_read_unlock();
> > > > +}
> > > > +
> > > > +/* Account for the IP options */
> > > > +static int sctp_v6_ip_options_len(struct sock *sk)
> > > > +{
> > > > +	struct ipv6_pinfo *np = inet6_sk(sk);
> > > > +	struct ipv6_txoptions *opt;
> > > > +	int len = 0;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	opt = rcu_dereference(np->opt);
> > > > +	if (opt)
> > > > +		len = opt->opt_flen + opt->opt_nflen;
> > > > +
> > > > +	rcu_read_unlock();
> > > > +	return len;
> > > > +}
> > > > +
> > > >  /* Initialize a sockaddr_storage from in incoming skb. */
> > > >  static void sctp_v6_from_skb(union sctp_addr *addr, struct sk_buff *skb,
> > > >  			     int is_saddr)
> > > > @@ -666,7 +698,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
> > > >  	struct sock *newsk;
> > > >  	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
> > > >  	struct sctp6_sock *newsctp6sk;
> > > > -	struct ipv6_txoptions *opt;
> > > >  
> > > >  	newsk = sk_alloc(sock_net(sk), PF_INET6, GFP_KERNEL, sk->sk_prot, kern);
> > > >  	if (!newsk)
> > > > @@ -689,12 +720,7 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
> > > >  	newnp->ipv6_ac_list = NULL;
> > > >  	newnp->ipv6_fl_list = NULL;
> > > >  
> > > > -	rcu_read_lock();
> > > > -	opt = rcu_dereference(np->opt);
> > > > -	if (opt)
> > > > -		opt = ipv6_dup_options(newsk, opt);
> > > > -	RCU_INIT_POINTER(newnp->opt, opt);
> > > > -	rcu_read_unlock();
> > > > +	sctp_v6_copy_ip_options(sk, newsk);
> > > >  
> > > >  	/* Initialize sk's sport, dport, rcv_saddr and daddr for getsockname()
> > > >  	 * and getpeername().
> > > > @@ -1041,6 +1067,7 @@ static struct sctp_af sctp_af_inet6 = {
> > > >  	.ecn_capable	   = sctp_v6_ecn_capable,
> > > >  	.net_header_len	   = sizeof(struct ipv6hdr),
> > > >  	.sockaddr_len	   = sizeof(struct sockaddr_in6),
> > > > +	.ip_options_len	   = sctp_v6_ip_options_len,
> > > >  #ifdef CONFIG_COMPAT
> > > >  	.compat_setsockopt = compat_ipv6_setsockopt,
> > > >  	.compat_getsockopt = compat_ipv6_getsockopt,
> > > > @@ -1059,6 +1086,7 @@ static struct sctp_pf sctp_pf_inet6 = {
> > > >  	.addr_to_user  = sctp_v6_addr_to_user,
> > > >  	.to_sk_saddr   = sctp_v6_to_sk_saddr,
> > > >  	.to_sk_daddr   = sctp_v6_to_sk_daddr,
> > > > +	.copy_ip_options = sctp_v6_copy_ip_options,
> > > >  	.af            = &sctp_af_inet6,
> > > >  };
> > > >  
> > > > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > > > index 01a26ee..668e2fa 100644
> > > > --- a/net/sctp/output.c
> > > > +++ b/net/sctp/output.c
> > > > @@ -151,7 +151,10 @@ void sctp_packet_init(struct sctp_packet *packet,
> > > >  	INIT_LIST_HEAD(&packet->chunk_list);
> > > >  	if (asoc) {
> > > >  		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
> > > > -		overhead = sp->pf->af->net_header_len;
> > > > +		struct sctp_af *af = sp->pf->af;
> > > > +
> > > > +		overhead = af->net_header_len +
> > > > +			   af->ip_options_len(asoc->base.sk);
> > > >  	} else {
> > > >  		overhead = sizeof(struct ipv6hdr);
> > > >  	}
> > > I'm a bit worried about this mechanism.  Unlike tcp or udp, where a packet is
> > > allocated its options field is pushed within the same call stack (or more
> > > notably, during a single cycle in which the sock lock is held), sctp allocates a
> > > packet here, and holds it for potentially multiple calls from userspace while
> > > chunks are collected and added to it.  During those multiple calls the socket
> > 
> > Not sure if you simplified it here but that's not exactly how it
> > works. The packet is not built chunk by chunk per sendmsg() call as
> > you described, but instead it will collect the chunks in a list (outq)
> > up to the point that it notices that it's time to send the packet.
> > Then, it will call sctp_outq_flush(), which will assemble the packet
> > and send to IP layer as needed. Chunks that won't fit on the packet
> > and that will only be sent later, they aren't added to any packet but
> > remains on outq list.
> > 
> Yes, I simplified it, and yes, given that I've maintained this code
> since 2012, I know how it works.

That's really not how I meant it. I had to read the paragraph 3 times
before seeing the simplification.  But Richard is not that acquainted
with the code and the simplification was to say the least risky for
his understanding and the implementation he is doing.

> 
> > The packet is never freed, it's embedded into the transport. It's just
> > reconfigured.
> > 
> > Nevertheless, I agree the issue is there.
> > 
> Which is really the salient point.
> 
> > > lock is released and reaquired, during which time the set of configured ip
> > > options might change.  Then when the packet is passed to the ip layer and the
> > > options copied into the packet, we might have a different option length leading
> > > to an skb_over panic.
> > > 
> > > Suggest that it might be better to buffer any changes in options and only have
> > > them take effect any time a new packet is allocated.
> > 
> > s/allocated/configured/ :)
> Seriously? You clearly knew what I was saying. I understand I misued the term,
                              yes, ^ I knew, but I doubt Richard also knew

Sorry if somehow I had this connotation. That wasn't the idea.

> but do you really want to harp on it? 

No. Just want Richard to understand what is meant here.
sctp_packet_init and sctp_packet_config are two distinct moments in
there.

> 
> > I think we can fix it by moving this code to sctp_packet_config()
> > instead. On a quick check here, seems all packet->overhead references
> > are after it gets called for a packet that is about to be built.
> > 
> Yeah, I agree we could move it there, though I think I would prefer to see it in
> sctp_packet_transmit.  If we do it there, then we only have to compute the
> overhead size once before building the skb (that is to say, if we do it in
> packet_config, we potentially compute it multiple times if we change
> transports). In fact, if we do it in sct_packet_transmit, then we potentially
> can eliminate the overhead member from the sctp_packet struct entirely, as we
> can just store the computed overhead in a stack variable and use it in the
> skb_reserve call.

in sctp_packet_transmit I think it would be too late because we have
to know the entire overhead in upfront in order to know if the chunks
that are getting enlisted on the packet actually fit in there.

  Marcelo
