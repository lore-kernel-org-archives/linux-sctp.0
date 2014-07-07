From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 07 Jul 2014 12:44:44 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140707124443.GB30021@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sun, Jul 06, 2014 at 10:48:33PM -0600, Jason Gunthorpe wrote:
> On Sun, Jul 06, 2014 at 08:21:33AM -0400, Neil Horman wrote:
> 
> > > /* Initialize sk->sk_rcv_saddr from sctp_addr. */
> > > static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
> > > {
> > >         if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
> > >                 inet6_sk(sk)->rcv_saddr.s6_addr32[0] = 0;
> > >                 inet6_sk(sk)->rcv_saddr.s6_addr32[1] = 0;
> > >                 inet6_sk(sk)->rcv_saddr.s6_addr32[2] > > > 		htonl(0x0000ffff);
> > >                 inet6_sk(sk)->rcv_saddr.s6_addr32[3] > > >                         addr->v4.sin_addr.s_addr;
> > >         } else {
> > >                 inet6_sk(sk)->rcv_saddr = addr->v6.sin6_addr;
> > >         }
> > > }
> > > 
> > > There is no if block to handle 'addr->sa.sa_family = AF_INET &&
> > > !sctp_sk(sk)->v4mapped'
> 
> > Yes, there is, its the else clause there.  This is the ipv6 to_sk_saddr
> > function.  If you don't want a v4mapped address, you should assign a real ipv6
> > address to the socket.  What seems wierd is that there isn't an extra check to
> > ensure that the family is AF_INET6 in the else clause, but I think its done
> > higher up the call stack.  Although if its not, that could be a problem
> 
> Well, if sctp_v6_to_sk_saddr is called with AF_INET and v4mapped = 0,
> the result would match the symptoms I observed.
> 
> Note, the sequence I used was
>   socket(AF_INET6)
>   sctp_bindx(..) (to both IPv4 and IPv6 addresses)
>   setsockopt(SCTP_I_WANT_MAPPED_V4_ADDR = 0)
>   [peer connects using IPv4]
>   recvmsg().. // Get AF_INET6 with '::' as the address
> 
Oh, I may see the problem.  Or at least the disconnect between the documentation
and the code.  The docs for the sctp socket api says:

8.1.15.  Set/Clear IPv4 Mapped Addresses (SCTP_I_WANT_MAPPED_V4_ADDR)

   This socket option is a boolean flag which turns on or off the
   mapping of IPv4 addresses.  If this option is turned on, then IPv4
   addresses will be mapped to V6 representation.  If this option is
   turned off, then no mapping will be done of V4 addresses and a user
   will receive both PF_INET6 and PF_INET type addresses on the socket.
   See [RFC3542] for more details on mapped V6 addresses.

But the code, when MAPPED_V4_ADDR is turned off treats everything as an ipv6
address, which doesn't really jive with whats described above.  If
MAPPED_V4_ADDR is turned off, we should I think be filling out a sockaddr_in
structure if the received frame type header is version 4.  Can you try the patch
attached below to see if it fixes the issue?


> > Hmm, looking at the code, I'm not sure how we reach that point.  You need to set
> > you sa_family code to AF_INET6 to get the v6 mapping function to be called, but
> > it only does the v4mapping above if the sa_family is AF_INET.  Looks like that
> > might need fixing.  I'll look at that on monday.
> 
> Well, I looked a bit, and there are certainly cases, eg bind calls
> sctp_v6_to_sk_saddr unconditionally.. 
> 
No it doesn't, it calls whatever the get_saddr function is assigned based on the
protocol family that is selected, though I suppose thats just minutae based on
the above findings.

> Persumably there are cases with v4/v6 interworking where the netstack
> delivers AF_INET addresses and that function gets called?
> 
No, that one is for outgoing frames, based on what you told me above about yur
operational sequence, I think we're looking at a problem in
sctp_inet6_skb_msgname here, hence the patch below.


diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 1999592..2e24d8f 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -760,22 +760,31 @@ static void sctp_inet6_skb_msgname(struct sk_buff *skb, char *msgname,
 {
 	struct sctphdr *sh;
 	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
 
 	if (msgname) {
 		sctp_inet6_msgname(msgname, addr_len);
 		sin6 = (struct sockaddr_in6 *)msgname;
+		sin = (struct sockaddr_in *)msgname);
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
+				sin->sin_addr.s_addr ip_hdr(skb)->saddr;
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
