From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 21 Feb 2018 14:33:45 +0000
Subject: Re: [PATCH V7 2/4] sctp: Add ip option support
Message-Id: <20180221143345.GA3888@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180220191527.14307-1-richard_c_haines@btinternet.com>
In-Reply-To: <20180220191527.14307-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, Feb 20, 2018 at 07:15:27PM +0000, Richard Haines wrote:
> Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
> and CALIPSO/IPv6 services.
> 
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>

LGTM too, thanks!

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
> All SCTP lksctp-tools/src/func_tests run correctly in enforcing mode.
> All "./sctp-tests run" obtained from: https://github.com/sctp/sctp-tests
> pass.
> 
> V7 Changes:
> 1) Log when copy ip options fail for IPv4 and IPv6
> 2) Correct sctp_setsockopt_maxseg() function. Note that the lksctp-tools
> func_tests do not test with struct sctp_assoc_value. Just used simple test
> and okay.
> 3) Move calculation of overheads to sctp_packet_config().
> NOTE: Initially in sctp_packet_reset() I set packet->size and
> packet->overhead to zero (as it is a reset). This was okay for all the
> lksctp-tools function tests, however when running "sctp-tests" ndatshched
> tests it causes these to fail with an st_s.log entry of:
> 	sid: 3, expected: 3
> 	sid: 3, expected: 3
> 	unexpected sid packet !!!
> 	sid: 1, expected: 3
> 
> I then found sctp_packet_transmit() relies on setting
> "packet->size = packet->overhead;" to reset size to the current overhead
> after sending packets, hence the comment in sctp_packet_reset()
> 
>  include/net/sctp/sctp.h    |  4 +++-
>  include/net/sctp/structs.h |  2 ++
>  net/sctp/chunk.c           | 10 +++++++---
>  net/sctp/ipv6.c            | 45 ++++++++++++++++++++++++++++++++++++++-------
>  net/sctp/output.c          | 34 +++++++++++++++++++++-------------
>  net/sctp/protocol.c        | 38 ++++++++++++++++++++++++++++++++++++++
>  net/sctp/socket.c          | 11 ++++++++---
>  7 files changed, 117 insertions(+), 27 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index f7ae6b0..25c5c87 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -441,9 +441,11 @@ static inline int sctp_list_single_entry(struct list_head *head)
>  static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
>  {
>  	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
> +	struct sctp_af *af = sp->pf->af;
>  	int frag = pmtu;
>  
> -	frag -= sp->pf->af->net_header_len;
> +	frag -= af->ip_options_len(asoc->base.sk);
> +	frag -= af->net_header_len;
>  	frag -= sizeof(struct sctphdr) + sctp_datachk_len(&asoc->stream);
>  
>  	if (asoc->user_frag)
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 03e92dd..ead5fce 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -491,6 +491,7 @@ struct sctp_af {
>  	void		(*ecn_capable)(struct sock *sk);
>  	__u16		net_header_len;
>  	int		sockaddr_len;
> +	int		(*ip_options_len)(struct sock *sk);
>  	sa_family_t	sa_family;
>  	struct list_head list;
>  };
> @@ -515,6 +516,7 @@ struct sctp_pf {
>  	int (*addr_to_user)(struct sctp_sock *sk, union sctp_addr *addr);
>  	void (*to_sk_saddr)(union sctp_addr *, struct sock *sk);
>  	void (*to_sk_daddr)(union sctp_addr *, struct sock *sk);
> +	void (*copy_ip_options)(struct sock *sk, struct sock *newsk);
>  	struct sctp_af *af;
>  };
>  
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 991a530..d726d21 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -171,6 +171,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  	struct list_head *pos, *temp;
>  	struct sctp_chunk *chunk;
>  	struct sctp_datamsg *msg;
> +	struct sctp_sock *sp;
> +	struct sctp_af *af;
>  	int err;
>  
>  	msg = sctp_datamsg_new(GFP_KERNEL);
> @@ -189,9 +191,11 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  	/* This is the biggest possible DATA chunk that can fit into
>  	 * the packet
>  	 */
> -	max_data = asoc->pathmtu -
> -		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
> -		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream);
> +	sp = sctp_sk(asoc->base.sk);
> +	af = sp->pf->af;
> +	max_data = asoc->pathmtu - af->net_header_len -
> +		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream) -
> +		   af->ip_options_len(asoc->base.sk);
>  	max_data = SCTP_TRUNC4(max_data);
>  
>  	/* If the the peer requested that we authenticate DATA chunks
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index e35d4f7..30a05a8 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -427,6 +427,41 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
>  	rcu_read_unlock();
>  }
>  
> +/* Copy over any ip options */
> +static void sctp_v6_copy_ip_options(struct sock *sk, struct sock *newsk)
> +{
> +	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
> +	struct ipv6_txoptions *opt;
> +
> +	newnp = inet6_sk(newsk);
> +
> +	rcu_read_lock();
> +	opt = rcu_dereference(np->opt);
> +	if (opt) {
> +		opt = ipv6_dup_options(newsk, opt);
> +		if (!opt)
> +			pr_err("%s: Failed to copy ip options\n", __func__);
> +	}
> +	RCU_INIT_POINTER(newnp->opt, opt);
> +	rcu_read_unlock();
> +}
> +
> +/* Account for the IP options */
> +static int sctp_v6_ip_options_len(struct sock *sk)
> +{
> +	struct ipv6_pinfo *np = inet6_sk(sk);
> +	struct ipv6_txoptions *opt;
> +	int len = 0;
> +
> +	rcu_read_lock();
> +	opt = rcu_dereference(np->opt);
> +	if (opt)
> +		len = opt->opt_flen + opt->opt_nflen;
> +
> +	rcu_read_unlock();
> +	return len;
> +}
> +
>  /* Initialize a sockaddr_storage from in incoming skb. */
>  static void sctp_v6_from_skb(union sctp_addr *addr, struct sk_buff *skb,
>  			     int is_saddr)
> @@ -666,7 +701,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
>  	struct sock *newsk;
>  	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
>  	struct sctp6_sock *newsctp6sk;
> -	struct ipv6_txoptions *opt;
>  
>  	newsk = sk_alloc(sock_net(sk), PF_INET6, GFP_KERNEL, sk->sk_prot, kern);
>  	if (!newsk)
> @@ -689,12 +723,7 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
>  	newnp->ipv6_ac_list = NULL;
>  	newnp->ipv6_fl_list = NULL;
>  
> -	rcu_read_lock();
> -	opt = rcu_dereference(np->opt);
> -	if (opt)
> -		opt = ipv6_dup_options(newsk, opt);
> -	RCU_INIT_POINTER(newnp->opt, opt);
> -	rcu_read_unlock();
> +	sctp_v6_copy_ip_options(sk, newsk);
>  
>  	/* Initialize sk's sport, dport, rcv_saddr and daddr for getsockname()
>  	 * and getpeername().
> @@ -1041,6 +1070,7 @@ static struct sctp_af sctp_af_inet6 = {
>  	.ecn_capable	   = sctp_v6_ecn_capable,
>  	.net_header_len	   = sizeof(struct ipv6hdr),
>  	.sockaddr_len	   = sizeof(struct sockaddr_in6),
> +	.ip_options_len	   = sctp_v6_ip_options_len,
>  #ifdef CONFIG_COMPAT
>  	.compat_setsockopt = compat_ipv6_setsockopt,
>  	.compat_getsockopt = compat_ipv6_getsockopt,
> @@ -1059,6 +1089,7 @@ static struct sctp_pf sctp_pf_inet6 = {
>  	.addr_to_user  = sctp_v6_addr_to_user,
>  	.to_sk_saddr   = sctp_v6_to_sk_saddr,
>  	.to_sk_daddr   = sctp_v6_to_sk_daddr,
> +	.copy_ip_options = sctp_v6_copy_ip_options,
>  	.af            = &sctp_af_inet6,
>  };
>  
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 01a26ee..a58d13c 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -69,7 +69,11 @@ static enum sctp_xmit sctp_packet_will_fit(struct sctp_packet *packet,
>  
>  static void sctp_packet_reset(struct sctp_packet *packet)
>  {
> +	/* sctp_packet_transmit() relies on this to reset size to the
> +	 * current overhead after sending packets.
> +	 */
>  	packet->size = packet->overhead;
> +
>  	packet->has_cookie_echo = 0;
>  	packet->has_sack = 0;
>  	packet->has_data = 0;
> @@ -87,6 +91,7 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
>  	struct sctp_transport *tp = packet->transport;
>  	struct sctp_association *asoc = tp->asoc;
>  	struct sock *sk;
> +	size_t overhead = sizeof(struct ipv6hdr) + sizeof(struct sctphdr);
>  
>  	pr_debug("%s: packet:%p vtag:0x%x\n", __func__, packet, vtag);
>  	packet->vtag = vtag;
> @@ -95,10 +100,22 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
>  	if (!sctp_packet_empty(packet))
>  		return;
>  
> -	/* set packet max_size with pathmtu */
> +	/* set packet max_size with pathmtu, then calculate overhead */
>  	packet->max_size = tp->pathmtu;
> -	if (!asoc)
> +	if (asoc) {
> +		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
> +		struct sctp_af *af = sp->pf->af;
> +
> +		overhead = af->net_header_len +
> +			   af->ip_options_len(asoc->base.sk);
> +		overhead += sizeof(struct sctphdr);
> +		packet->overhead = overhead;
> +		packet->size = overhead;
> +	} else {
> +		packet->overhead = overhead;
> +		packet->size = overhead;
>  		return;
> +	}
>  
>  	/* update dst or transport pathmtu if in need */
>  	sk = asoc->base.sk;
> @@ -140,23 +157,14 @@ void sctp_packet_init(struct sctp_packet *packet,
>  		      struct sctp_transport *transport,
>  		      __u16 sport, __u16 dport)
>  {
> -	struct sctp_association *asoc = transport->asoc;
> -	size_t overhead;
> -
>  	pr_debug("%s: packet:%p transport:%p\n", __func__, packet, transport);
>  
>  	packet->transport = transport;
>  	packet->source_port = sport;
>  	packet->destination_port = dport;
>  	INIT_LIST_HEAD(&packet->chunk_list);
> -	if (asoc) {
> -		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
> -		overhead = sp->pf->af->net_header_len;
> -	} else {
> -		overhead = sizeof(struct ipv6hdr);
> -	}
> -	overhead += sizeof(struct sctphdr);
> -	packet->overhead = overhead;
> +	/* The overhead will be calculated by sctp_packet_config() */
> +	packet->overhead = 0;
>  	sctp_packet_reset(packet);
>  	packet->vtag = 0;
>  }
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 91813e6..01c4d77 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -237,6 +237,40 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
>  	return error;
>  }
>  
> +/* Copy over any ip options */
> +static void sctp_v4_copy_ip_options(struct sock *sk, struct sock *newsk)
> +{
> +	struct inet_sock *newinet, *inet = inet_sk(sk);
> +	struct ip_options_rcu *inet_opt, *newopt = NULL;
> +
> +	newinet = inet_sk(newsk);
> +
> +	rcu_read_lock();
> +	inet_opt = rcu_dereference(inet->inet_opt);
> +	if (inet_opt) {
> +		newopt = sock_kmalloc(newsk, sizeof(*inet_opt) +
> +				      inet_opt->opt.optlen, GFP_ATOMIC);
> +		if (newopt)
> +			memcpy(newopt, inet_opt, sizeof(*inet_opt) +
> +			       inet_opt->opt.optlen);
> +		else
> +			pr_err("%s: Failed to copy ip options\n", __func__);
> +	}
> +	RCU_INIT_POINTER(newinet->inet_opt, newopt);
> +	rcu_read_unlock();
> +}
> +
> +/* Account for the IP options */
> +static int sctp_v4_ip_options_len(struct sock *sk)
> +{
> +	struct inet_sock *inet = inet_sk(sk);
> +
> +	if (inet->inet_opt)
> +		return inet->inet_opt->opt.optlen;
> +	else
> +		return 0;
> +}
> +
>  /* Initialize a sctp_addr from in incoming skb.  */
>  static void sctp_v4_from_skb(union sctp_addr *addr, struct sk_buff *skb,
>  			     int is_saddr)
> @@ -588,6 +622,8 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
>  	sctp_copy_sock(newsk, sk, asoc);
>  	sock_reset_flag(newsk, SOCK_ZAPPED);
>  
> +	sctp_v4_copy_ip_options(sk, newsk);
> +
>  	newinet = inet_sk(newsk);
>  
>  	newinet->inet_daddr = asoc->peer.primary_addr.v4.sin_addr.s_addr;
> @@ -1006,6 +1042,7 @@ static struct sctp_pf sctp_pf_inet = {
>  	.addr_to_user  = sctp_v4_addr_to_user,
>  	.to_sk_saddr   = sctp_v4_to_sk_saddr,
>  	.to_sk_daddr   = sctp_v4_to_sk_daddr,
> +	.copy_ip_options = sctp_v4_copy_ip_options,
>  	.af            = &sctp_af_inet
>  };
>  
> @@ -1090,6 +1127,7 @@ static struct sctp_af sctp_af_inet = {
>  	.ecn_capable	   = sctp_v4_ecn_capable,
>  	.net_header_len	   = sizeof(struct iphdr),
>  	.sockaddr_len	   = sizeof(struct sockaddr_in),
> +	.ip_options_len	   = sctp_v4_ip_options_len,
>  #ifdef CONFIG_COMPAT
>  	.compat_setsockopt = compat_ip_setsockopt,
>  	.compat_getsockopt = compat_ip_getsockopt,
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index bf271f8..eb55c63 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3138,6 +3138,7 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
>  static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
> +	struct sctp_af *af = sp->pf->af;
>  	struct sctp_assoc_value params;
>  	struct sctp_association *asoc;
>  	int val;
> @@ -3162,7 +3163,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
>  	if (val) {
>  		int min_len, max_len;
>  
> -		min_len = SCTP_DEFAULT_MINSEGMENT - sp->pf->af->net_header_len;
> +		min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
> +		min_len -= af->ip_options_len(sk);
>  		min_len -= sizeof(struct sctphdr) +
>  			   sizeof(struct sctp_data_chunk);
>  
> @@ -3175,7 +3177,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
>  	asoc = sctp_id2assoc(sk, params.assoc_id);
>  	if (asoc) {
>  		if (val = 0) {
> -			val = asoc->pathmtu - sp->pf->af->net_header_len;
> +			val = asoc->pathmtu - af->net_header_len;
> +			val -= af->ip_options_len(sk);
>  			val -= sizeof(struct sctphdr) +
>  			       sctp_datachk_len(&asoc->stream);
>  		}
> @@ -5087,9 +5090,11 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
>  	sctp_copy_sock(sock->sk, sk, asoc);
>  
>  	/* Make peeled-off sockets more like 1-1 accepted sockets.
> -	 * Set the daddr and initialize id to something more random
> +	 * Set the daddr and initialize id to something more random and also
> +	 * copy over any ip options.
>  	 */
>  	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
> +	sp->pf->copy_ip_options(sk, sock->sk);
>  
>  	/* Populate the fields of the newsk from the oldsk and migrate the
>  	 * asoc to the newsk.
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
