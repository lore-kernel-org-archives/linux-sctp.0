From: Diego Elio =?UTF-8?Q?=E2=80=9CFlameeyes=E2=80=9D_?=
Date: Thu, 24 Jun 2010 13:20:36 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
Message-Id: <1277385636.13544.67.camel@yamato.local>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="=-8ivO6s/iQlE/cndBAjoN"
List-Id: <linux-sctp.vger.kernel.org>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
	 <4C235B75.2000807@hp.com>
In-Reply-To: <4C235B75.2000807@hp.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org


--=-8ivO6s/iQlE/cndBAjoN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Il giorno gio, 24/06/2010 alle 09.19 -0400, Vlad Yasevich ha scritto:
> 
> This should add a check for sctp_style(sk, TCP), since one can't read
> from
> a TCP style listening sockets, but can do so from UDP-style
> (SOCK_SEQPACKET). 

I don't want to sound arrogant but... are you sure?

I ask because the simple testcase I wrote to make sure I didn't get it
wrong opened the socket as SOCK_STREAM, and yet all of this worked fine
(I'm attaching the source, for the sake of it)...

I sure hope you're mistaken here and it is _supposed_ to work here as
well, as we cannot use SOCK_SEQPACKET in the software I'm writing this
for (feng, from the lscube project) as accept() fails on SOCK_SEQPACKET
(EOPNOTSUPP) -- which itslef is strange given that the man page for
accept(2) reports it's supported on SOCK_STREAM and SOCK_SEQPACKET.

-- 
Diego Elio Pettenò — “Flameeyes”
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


--=-8ivO6s/iQlE/cndBAjoN
Content-Disposition: attachment; filename="sctp-fionread.c"
Content-Type: text/x-csrc; name="sctp-fionread.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/sockios.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <stdio.h>
#include <netdb.h>
#include <stdlib.h>

int main() {
  int sock, client, pkgsize, realpkgsize, i;
  uint8_t *pkg;
  struct addrinfo *res;

  static const struct addrinfo hints_ipv6 = {
    .ai_family = AF_INET,
    .ai_socktype = SOCK_SEQPACKET,
    .ai_flags = AI_PASSIVE
  };

  static const struct sctp_initmsg initparams = {
    .sinit_max_instreams = 5,
    .sinit_num_ostreams = 5,
  };

  static const struct sctp_event_subscribe subscribe = {
    .sctp_data_io_event = 1
  };

  static const int on = 1;

  if ( getaddrinfo(NULL, "2811", &hints_ipv6, &res) < 0 ) {
    perror("getaddrinfo");
    return -1;
  }

  if ( (sock = socket(res->ai_family, SOCK_STREAM, IPPROTO_SCTP)) < 0 ) {
    perror("socket");
    return -1;
  }
 
  if (setsockopt(sock, SOL_SCTP, SCTP_EVENTS, &subscribe,
		 sizeof(subscribe)) < 0) {
    perror("setsockopt(SCTP_EVENTS)");
    return -1;
  }

  if (setsockopt(sock, SOL_SCTP, SCTP_INITMSG, &initparams,
		 sizeof(initparams)) < 0) {
    perror("setsockopt(SCTP_INITMSG)");
    return -1;
  }

  if ( setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
		  &on, sizeof(on)) < 0 ) {
    perror("setsockopt(SO_REUSEADDR)");
    return -1;
  }

  if ( bind(sock, res->ai_addr, res->ai_addrlen) < 0 ) {
    perror("bind");
    return -1;
  }

  if ( listen(sock, 1) < 0 ) {
    perror("listen");
    return -1;
  }

  if ( (client = accept(sock, NULL, NULL)) < 0 ) {
    perror("accept");
    return -1;
  }

  sleep(10);

  if ( ioctl(client, SIOCINQ, &pkgsize) < 0 ) {
    perror("ioctl");
    return -1;
  }

  fprintf(stderr, "Expecting packet of size %d\n", pkgsize);

  pkg = malloc(pkgsize*2);
  realpkgsize = sctp_recvmsg(client,
			     pkg, pkgsize*2,
			     NULL, 0, NULL, NULL);

  fprintf(stderr, "Received packet of size %d\n", realpkgsize);

  for(i = 0; i < realpkgsize; i++)
    fprintf(stderr, "%02x ", pkg[i]);

  fprintf(stderr, "\n");

  close(client);
  close(sock);
  return 0;
}

--=-8ivO6s/iQlE/cndBAjoN--

