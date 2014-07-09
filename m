From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 09 Jul 2014 15:50:15 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140709155015.GE5250@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 07, 2014 at 01:39:41PM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 07, 2014 at 02:22:36PM -0400, Neil Horman wrote:
> 
> > I'll try get to expanding this patch in the next few days
> 
> Sure, I should be able to test your expansion on the patch I sent, let
> me know.
> 
> Regards,
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Sorry for the delay, busy few days.  I think this fixes up all the required call
sites that check v4mapped.  I've not tested it yet, but it builds.  If you could
please give it a spin and let me know, I'll officially propose it.

Thanks!
Neil


commit 469f5a1527ffcdd08fdcb1c45c80b840f9a7819c
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Wed Jul 9 11:36:33 2014 -0400

    sctp: Fixup v4mapped behavior to comply with Sock API
    
    The SCTP socket extensions API document describes the v4mapping option as
    follows:
    
    8.1.15.  Set/Clear IPv4 Mapped Addresses (SCTP_I_WANT_MAPPED_V4_ADDR)
    
       This socket option is a boolean flag which turns on or off the
       mapping of IPv4 addresses.  If this option is turned on, then IPv4
       addresses will be mapped to V6 representation.  If this option is
       turned off, then no mapping will be done of V4 addresses and a user
       will receive both PF_INET6 and PF_INET type addresses on the socket.
       See [RFC3542] for more details on mapped V6 addresses.
    
    This description isn't really in line with what the code does though.  If we
    have an AF_INET6 socket, that recieves a ipv4 frame and MAPPED_V4_ADDR isn't
    set, it either ignores the frame, or drops the address into an ipv6 sockaddr_in6
    structure in the wrong place (with the wrong sa_family field set).  We need to
    construct proper sockaddr_in structures when handling AF_INET packets on
    AF_INET6 sockets when MAPPED_V4_ADDR is set to 0.
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 1999592..5261ac5 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -434,12 +434,17 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
 static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 {
-	if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
-		sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
-		sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
-		sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
-		sk->sk_v6_rcv_saddr.s6_addr32[3] +	if (addr->sa.sa_family = AF_INET) {
+		if (sctp_sk(sk)->v4mapped) {
+			sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
+			sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
+			sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
+			sk->sk_v6_rcv_saddr.s6_addr32[3]  			addr->v4.sin_addr.s_addr;
+		} else {
+			inet_sk(sk)->inet_rcv_saddr +			addr->v4.sin_addr.s_addr;
+		}
 	} else {
 		sk->sk_v6_rcv_saddr = addr->v6.sin6_addr;
 	}
@@ -448,11 +453,16 @@ static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 /* Initialize sk->sk_daddr from sctp_addr. */
 static void sctp_v6_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 {
-	if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
-		sk->sk_v6_daddr.s6_addr32[0] = 0;
-		sk->sk_v6_daddr.s6_addr32[1] = 0;
-		sk->sk_v6_daddr.s6_addr32[2] = htonl(0x0000ffff);
-		sk->sk_v6_daddr.s6_addr32[3] = addr->v4.sin_addr.s_addr;
+	if (addr->sa.sa_family = AF_INET) {
+		if (sctp_sk(sk)->v4mapped) {
+			sk->sk_v6_daddr.s6_addr32[0] = 0;
+			sk->sk_v6_daddr.s6_addr32[1] = 0;
+			sk->sk_v6_daddr.s6_addr32[2] = htonl(0x0000ffff);
+			sk->sk_v6_daddr.s6_addr32[3] = addr->v4.sin_addr.s_addr;
+		} else {
+			inet_sk(sk)->inet_daddr = addr->v4.sin_addr.s_addr;
+		}
+
 	} else {
 		sk->sk_v6_daddr = addr->v6.sin6_addr;
 	}
@@ -556,11 +566,10 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (IPV6_ADDR_ANY = type)
 		return 1;
 	if (type = IPV6_ADDR_MAPPED) {
-		if (sp && !sp->v4mapped)
-			return 0;
 		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
 			return 0;
-		sctp_v6_map_v4(addr);
+		if (sp && sp->v4mapped)
+			sctp_v6_map_v4(addr);
 		return sctp_get_af_specific(AF_INET)->available(addr, sp);
 	}
 	if (!(type & IPV6_ADDR_UNICAST))
@@ -587,11 +596,10 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 		/* Note: This routine is used in input, so v4-mapped-v6
 		 * are disallowed here when there is no sctp_sock.
 		 */
-		if (!sp || !sp->v4mapped)
-			return 0;
 		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
 			return 0;
-		sctp_v6_map_v4(addr);
+		if (sp && sp->v4mapped)
+			sctp_v6_map_v4(addr);
 		return sctp_get_af_specific(AF_INET)->addr_valid(addr, sp, skb);
 	}
 
@@ -723,6 +731,7 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 				     char *msgname, int *addrlen)
 {
 	struct sockaddr_in6 *sin6, *sin6from;
+	struct sockaddr_in *sin;
 
 	if (msgname) {
 		union sctp_addr *addr;
@@ -731,6 +740,7 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 		asoc = event->asoc;
 		sctp_inet6_msgname(msgname, addrlen);
 		sin6 = (struct sockaddr_in6 *)msgname;
+		sin = (struct sockaddr_in *)msgname;
 		sin6->sin6_port = htons(asoc->peer.port);
 		addr = &asoc->peer.primary_addr;
 
@@ -739,12 +749,16 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
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
+			}
 		}
 
 		sin6from = &asoc->peer.primary_addr.v6;
@@ -760,22 +774,31 @@ static void sctp_inet6_skb_msgname(struct sk_buff *skb, char *msgname,
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
+				sin6->sin6_addr.s6_addr32[3] = ip_hdr(skb)->saddr;
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
