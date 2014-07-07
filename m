From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Mon, 07 Jul 2014 17:45:31 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140707174531.GA6753@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 07, 2014 at 08:44:44AM -0400, Neil Horman wrote:

> > Well, if sctp_v6_to_sk_saddr is called with AF_INET and v4mapped = 0,
> > the result would match the symptoms I observed.
> > 
> > Note, the sequence I used was
> >   socket(AF_INET6)
> >   sctp_bindx(..) (to both IPv4 and IPv6 addresses)
> >   setsockopt(SCTP_I_WANT_MAPPED_V4_ADDR = 0)
> >   [peer connects using IPv4]
> >   recvmsg().. // Get AF_INET6 with '::' as the address

> Oh, I may see the problem.  Or at least the disconnect between the documentation
> and the code.  The docs for the sctp socket api says:
>
> 8.1.15.  Set/Clear IPv4 Mapped Addresses (SCTP_I_WANT_MAPPED_V4_ADDR)
> 
>    This socket option is a boolean flag which turns on or off the
>    mapping of IPv4 addresses.  If this option is turned on, then IPv4
>    addresses will be mapped to V6 representation.  If this option is
>    turned off, then no mapping will be done of V4 addresses and a user
>    will receive both PF_INET6 and PF_INET type addresses on the socket.
>    See [RFC3542] for more details on mapped V6 addresses.
> 
> But the code, when MAPPED_V4_ADDR is turned off treats everything as an ipv6
> address, which doesn't really jive with whats described above.  If
> MAPPED_V4_ADDR is turned off, we should I think be filling out a sockaddr_in
> structure if the received frame type header is version 4.  Can you try the patch
> attached below to see if it fixes the issue?

Right, I noticed every use of v4mapped seemed strange to me, like
why should v4mapped cause sctp_v6_available and sctp_v6_addr_valid to
behave any different? (And curiously, after I added tracing I didn't
hit those cases, so I'm not sure what they are for)

So your patch is the right idea, but we need to fix every case, I
added code for sctp_inet6_event_msgname too and now my little test
works OK:

After recvmsg: sockaddr is 2 -- 127.0.0.1
Connection attempt failed 0
After recvmsg: sockaddr is 2 -- 127.0.0.1
Peer connection is UP
After recvmsg: sockaddr is 2 -- 127.0.0.1
Peer connection is UP

See attached patch for what I tested.

But, I also added BUG_ON(addr->sa.sa_family != AF_INET6); to the else
in the sk_s/daddr functions, and it triggers:

[<c024dd18>] (sctp_v6_to_sk_saddr+0x0/0x64) from [<c0237cdc>] (sctp_transport_route+0xd0/0xe4)
[<c0237c0c>] (sctp_transport_route+0x0/0xe4) from [<c0236938>] (sctp_assoc_add_peer+0xc0/0x264)
[<c0236878>] (sctp_assoc_add_peer+0x0/0x264) from [<c0242558>] (__sctp_connect+0x1dc/0x464)
[<c024237c>] (__sctp_connect+0x0/0x464) from [<c02428d0>] (sctp_connect+0x4c/0x68)
[<c0242884>] (sctp_connect+0x0/0x68) from [<c01d6fc4>] (inet_dgram_connect+0x78/0x8c)
 r6:c7be3400 r5:c6f8ff00 r4:00000010 r3:c0242884
[<c01d6f4c>] (inet_dgram_connect+0x0/0x8c) from [<c01731bc>] (SyS_connect+0x70/0x94)
 r6:b6374d64 r5:00000010 r4:c742eb40 r3:00000802
[<c017314c>] (SyS_connect+0x0/0x94) from [<c0009060>] (ret_fast_syscall+0x0/0x2c)

Which looks like it is because userspace is calling connect(AF_INET)..

So there is still more wrong here..

Jason

From 0862335e5b6e338339e0000267dc8568ee2aae6b Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Mon, 7 Jul 2014 11:09:16 -0600
Subject: [PATCH] net: sctp: Fix SCTP_I_WANT_MAPPED_V4_ADDR

If this option was set to 0 then the kernel would return a bogus
sockaddr from recv for v4 associations instead of the AF_INET sockaddr
it should return.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 net/sctp/ipv6.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 7567e6f1a920..bf18661cfaeb 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -736,12 +736,19 @@ static void sctp_inet6_event_msgname(struct sctp_ulpevent *event,
 		 * will change.
 		 */
 
-		/* Map ipv4 address into v4-mapped-on-v6 address.  */
-		if (sctp_sk(asoc->base.sk)->v4mapped &&
-		    AF_INET = addr->sa.sa_family) {
-			sctp_v4_map_v6((union sctp_addr *)sin6);
-			sin6->sin6_addr.s6_addr32[3] -				addr->v4.sin_addr.s_addr;
+		/* Map ipv4 address into v4-mapped-on-v6 address. */
+		if (addr->sa.sa_family = AF_INET) {
+			if (sctp_sk(asoc->base.sk)->v4mapped) {
+				sctp_v4_map_v6((union sctp_addr *)sin6);
+				sin6->sin6_addr.s6_addr32[3] +				    addr->v4.sin_addr.s_addr;
+			} else {
+				struct sockaddr_in *sin +				    (struct sockaddr_in *)msgname;
+				sin->sin_addr.s_addr = addr->v4.sin_addr.s_addr;
+				sin->sin_family = AF_INET;
+				sin->sin_port = htons(asoc->peer.port);
+			}
 			return;
 		}
 
@@ -758,22 +765,32 @@ static void sctp_inet6_skb_msgname(struct sk_buff *skb, char *msgname,
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
+				sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
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
-- 
1.9.1

