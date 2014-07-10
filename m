From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Thu, 10 Jul 2014 19:58:56 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140710195856.GB13031@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 10, 2014 at 07:33:22AM -0400, Neil Horman wrote:
> On Wed, Jul 09, 2014 at 12:51:09PM -0600, Jason Gunthorpe wrote:
> > On Wed, Jul 09, 2014 at 02:27:02PM -0400, Neil Horman wrote:
> > 
> > > > Hum, this looks funny without a family assigment, how does the the
> > > > next thing to look at sk know if is a AF_INET vs AF_INET6?
> > > > 
> > > Neither clause has a family assignment.  Hmm, I wonder if they need one.
> > 
> > I don't know off hand, I think it depends what happens to 'sk' later
> > 
> Ah, its filled out in the protocols from_sk method, and ipv6 doesn't curently
> have one, so we don't need to worry about it (yet).

Hurm. 

No, it is just more deeply broken then that..

getpeername() and getsockname() just don't work properly at all with
V6, it returns garbage with a v4 address becomes involved.

For an AF_INET6 socket the local and peer address should always be
stored in the inet6_sk as a mapped address, the inet_sk stuff
shouldn't really be used..

I fixed this in the revised patch by making to_sk_daddr/saddr part of
the pf and removing all sensitivity on the address af. The conversion
now uniformly stores any value as AF_INET6.

Instead I get the v4mapped behavior at the new getname entry point,
which fixes all the problems I could see here.

> Ah, sorry, didn't understand what you were getting at.  You will
> enter the above path if you have an ipv6 socket created and try to
> bind it to a local ipv4 address.  Test that with and without
> v4mapped set, and you should get complete coverage of that
> conditional.

No, I am already testing that.. 

Hurm, there is more that needs fixing..

Testing binding to ::ffff:127.0.0.1 and ::1 (ie both are passed into
the kernel as AF_INET6) causes a behavior difference based on
v4mapped, when 0 we get 'sctp_bindx - 99: Cannot assign requested
address'

1) Bind should not be sensitive to v4mapped or not, so lets drop this
   test:

@@ -880,9 +872,6 @@ static int sctp_inet6_bind_verify(struct sctp_sock *opt, union sctp_addr *addr)
                                return 0;
                        }
                        rcu_read_unlock();
-               } else if (type = IPV6_ADDR_MAPPED) {
-                       if (!opt->v4mapped)
-                               return 0;
                }
 

  That fixes the bindx failure, and now we hit coverage in
  sctp_v6_available

2) I added a BUG_ON(addr->v4.sin_family != AF_INET) to
   sctp_v4_available, and now it triggers, as I said, the flow
   changed in the patch. So drop the test for mapped in available, and
   unconditionally map.

@@ -554,12 +564,10 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 
 	type = ipv6_addr_type(in6);
 	if (IPV6_ADDR_ANY = type)
 		return 1;
 	if (type = IPV6_ADDR_MAPPED) {
-		if (sp && !sp->v4mapped)
-			return 0;
 		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
 			return 0;
 		sctp_v6_map_v4(addr);
 		return sctp_get_af_specific(AF_INET)->available(addr, sp);
 	}

  Note, this makes sense because none of these routines are generating
  addresses to be passed back to user space, so none should be looking
  at mapped.
 
The attached patch fixes all my test cases, and having looked it very
carefully now, I'm pretty comfortable with the bulk, what worries me
is other stuff that might be missed...

I'm a little worried about sctp_addr_id2transport, I'm not sure it
should be calling addr_v4map, that probably should be an unconditional
promotion?

I also wonder if sctp_v6_addr_v4map should demote mapped v6 back into
v4? I suspect yes it should.

From d3cc46c03975688ef144e8ef68ae55a9a391e7ca Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Thu, 10 Jul 2014 13:49:03 -0600
Subject: [PATCH] sctp: Fixup v4mapped behaviour to comply with Sock API

The SCTP socket extensions API document describes the v4mapping option as
follows:

8.1.15.  Set/Clear IPv4 Mapped Addresses (SCTP_I_WANT_MAPPED_V4_ADDR)

   This socket option is a Boolean flag which turns on or off the
   mapping of IPv4 addresses.  If this option is turned on, then IPv4
   addresses will be mapped to V6 representation.  If this option is
   turned off, then no mapping will be done of V4 addresses and a user
   will receive both PF_INET6 and PF_INET type addresses on the socket.
   See [RFC3542] for more details on mapped V6 addresses.

