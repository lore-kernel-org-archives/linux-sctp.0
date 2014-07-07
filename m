From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Mon, 07 Jul 2014 04:48:33 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140707044833.GA14115@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sun, Jul 06, 2014 at 08:21:33AM -0400, Neil Horman wrote:

> > /* Initialize sk->sk_rcv_saddr from sctp_addr. */
> > static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
> > {
> >         if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
> >                 inet6_sk(sk)->rcv_saddr.s6_addr32[0] = 0;
> >                 inet6_sk(sk)->rcv_saddr.s6_addr32[1] = 0;
> >                 inet6_sk(sk)->rcv_saddr.s6_addr32[2] > > 		htonl(0x0000ffff);
> >                 inet6_sk(sk)->rcv_saddr.s6_addr32[3] > >                         addr->v4.sin_addr.s_addr;
> >         } else {
> >                 inet6_sk(sk)->rcv_saddr = addr->v6.sin6_addr;
> >         }
> > }
> > 
> > There is no if block to handle 'addr->sa.sa_family = AF_INET &&
> > !sctp_sk(sk)->v4mapped'

> Yes, there is, its the else clause there.  This is the ipv6 to_sk_saddr
> function.  If you don't want a v4mapped address, you should assign a real ipv6
> address to the socket.  What seems wierd is that there isn't an extra check to
> ensure that the family is AF_INET6 in the else clause, but I think its done
> higher up the call stack.  Although if its not, that could be a problem

Well, if sctp_v6_to_sk_saddr is called with AF_INET and v4mapped = 0,
the result would match the symptoms I observed.

Note, the sequence I used was
  socket(AF_INET6)
  sctp_bindx(..) (to both IPv4 and IPv6 addresses)
  setsockopt(SCTP_I_WANT_MAPPED_V4_ADDR = 0)
  [peer connects using IPv4]
  recvmsg().. // Get AF_INET6 with '::' as the address

> Hmm, looking at the code, I'm not sure how we reach that point.  You need to set
> you sa_family code to AF_INET6 to get the v6 mapping function to be called, but
> it only does the v4mapping above if the sa_family is AF_INET.  Looks like that
> might need fixing.  I'll look at that on monday.

Well, I looked a bit, and there are certainly cases, eg bind calls
sctp_v6_to_sk_saddr unconditionally.. 

Persumably there are cases with v4/v6 interworking where the netstack
delivers AF_INET addresses and that function gets called?

Regards,
Jason
