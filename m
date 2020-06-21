From: Corey Minyard <minyard@acm.org>
Date: Sun, 21 Jun 2020 15:56:04 +0000
Subject: Strange problem with SCTP+IPv6
Message-Id: <20200621155604.GA23135@minyard.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

I've stumbled upon a strange problem with SCTP and IPv6.  If I create an
sctp listening socket on :: and set the IPV6_V6ONLY socket option on it,
then I make a connection to it using ::1, the connection will drop after
2.5 seconds with an ECONNRESET error.

It only happens on SCTP, it doesn't have the issue if you connect to a
full IPv6 address instead of ::1, and it doesn't happen if you don't
set IPV6_V6ONLY.  I have verified current end of tree kernel.org.
I tried on an ARM system and x86_64.

I haven't dug into the kernel to see if I could find anything yet, but I
thought I would go ahead and report it.  I am attaching a reproducer.
Basically, compile the following code:

  gcc -g -o sctptest -Wall sctptest.c

and run it in one window as a server:

  ./sctptest a

(Pass in any option to be the server) and run the following in another
window as the client:

  ./sctptest

It disconnects after about 2.5 seconds.  If it works, it should just sit
there forever.

-corey


#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/select.h>
#include <arpa/inet.h>
#include <netinet/sctp.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

static int
getaddr(const char *addr, const char *port, bool listen,
	struct addrinfo **rai)
{
    struct addrinfo *ai, hints;

    memset(&hints, 0, sizeof(hints));
    hints.ai_flags = AI_ADDRCONFIG;
    if (listen)
	hints.ai_flags |= AI_PASSIVE;
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_SCTP;
    if (getaddrinfo(addr, port, &hints, &ai)) {
	perror("getaddrinfo");
	return -1;
    }

    *rai = ai;
    return 0;
}

static int
waitread(int s)
{
    char data[1];
    ssize_t rv;

    rv = read(s, data, sizeof(data));
    if (rv = -1) {
	perror("read");
	return -1;
    }
    printf("Read %d bytes\n", (int) rv);
    return 0;
}

static int
do_server(void)
{
    int err, ls, s, optval;
    struct addrinfo *ai;

    printf("Server\n");

    err = getaddr("::", "3023", true, &ai);
    if (err)
	return err;

    ls = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
    if (ls = -1) {
	perror("socket");
	return -1;
    }

    optval = 1;
    if (setsockopt(ls, SOL_SOCKET, SO_REUSEADDR,
		   (void *)&optval, sizeof(optval)) = -1) {
	perror("setsockopt reuseaddr");
	return -1;
    }

    /* Comment this out and it will work. */
    if (setsockopt(ls, IPPROTO_IPV6, IPV6_V6ONLY, &optval,
		   sizeof(optval)) = -1) {
	perror("setsockopt ipv6 only");
	return -1;
    }

    err = bind(ls, ai->ai_addr, ai->ai_addrlen);
    if (err = -1) {
	perror("bind");
	return -1;
    }

    err = listen(ls, 5);
    if (err = -1) {
	perror("listen");
	return -1;
    }

    s = accept(ls, NULL, NULL);
    if (s = -1) {
	perror("accept");
	return -1;
    }

    close(ls);

    err = waitread(s);
    close(s);
    return err;
}

static int
do_client(void)
{
    int err, s;
    struct addrinfo *ai;

    printf("Client\n");

    err = getaddr("::1", "3023", false, &ai);
    if (err)
	return err;

    s = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
    if (s = -1) {
	perror("socket");
	return -1;
    }

    err = connect(s, ai->ai_addr, ai->ai_addrlen);
    if (err = -1) {
	perror("connect");
	return -1;
    }

    err = waitread(s);
    close(s);
    return err;
}

int
main(int argc, char *argv[])
{
    int err;

    if (argc > 1)
	err = do_server();
    else
	err = do_client();
    return !!err;
}
