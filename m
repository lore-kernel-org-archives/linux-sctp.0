From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 24 Jul 2019 12:40:46 +0000
Subject: Re: [PATCH v2 lksctp-tools] testlib: improve test_bind function
Message-Id: <20190724124046.GE6204@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190724103930.13727-1-jijianwen@gmail.com>
In-Reply-To: <20190724103930.13727-1-jijianwen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jul 24, 2019 at 07:38:36AM -0400, Neil Horman wrote:
> On Wed, Jul 24, 2019 at 06:39:30PM +0800, Jianwen Ji wrote:
> > Try to bind again if the errno is EADDRINUSE.
> > Some tests failed to run sometimes, here is one snapshot:
> > 
> >    ...
> > 
> >    test_sockopt.c 25 PASS : setsockopt(SCTP_PEER_ADDR_PARAMS) - one-to-many style invalid hb demand
> >    test_sockopt.c 26 BROK : bind: Address already in use
> >    DUMP_CORE ../../src/testlib/sctputil.h: 145
> > 
> >    ...
> > 
> >    test_1_to_1_sendmsg.c 10 PASS : sendmsg() on a closed association - EPIPE
> >    test_1_to_1_sendmsg.c 11 BROK : bind: Address already in use
> >    DUMP_CORE ../../src/testlib/sctputil.h: 145
> > 
> > The reason is that it closed a socket and then created a new socket
> > to bind the same socket address as before, which was not released
> > yet.
> > 
> > Signed-off-by: Jianwen Ji <jijianwen@gmail.com>
> > ---
> >  src/testlib/sctputil.h | 24 +++++++++++++++++++++---
> >  1 file changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
> > index 9dbabd4..5b807c7 100644
> > --- a/src/testlib/sctputil.h
> > +++ b/src/testlib/sctputil.h
> > @@ -54,6 +54,7 @@
> >  #endif
> >  
> >  #include <string.h>
> > +#include <unistd.h>
> >  
> >  typedef union {
> >  	struct sockaddr_in v4;	
> > @@ -72,6 +73,10 @@ typedef union {
> >  #endif
> >  #define SCTP_TESTPORT_2 (SCTP_TESTPORT_1+1)
> >  
> > +#ifndef MAX_BIND_RETRYS
> > +#define MAX_BIND_RETRYS 10
> > +#endif
> > +
> >  #define SCTP_IP_BCAST  	htonl(0xffffffff)
> >  #define SCTP_IP_LOOPBACK  htonl(0x7f000001)
> >  
> > @@ -140,9 +145,22 @@ static inline int test_socket(int domain, int type, int protocol)
> >  
> >  static inline int test_bind(int sk, struct sockaddr *addr, socklen_t addrlen)
> >  {
> > -	int error = bind(sk, addr, addrlen);
> > -        if (-1 = error)
> > -                tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > +	int error = 0, i = 0;
> > +
> > +	do {
> > +		if (i > 0) sleep(1); /* sleep a while before new try... */
> > +
> > +		error = bind(sk, addr, addrlen);
> > +		if (-1 = error && errno != EADDRINUSE) {
> > +			tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > +		}
> > +
> > +		i++;
> > +		if (i >= MAX_BIND_RETRYS) {
> > +			tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > +		}
> > +	} while (error < 0 && i < MAX_BIND_RETRYS);
> > +
> >  	return error;
> >  }
> >  
> > -- 
> > 2.14.5
> > 
> > 
> I don't think this is really going to do much.  If a socket isnt released then
> its not likely to be released in the amount of time it takes to iterate over
> this loop 10 times, and theres no guarantee that it will in the future.  If we
> want to ensure avoid EADDRINUSE, the second bind should probably just use
> SCTP_TESTPORT_2, instead of reusing _1

Agree. I'll go farther: if the test doesn't have a strict need on a
specific port number, it should let the kernel assign one. That way it
will also stress the port allocator.  Most of the tests can bind
without specifying a port and then ask which port it got.

  Marcelo
