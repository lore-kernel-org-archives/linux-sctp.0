From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Sat, 05 Jul 2014 16:39:09 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140705163909.GB2739@obsidianresearch.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Jul 05, 2014 at 09:03:49AM -0400, Neil Horman wrote:

> >  1) Requesting COOKIE_ACK to be auth'd but not COOKIE_ECHO (or vice
> >     versa) caused an immediate panic in a IRQ context, 'go reboot your
> >     machine' with sctp traceback. I would need to setup in a VM to
> >     capture the oops text..
> 
> Do you have the panic backtrace?

No, the machine crashed in a way that produced no permanent log. I
will have to reproduce it in a VM.
 
> >  2) SCTP_I_WANT_MAPPED_V4_ADDR returns a 0 AF_INET6 for all IPv4
> >     addresses, looking at the code I think the functionality is just
> >     not implemented?
> No, its implemented, not sure why you would get a 0 address here.

Sorry, I see I was unclear, SCTP_I_WANT_MAPPED_V4_ADDR=1 (the
default works fine), it is SCTP_I_WANT_MAPPED_V4_ADDR=0 that doesn't
seem implemented.

Look at functions like this:

/* Initialize sk->sk_rcv_saddr from sctp_addr. */
static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
{
        if (addr->sa.sa_family = AF_INET && sctp_sk(sk)->v4mapped) {
                inet6_sk(sk)->rcv_saddr.s6_addr32[0] = 0;
                inet6_sk(sk)->rcv_saddr.s6_addr32[1] = 0;
                inet6_sk(sk)->rcv_saddr.s6_addr32[2] 		htonl(0x0000ffff);
                inet6_sk(sk)->rcv_saddr.s6_addr32[3]                         addr->v4.sin_addr.s_addr;
        } else {
                inet6_sk(sk)->rcv_saddr = addr->v6.sin6_addr;
        }
}

There is no if block to handle 'addr->sa.sa_family = AF_INET &&
!sctp_sk(sk)->v4mapped'

Instead it falls through to copying memory beyond the end of the
socket address. This has always resulted in a zero AF_INET6 address in
my handful of tests.

Jason