This description isn't really in line with what the code does though.

Change the handling so that v6 sockets mostly keeps track of things
internally as mapped v4 addresses and then convert them to AF_INET
at the syscall boundary.

Tested bind, getpeername, getsockname, connect, and recvmsg for proper
behaviour in v4mapped = 1 and 0 cases.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 include/net/sctp/structs.h |  8 ++---
 net/sctp/ipv6.c            | 76 ++++++++++++++++++++++++++++++++--------------
 net/sctp/protocol.c        |  4 +--
 net/sctp/socket.c          | 13 ++++----
 net/sctp/transport.c       |  4 +--
 5 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f38588bf3462..a5704e597c9a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -461,10 +461,6 @@ struct sctp_af {
 					 int saddr);
 	void		(*from_sk)	(union sctp_addr *,
 					 struct sock *sk);
-	void		(*to_sk_saddr)	(union sctp_addr *,
-					 struct sock *sk);
-	void		(*to_sk_daddr)	(union sctp_addr *,
-					 struct sock *sk);
 	void		(*from_addr_param) (union sctp_addr *,
 					    union sctp_addr_param *,
 					    __be16 port, int iif);
@@ -506,6 +502,10 @@ struct sctp_pf {
 	struct sock *(*create_accept_sk) (struct sock *sk,
 					  struct sctp_association *asoc);
 	void (*addr_v4map) (struct sctp_sock *, union sctp_addr *);
+	void		(*to_sk_saddr)	(union sctp_addr *,
+					 struct sock *sk);
+	void		(*to_sk_daddr)	(union sctp_addr *,
+					 struct sock *sk);
 	struct sctp_af *af;
 };
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 1999592ba88c..88c3a263eb57 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -434,7 +434,7 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
 static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 {
-	if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
+	if (addr->sa.sa_family = AF_INET) {
 		sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
 		sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
 		sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
@@ -448,7 +448,7 @@ static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 /* Initialize sk->sk_daddr from sctp_addr. */
 static void sctp_v6_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 {
-	if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
+	if (addr->sa.sa_family = AF_INET) {
 		sk->sk_v6_daddr.s6_addr32[0] = 0;
 		sk->sk_v6_daddr.s6_addr32[1] = 0;
 		sk->sk_v6_daddr.s6_addr32[2] = htonl(0x0000ffff);
@@ -556,8 +556,6 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (IPV6_ADDR_ANY = type)
 		return 1;
 	if (type = IPV6_ADDR_MAPPED) {
-		if (sp && !sp->v4mapped)
-			return 0;
 		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
 			return 0;
 		sctp_v6_map_v4(addr);
@@ -587,8 +585,6 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 		/* Note: This routine is used in input, so v4-mapped-v6
 		 * are disallowed here when there is no sctp_sock.
 		 */
-		if (!sp || !sp->v4mapped)
-			return 0;
 		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
 			return 0;
 		sctp_v6_map_v4(addr);
@@ -723,6 +719,7 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 				     char *msgname, int *addrlen)
 {
 	struct sockaddr_in6 *sin6, *sin6from;
+	struct sockaddr_in *sin;
 
 	if (msgname) {
 		union sctp_addr *addr;
@@ -731,6 +728,7 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 		asoc = event->asoc;
 		sctp_inet6_msgname(msgname, addrlen);
 		sin6 = (struct sockaddr_in6 *)msgname;
+		sin = (struct sockaddr_in *)msgname;
 		sin6->sin6_port = htons(asoc->peer.port);
 		addr = &asoc->peer.primary_addr;
 
@@ -739,12 +737,17 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 		 */
 
 		/* Map ipv4 address into v4-mapped-on-v6 address.  */
-		if (sctp_sk(asoc->base.sk)->v4mapped &&
-		    AF_INET = addr->sa.sa_family) {
-			sctp_v4_map_v6((union sctp_addr *)sin6);
-			sin6->sin6_addr.s6_addr32[3] -				addr->v4.sin_addr.s_addr;
-			return;
+		if (addr->sa.sa_family = AF_INET) {
+			if (sctp_sk(asoc->base.sk)->v4mapped) {
+				sctp_v4_map_v6((union sctp_addr *)sin6);
+				sin6->sin6_addr.s6_addr32[3] +					addr->v4.sin_addr.s_addr;
+				return;
+			} else {
+				sin->sin_addr.s_addr = addr->v4.sin_addr.s_addr;
+				sin->sin_family = AF_INET;
+				sin->sin_port = htons(asoc->peer.port);
+			}
 		}
 
 		sin6from = &asoc->peer.primary_addr.v6;
@@ -760,22 +763,32 @@ static void sctp_inet6_skb_msgname(struct sk_buff *skb, char *msgname,
 {
 	struct sctphdr *sh;
 	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
 
 	if (msgname) {
 		sctp_inet6_msgname(msgname, addr_len);
 		sin6 = (struct sockaddr_in6 *)msgname;
+		sin = (struct sockaddr_in *)msgname;
+
 		sh = sctp_hdr(skb);
-		sin6->sin6_port = sh->source;
 
 		/* Map ipv4 address into v4-mapped-on-v6 address. */
-		if (sctp_sk(skb->sk)->v4mapped &&
-		    ip_hdr(skb)->version = 4) {
-			sctp_v4_map_v6((union sctp_addr *)sin6);
-			sin6->sin6_addr.s6_addr32[3] = ip_hdr(skb)->saddr;
+		if (ip_hdr(skb)->version = 4) {
+			if (sctp_sk(skb->sk)->v4mapped) {
+				sin6->sin6_port = sh->source;
+				sctp_v4_map_v6((union sctp_addr *)sin6);
+				sin6->sin6_addr.s6_addr32[3] +				    ip_hdr(skb)->saddr;
+			} else {
+				sin->sin_addr.s_addr =  ip_hdr(skb)->saddr;
+				sin->sin_family = AF_INET;
+				sin->sin_port = sh->source;
+			}
 			return;
 		}
 
 		/* Otherwise, just copy the v6 address. */
+		sin6->sin6_port = sh->source;
 		sin6->sin6_addr = ipv6_hdr(skb)->saddr;
 		if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
 			struct sctp_ulpevent *ev = sctp_skb2event(skb);
@@ -857,9 +870,6 @@ static int sctp_inet6_bind_verify(struct sctp_sock *opt, union sctp_addr *addr)
 				return 0;
 			}
 			rcu_read_unlock();
-		} else if (type = IPV6_ADDR_MAPPED) {
-			if (!opt->v4mapped)
-				return 0;
 		}
 
 		af = opt->pf->af;
@@ -914,6 +924,26 @@ static int sctp_inet6_supported_addrs(const struct sctp_sock *opt,
 	return 1;
 }
 
+/* Handle SCTP_I_WANT_MAPPED_V4_ADDR for getpeername and getsockname() */
+static int sctp_getname(struct socket *sock, struct sockaddr *uaddr,
+			int *uaddr_len, int peer)
+{
+	struct sockaddr_in6 *sin = (struct sockaddr_in6 *)uaddr;
+	struct sctp_sock *sp = sctp_sk(sock->sk);
+	int rc;
+
+	rc = inet6_getname(sock, uaddr, uaddr_len, peer);
+	if (rc != 0)
+		return rc;
+
+	if (!sp->v4mapped && ipv6_addr_v4mapped(&sin->sin6_addr)) {
+		sctp_v6_map_v4((union sctp_addr *)uaddr);
+		*uaddr_len = sizeof(struct sockaddr_in);
+	}
+
+	return rc;
+}
+
 static const struct proto_ops inet6_seqpacket_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
@@ -922,7 +952,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.connect	   = inet_dgram_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
-	.getname	   = inet6_getname,
+	.getname	   = sctp_getname,
 	.poll		   = sctp_poll,
 	.ioctl		   = inet6_ioctl,
 	.listen		   = sctp_inet_listen,
@@ -974,8 +1004,6 @@ static struct sctp_af sctp_af_inet6 = {
 	.copy_addrlist	   = sctp_v6_copy_addrlist,
 	.from_skb	   = sctp_v6_from_skb,
 	.from_sk	   = sctp_v6_from_sk,
-	.to_sk_saddr	   = sctp_v6_to_sk_saddr,
-	.to_sk_daddr	   = sctp_v6_to_sk_daddr,
 	.from_addr_param   = sctp_v6_from_addr_param,
 	.to_addr_param	   = sctp_v6_to_addr_param,
 	.cmp_addr	   = sctp_v6_cmp_addr,
@@ -1006,6 +1034,8 @@ static struct sctp_pf sctp_pf_inet6 = {
 	.supported_addrs = sctp_inet6_supported_addrs,
 	.create_accept_sk = sctp_v6_create_accept_sk,
 	.addr_v4map    = sctp_v6_addr_v4map,
+	.to_sk_saddr	   = sctp_v6_to_sk_saddr,
+	.to_sk_daddr	   = sctp_v6_to_sk_daddr,
 	.af            = &sctp_af_inet6,
 };
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6789d785e698..db48bf739f5f 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -977,6 +977,8 @@ static struct sctp_pf sctp_pf_inet = {
 	.supported_addrs = sctp_inet_supported_addrs,
 	.create_accept_sk = sctp_v4_create_accept_sk,
 	.addr_v4map	= sctp_v4_addr_v4map,
+	.to_sk_saddr	   = sctp_v4_to_sk_saddr,
+	.to_sk_daddr	   = sctp_v4_to_sk_daddr,
 	.af            = &sctp_af_inet
 };
 
@@ -1047,8 +1049,6 @@ static struct sctp_af sctp_af_inet = {
 	.copy_addrlist	   = sctp_v4_copy_addrlist,
 	.from_skb	   = sctp_v4_from_skb,
 	.from_sk	   = sctp_v4_from_sk,
-	.to_sk_saddr	   = sctp_v4_to_sk_saddr,
-	.to_sk_daddr	   = sctp_v4_to_sk_daddr,
 	.from_addr_param   = sctp_v4_from_addr_param,
 	.to_addr_param	   = sctp_v4_to_addr_param,
 	.cmp_addr	   = sctp_v4_cmp_addr,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 429899689408..fc5ec3e698a6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -396,7 +396,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	/* Copy back into socket for getsockname() use. */
 	if (!ret) {
 		inet_sk(sk)->inet_sport = htons(inet_sk(sk)->inet_num);
-		af->to_sk_saddr(addr, sk);
+		sp->pf->to_sk_saddr(addr, sk);
 	}
 
 	return ret;
@@ -1053,7 +1053,6 @@ static int __sctp_connect(struct sock *sk,
 	struct sctp_association *asoc2;
 	struct sctp_transport *transport;
 	union sctp_addr to;
-	struct sctp_af *af;
 	sctp_scope_t scope;
 	long timeo;
 	int err = 0;
@@ -1081,6 +1080,8 @@ static int __sctp_connect(struct sock *sk,
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+		struct sctp_af *af;
+
 		if (walk_size + sizeof(sa_family_t) > addrs_size) {
 			err = -EINVAL;
 			goto out_free;
@@ -1205,8 +1206,7 @@ static int __sctp_connect(struct sock *sk,
 
 	/* Initialize sk's dport and daddr for getpeername() */
 	inet_sk(sk)->inet_dport = htons(asoc->peer.port);
-	af = sctp_get_af_specific(sa_addr->sa.sa_family);
-	af->to_sk_daddr(sa_addr, sk);
+	sp->pf->to_sk_daddr(sa_addr, sk);
 	sk->sk_err = 0;
 
 	/* in-kernel sockets don't generally have a file allocated to them
@@ -4301,8 +4301,8 @@ static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optv
 int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 {
 	struct sctp_association *asoc = sctp_id2assoc(sk, id);
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct socket *sock;
-	struct sctp_af *af;
 	int err = 0;
 
 	if (!asoc)
@@ -4324,8 +4324,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	/* Make peeled-off sockets more like 1-1 accepted sockets.
 	 * Set the daddr and initialize id to something more random
 	 */
-	af = sctp_get_af_specific(asoc->peer.primary_addr.sa.sa_family);
-	af->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 7dd672fa651f..cf6c267a119c 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -289,8 +289,8 @@ void sctp_transport_route(struct sctp_transport *transport,
 		 */
 		if (asoc && (!asoc->peer.primary_path ||
 				(transport = asoc->peer.active_path)))
-			opt->pf->af->to_sk_saddr(&transport->saddr,
-						 asoc->base.sk);
+			opt->pf->to_sk_saddr(&transport->saddr,
+					     asoc->base.sk);
 	} else
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
 }
-- 
1.9.1

