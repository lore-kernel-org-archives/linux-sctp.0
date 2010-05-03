From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 03 May 2010 20:33:32 +0000
Subject: [RFC PATCH] sctp: make sctp over IPv6 work with IPsec.
Message-Id: <4BDF331C.4080205@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Wei, Nicolas

Earlier today I sent out an updated patch that proposed a fix for
the ipv6 route lookups.  This is a follow-up based on that work that
should fix the IPSec piece.

-vlad

SCTP never called xfrm_output after its v6 route lookups so
that never really worked with ipsec.  Additioanlly, we never
passed port nubmers in the flowi, so any port based policies were
never applied as well.  Now that we can fixed ipv6 routing lookup
code, we can add xfrm_output calls and pass port numbers.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 include/net/sctp/structs.h |    5 ++-
 net/sctp/ipv6.c            |   46 +++++++++++++++++++++++++++++++++++--------
 net/sctp/protocol.c        |    3 +-
 net/sctp/socket.c          |    2 +-
 net/sctp/transport.c       |    8 ++++--
 5 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9d44aef..16d29f6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -568,7 +568,8 @@ struct sctp_af {
 					 int __user *optlen);
 	struct dst_entry *(*get_dst)	(struct sctp_association *asoc,
 					 union sctp_addr *daddr,
-					 union sctp_addr *saddr);
+					 union sctp_addr *saddr,
+					 struct sock *sk);
 	void		(*get_saddr)	(struct sctp_sock *sk,
 					 struct sctp_association *asoc,
 					 struct dst_entry *dst,
@@ -1059,7 +1060,7 @@ void sctp_transport_set_owner(struct sctp_transport *,
 			      struct sctp_association *);
 void sctp_transport_route(struct sctp_transport *, union sctp_addr *,
 			  struct sctp_sock *);
-void sctp_transport_pmtu(struct sctp_transport *);
+void sctp_transport_pmtu(struct sctp_transport *, struct sock *sk);
 void sctp_transport_free(struct sctp_transport *);
 void sctp_transport_reset_timers(struct sctp_transport *);
 void sctp_transport_hold(struct sctp_transport *);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index f75e2f8..9fc1411 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -239,12 +239,37 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct
sctp_transport *transport)
 	return ip6_xmit(sk, skb, &fl, np->opt);
 }

+/* Small helper function that combines route and XFRM lookups.  This is
+ * done since we might be looping through route lookups.
+ */
+static int sctp_v6_dst_lookup(struct sock *sk, struct dst_entry **dst,
+				struct flowi *fl)
+{
+	int err;
+
+	err = ip6_dst_lookup(sk, dst, fl);
+	if (err)
+		goto done;
+
+	err = xfrm_lookup(sock_net(sk), dst, fl, sk, 0);
+	if (err)
+		goto done;
+
+	return 0;
+
+done:
+	dst_release(*dst);
+	*dst = NULL;
+	return err;
+}
+
 /* Returns the dst cache entry for the given source and destination ip
  * addresses.
  */
 static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
 					 union sctp_addr *daddr,
-					 union sctp_addr *saddr)
+					 union sctp_addr *saddr,
+					 struct sock *sk)
 {
 	struct dst_entry *dst = NULL;
 	struct flowi fl;
@@ -255,23 +280,30 @@ static struct dst_entry *sctp_v6_get_dst(struct
sctp_association *asoc,

 	memset(&fl, 0, sizeof(fl));
 	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
+	fl.fl_ip_dport = daddr->v6.sin6_port;
 	if (ipv6_addr_type(&daddr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
 		fl.oif = daddr->v6.sin6_scope_id;


 	SCTP_DEBUG_PRINTK("%s: DST=%pI6 ", __func__, &fl.fl6_dst);

+	if (asoc)
+		fl.fl_ip_sport = htons(asoc->base.bind_addr.port);
+
 	if (saddr) {
 		ipv6_addr_copy(&fl.fl6_src, &saddr->v6.sin6_addr);
+		fl.fl_ip_sport = saddr->v6.sin6_port;
 		SCTP_DEBUG_PRINTK("SRC=%pI6 - ", &fl.fl6_src);
 	}

-	dst = ip6_route_output(&init_net, NULL, &fl);
-
 	bp = &asoc->base.bind_addr;
 	scope = sctp_scope(daddr);

-	if (!dst->error) {
+	if (!sctp_v6_dst_lookup(sk, &dst, &fl)) {
+		/* If we do not have an association (meaning we can't check
+		 * bound address list), or if the source was specified,
+		 * we are done.
+		 */
 		if (!asoc || saddr)
 			goto out;

@@ -309,11 +341,7 @@ static struct dst_entry *sctp_v6_get_dst(struct
sctp_association *asoc,
 		if ((laddr->a.sa.sa_family = AF_INET6) &&
 		    (scope <= sctp_scope(&laddr->a))) {
 			ipv6_addr_copy(&fl.fl6_src, &laddr->a.v6.sin6_addr);
-			dst = ip6_route_output(&init_net, NULL, &fl);
-			if (dst->error) {
-				dst_release(dst);
-				dst = NULL;
-			} else
+			if (!sctp_v6_dst_lookup(sk, &dst, &fl))
 				break;
 		}
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 1827498..1c25e7d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -463,7 +463,8 @@ static sctp_scope_t sctp_v4_scope(union sctp_addr *addr)
  */
 static struct dst_entry *sctp_v4_get_dst(struct sctp_association *asoc,
 					 union sctp_addr *daddr,
-					 union sctp_addr *saddr)
+					 union sctp_addr *saddr,
+					 struct sock *sk)
 {
 	struct rtable *rt;
 	struct flowi fl;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1282a0e..e3c7a60 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2270,7 +2270,7 @@ static int sctp_apply_peer_addr_params(struct
sctp_paddrparams *params,
 			trans->param_flags  				(trans->param_flags & ~SPP_PMTUD) | pmtud_change;
 			if (update) {
-				sctp_transport_pmtu(trans);
+				sctp_transport_pmtu(trans, sctp_opt2sk(sp));
 				sctp_assoc_sync_pmtu(asoc);
 			}
 		} else if (asoc) {
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index fccf494..a9d165c 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -203,11 +203,13 @@ void sctp_transport_set_owner(struct sctp_transport
*transport,
 }

 /* Initialize the pmtu of a transport. */
-void sctp_transport_pmtu(struct sctp_transport *transport)
+void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 {
 	struct dst_entry *dst;

-	dst = transport->af_specific->get_dst(NULL, &transport->ipaddr, NULL);
+	dst = transport->af_specific->get_dst(transport->asoc,
+					&transport->ipaddr,
+					&transport->saddr, sk);

 	if (dst) {
 		transport->pathmtu = dst_mtu(dst);
@@ -266,7 +268,7 @@ void sctp_transport_route(struct sctp_transport *transport,
 	union sctp_addr *daddr = &transport->ipaddr;
 	struct dst_entry *dst;

-	dst = af->get_dst(asoc, daddr, saddr);
+	dst = af->get_dst(asoc, daddr, saddr, sctp_opt2sk(opt));

 	if (saddr)
 		memcpy(&transport->saddr, saddr, sizeof(union sctp_addr));
-- 
1.6.0.4

