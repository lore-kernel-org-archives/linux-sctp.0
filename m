From: Ji Jianwen <jijianwen@gmail.com>
Date: Thu, 25 Jul 2019 07:12:15 +0000
Subject: Re: [PATCH v2 lksctp-tools] testlib: improve test_bind function
Message-Id: <CAGWhr0D1PBZtz+aL5ZUNVk8Kj6Hs102KRBs_JjZSsTp14Zkb6Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190724103930.13727-1-jijianwen@gmail.com>
In-Reply-To: <20190724103930.13727-1-jijianwen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 25, 2019 at 10:39 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 11:12:43PM -0300, Marcelo Ricardo Leitner wrote:
> > On Thu, Jul 25, 2019 at 09:04:33AM +0800, Ji Jianwen wrote:
> > > On Wed, Jul 24, 2019 at 8:40 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, Jul 24, 2019 at 07:38:36AM -0400, Neil Horman wrote:
> > > > > On Wed, Jul 24, 2019 at 06:39:30PM +0800, Jianwen Ji wrote:
> > > > > > Try to bind again if the errno is EADDRINUSE.
> > > > > > Some tests failed to run sometimes, here is one snapshot:
> > > > > >
> > > > > >    ...
> > > > > >
> > > > > >    test_sockopt.c 25 PASS : setsockopt(SCTP_PEER_ADDR_PARAMS) - one-to-many style invalid hb demand
> > > > > >    test_sockopt.c 26 BROK : bind: Address already in use
> > > > > >    DUMP_CORE ../../src/testlib/sctputil.h: 145
> > > > > >
> > > > > >    ...
> > > > > >
> > > > > >    test_1_to_1_sendmsg.c 10 PASS : sendmsg() on a closed association - EPIPE
> > > > > >    test_1_to_1_sendmsg.c 11 BROK : bind: Address already in use
> > > > > >    DUMP_CORE ../../src/testlib/sctputil.h: 145
> > > > > >
> > > > > > The reason is that it closed a socket and then created a new socket
> > > > > > to bind the same socket address as before, which was not released
> > > > > > yet.
> > > > > >
> > > > > > Signed-off-by: Jianwen Ji <jijianwen@gmail.com>
> > > > > > ---
> > > > > >  src/testlib/sctputil.h | 24 +++++++++++++++++++++---
> > > > > >  1 file changed, 21 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
> > > > > > index 9dbabd4..5b807c7 100644
> > > > > > --- a/src/testlib/sctputil.h
> > > > > > +++ b/src/testlib/sctputil.h
> > > > > > @@ -54,6 +54,7 @@
> > > > > >  #endif
> > > > > >
> > > > > >  #include <string.h>
> > > > > > +#include <unistd.h>
> > > > > >
> > > > > >  typedef union {
> > > > > >     struct sockaddr_in v4;
> > > > > > @@ -72,6 +73,10 @@ typedef union {
> > > > > >  #endif
> > > > > >  #define SCTP_TESTPORT_2 (SCTP_TESTPORT_1+1)
> > > > > >
> > > > > > +#ifndef MAX_BIND_RETRYS
> > > > > > +#define MAX_BIND_RETRYS 10
> > > > > > +#endif
> > > > > > +
> > > > > >  #define SCTP_IP_BCAST      htonl(0xffffffff)
> > > > > >  #define SCTP_IP_LOOPBACK  htonl(0x7f000001)
> > > > > >
> > > > > > @@ -140,9 +145,22 @@ static inline int test_socket(int domain, int type, int protocol)
> > > > > >
> > > > > >  static inline int test_bind(int sk, struct sockaddr *addr, socklen_t addrlen)
> > > > > >  {
> > > > > > -   int error = bind(sk, addr, addrlen);
> > > > > > -        if (-1 = error)
> > > > > > -                tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > > > > > +   int error = 0, i = 0;
> > > > > > +
> > > > > > +   do {
> > > > > > +           if (i > 0) sleep(1); /* sleep a while before new try... */
> > > > > > +
> > > > > > +           error = bind(sk, addr, addrlen);
> > > > > > +           if (-1 = error && errno != EADDRINUSE) {
> > > > > > +                   tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > > > > > +           }
> > > > > > +
> > > > > > +           i++;
> > > > > > +           if (i >= MAX_BIND_RETRYS) {
> > > > > > +                   tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> > > > > > +           }
> > > > > > +   } while (error < 0 && i < MAX_BIND_RETRYS);
> > > > > > +
> > > > > >     return error;
> > > > > >  }
> > > > > >
> > > > > > --
> > > > > > 2.14.5
> > > > > >
> > > > > >
> > > > > I don't think this is really going to do much.  If a socket isnt released then
> > > > > its not likely to be released in the amount of time it takes to iterate over
> > > > > this loop 10 times, and theres no guarantee that it will in the future.  If we
> > > > > want to ensure avoid EADDRINUSE, the second bind should probably just use
> > > > > SCTP_TESTPORT_2, instead of reusing _1
> > > >
> > > > Agree. I'll go farther: if the test doesn't have a strict need on a
> > > > specific port number, it should let the kernel assign one. That way it
> > > > will also stress the port allocator.  Most of the tests can bind
> > > > without specifying a port and then ask which port it got.
> > > >
> > > >   Marcelo
> > >
> > > That would be great if we make test not depend on specific port number.
> > > Please help look into it.
> > > Take test_sockopt.c for example:
> > >  733
> > >  734         close(udp_svr_sk);
> > >  735         close(udp_clt_sk);
> > >  736
> > >  737
> > >  738         /* TEST #6: SCTP_DEFAULT_SEND_PARAM socket option. */
> > >  739         /* Create and bind 2 UDP-style sockets(udp_svr_sk, udp_clt_sk) and
> > >  740          * 2 TCP-style sockets. (tcp_svr_sk, tcp_clt_sk)
> > >  741          */
> > >  742         udp_svr_sk = test_socket(pf_class, SOCK_SEQPACKET, IPPROTO_SCTP);
> > >  743         udp_clt_sk = test_socket(pf_class, SOCK_SEQPACKET, IPPROTO_SCTP);
> > >
> > >                 ...
> > >
> > >  753         test_bind(udp_svr_sk, &udp_svr_loop.sa, sizeof(udp_svr_loop));
> > >  754         test_bind(udp_clt_sk, &udp_clt_loop.sa, sizeof(udp_clt_loop));
> > >
> > > It closes 2 sockets at line 734 and 735, then next test item binds the
> > > same socket addresses again at line 753 and 754.
> >
> > That's what it does now but does it have to be the same addresses?
> >
> > > If run this program in a loop, the EADDRINUSE error will definitely
> > > happen at some point.
> > >       while true; do
> > >            ./test_sockopt
> > >            [ $? -ne 0 ] && exit
> > >       done
> >
> > Yep.
> >
> > What about something like the below. In theory the getsockaddr result
> > should be equivalent to what was passed to the function, and thus can
> > be used by a subsequent call to connect().
> >
> > (The additional include breaks the build, btw)
> >
> > diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
> > index 9dbabd4762e0..e18d5b55110b 100644
> > --- a/src/testlib/sctputil.h
> > +++ b/src/testlib/sctputil.h
> > @@ -54,6 +54,7 @@
> >  #endif
> >
> >  #include <string.h>
> > +#include <arpa/inet.h>
>
> This is not needed.. it was for a previous version on which I had used
> ntohs() to return the allocated port number to the app.
>
> >
> >  typedef union {
> >       struct sockaddr_in v4;
> > @@ -146,6 +147,28 @@ static inline int test_bind(int sk, struct sockaddr *addr, socklen_t addrlen)
> >       return error;
> >  }
> >

Thanks for your patch, it helps a lot!

> > +static inline int test_bind_freeport(int sk, struct sockaddr *addr, socklen_t addrlen)
> > +{
> > +     struct sockaddr sa;
> > +     int error;
> > +
> > +     if (sa.sa_family = AF_INET)
I guess it should be "addr->sa_family"

> > +             ((struct sockaddr_in *)addr)->sin_port = 0;
> > +     else if (sa.sa_family = AF_INET6)
The same as above comment

> > +             ((struct sockaddr_in6 *)addr)->sin6_port = 0;
> > +
> > +     error = test_bind(sk, addr, addrlen);
> > +        if (-1 = error)
> > +             return error;
> > +
> > +     addrlen = sizeof(sa);
> > +     error = getsockname(sk, &sa, &addrlen);
> > +     if (-1 = error)
> > +                tst_brkm(TBROK, tst_exit, "getsockname: %s", strerror(errno));
> > +
We need to copy port number back to "addr" so that the caller knows
which port it is using.
            if (addr->sa_family = AF_INET)
                     ((struct sockaddr_in *)addr)->sin_port                            ((struct sockaddr_in *)&sa)->sin_port;
            else if (addr->sa_family = AF_INET6)
                    ((struct sockaddr_in6 *)addr)->sin6_port                            ((struct sockaddr_in6 *)&sa)->sin6_port;

> > +     return error;
> > +}
> > +

I applied your patch with above changes, then replaced all test_bind
with test_bind_freeport in test_sockopt.c
And it works for me now.

But if we do the same thing in other test source files, we need to be
cautious and may do extra work. For example:
In test_basic.c, it compares with the fixed port number at somewhere:

217         }
218         if (msgname.v4.sin_port != htons(SCTP_TESTPORT_1)) {
219                 DUMP_CORE;
220         }

> >  static inline int test_bindx_add(int sk, struct sockaddr *addr, int count)
> >  {
> >       int error = sctp_bindx(sk, addr, count, SCTP_BINDX_ADD_ADDR);
> >
