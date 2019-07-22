From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Jul 2019 14:52:13 +0000
Subject: Re: [PATCH lksctp-tools] testlib: improve test_bind function
Message-Id: <CADvbK_eAirWF0K44K_Ds-TrBZy=LFf7HiyNknGq-v7YcmVjbVg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190718075932.32323-1-jijianwen@gmail.com>
In-Reply-To: <20190718075932.32323-1-jijianwen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 18, 2019 at 4:00 PM Jianwen Ji <jijianwen@gmail.com> wrote:
>
> Try to bind again if the errno is EADDRINUSE.
> Some tests failed to run sometimes, here is one snapshot:
>
>    ...
>
>    test_sockopt.c 25 PASS : setsockopt(SCTP_PEER_ADDR_PARAMS) - one-to-many style invalid hb demand
>    test_sockopt.c 26 BROK : bind: Address already in use
>    DUMP_CORE ../../src/testlib/sctputil.h: 145
>
>    ...
>
>    test_1_to_1_sendmsg.c 10 PASS : sendmsg() on a closed association - EPIPE
>    test_1_to_1_sendmsg.c 11 BROK : bind: Address already in use
>    DUMP_CORE ../../src/testlib/sctputil.h: 145
The patch itself works, but there's a warning when I was compiling:
In file included from sctputil.c:54:
./sctputil.h: In function ‘test_bind’:
./sctputil.h:150:14: warning: implicit declaration of function ‘sleep’
[-Wimplicit-function-declaration]
   if (i > 0) sleep(1); /* sleep a while before new try... */
              ^~~~~

caused by the lack of '#include <unistd.h>' in src/testlib/sctputil.h

>
> The reason is that it closed a socket and then created a new socket
> to bind the same socket address as before, which was not released
> yet.
>
> Signed-off-by: Jianwen Ji <jijianwen@gmail.com>
> ---
>  src/testlib/sctputil.h | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
> index 9dbabd4..c03ff78 100644
> --- a/src/testlib/sctputil.h
> +++ b/src/testlib/sctputil.h
> @@ -72,6 +72,10 @@ typedef union {
>  #endif
>  #define SCTP_TESTPORT_2 (SCTP_TESTPORT_1+1)
>
> +#ifndef MAX_BIND_RETRYS
> +#define MAX_BIND_RETRYS 10
> +#endif
> +
>  #define SCTP_IP_BCAST          htonl(0xffffffff)
>  #define SCTP_IP_LOOPBACK  htonl(0x7f000001)
>
> @@ -140,9 +144,22 @@ static inline int test_socket(int domain, int type, int protocol)
>
>  static inline int test_bind(int sk, struct sockaddr *addr, socklen_t addrlen)
>  {
> -       int error = bind(sk, addr, addrlen);
> -        if (-1 == error)
> -                tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> +       int error = 0, i = 0;
> +
> +       do {
> +               if (i > 0) sleep(1); /* sleep a while before new try... */
> +
> +               error = bind(sk, addr, addrlen);
> +               if (-1 == error && errno != EADDRINUSE) {
> +                       tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> +               }
> +
> +               i++;
> +               if (i >= MAX_BIND_RETRYS) {
> +                       tst_brkm(TBROK, tst_exit, "bind: %s", strerror(errno));
> +               }
> +       } while (error < 0 && i < MAX_BIND_RETRYS);
> +
>         return error;
>  }
>
> --
> 2.14.5
>
