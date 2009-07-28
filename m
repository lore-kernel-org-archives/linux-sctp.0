From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 28 Jul 2009 22:31:08 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <20090728223108.GA10007@nortel.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
To: linux-sctp@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 28, 2009 at 11:18:05PM +0200, Michael T?xen wrote:
> >I don't think that's what the RFC says, but I guess only the  
> >author(s) of
> >the RFC could tell us what they really meant.  Your interpretation  
> >doesn't
> >make any sense to.
>
> Let us see the tracefile and I can tell you if that behaviour is the
> one the authors of the RFC intended...

Heh.  I'm guessing that you're one of the authors then?  I see you given
credit in RFC 4960, but the only author listed at the top is R. Stewart.

I've attached linux and BSD capture files, and the client and server
test programs.  The client just sends a request to the server, and then
waits for a reply.  The client loops four times and sleeps 2 seconds
between iterations.  I ran the client on a Fedora 10 laptop in all cases
(kernel version 2.6.27.25) and did the wireshark capture on the same
laptop.  sctp_bsd72_server.cap is the capture when running the server
on a FreeBSD 7.2 machine.  sctp_linux_server.cap is the capture when
running the server on a Fedora 10 desktop machine.  A single iteration
with the BSD server looks like:

  7 2.000205    10.0.0.15     10.0.0.11         SCTP     DATA
  8 2.000501    10.0.0.11     10.0.0.15         SCTP     SACK DATA
  9 2.200484    10.0.0.15     10.0.0.11         SCTP     SACK

So one DATA packet from client to server, then the reply data packet
from server to client with a bundled SACK, then the SACK from client
to server to acknowledge the reply.  The last SACK does have to wait
for the SACK timer to expire; this is to be expected, since no more
data is sent until the next iteration in a couple seconds.

A single iteration with the Linux server looks like:

  7 2.000161    10.0.0.15     10.0.0.12         SCTP     DATA
  8 2.000495    10.0.0.12     10.0.0.15         SCTP     DATA
  9 2.199995    10.0.0.15     10.0.0.12         SCTP     SACK
 10 2.200170    10.0.0.12     10.0.0.15         SCTP     SACK


> >In BSD's case, I *did* see it piggyback the SACK.
>
> I guess you did not specify SCTP_DATA_SACK_IMMEDIATELY in the send()  
> call...

No, I didn't.  If I had, I agree that no piggybacking would have been
possible.  That was what I was trying to say: from the trace, it did
not look as though BSD was using the immediate SACK feature.

--Doug.

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="client.c"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define PORT 12342

int main(int argc, char **argv)
{
	int s, cc, i;
	struct sockaddr_in addr;
	in_addr_t destaddr = inet_addr("127.0.0.1");

	if (argv[1])
		destaddr = inet_addr(argv[1]);

	if ((s = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP)) < 0) {
		perror("socket");
		exit(1);
	}

	memset(&addr, '\0', sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = destaddr;
	addr.sin_port = htons(PORT);

	char buf[] = "yo momma wears army boots";
	struct iovec iov[1] = {{.iov_base = buf, .iov_len = sizeof(buf)}};
	struct msghdr msg = {
		.msg_name = &addr,
		.msg_namelen = sizeof(addr),
		.msg_iov = iov,
		.msg_iovlen = sizeof(iov)/sizeof(iov[0]),
		.msg_control = NULL,
		.msg_controllen = 0,
		.msg_flags = 0
	};

	for (i = 0; i < 4; i++) {
		printf("Sending message to %s\n", inet_ntoa(addr.sin_addr));

		if ((cc = sendmsg(s, &msg, 0)) < 0) {
			perror("sendmsg");
			exit(1);
		}
		sleep(2);
	}

	return 0;
}

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="server.c"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define PORT 12342

int main(void)
{
	int s, cc;
	struct sockaddr_in addr;

	if ((s = socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP)) < 0) {
		perror("socket");
		exit(1);
	}

	memset(&addr, '\0', sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = INADDR_ANY;
	addr.sin_port = htons(PORT);

	if (bind(s, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
		perror("bind");
		exit(1);
	}
	if (listen(s, 5) < 0) {
		perror("listen");
		exit(1);
	}

	for (;;) {
		char buf[128];
		struct iovec iov[1] = {{.iov_base = buf, .iov_len = sizeof(buf)}};
		struct msghdr msg = {
			.msg_name = &addr,
			.msg_namelen = sizeof(addr),
			.msg_iov = iov,
			.msg_iovlen = sizeof(iov)/sizeof(iov[0]),
			.msg_control = NULL,
			.msg_controllen = 0,
			.msg_flags = 0
		};

		printf("Waiting for message\n");

		cc = recvmsg(s, &msg, 0);

		printf("Got msg, len = %d\n", cc);

		sendmsg(s, &msg, 0);
	}
}

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="sctp_bsd72_server.cap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAv3JvSsM8DQBaAAAAWgAAAAATIBim+AAVxQSILggA
RQIATAAAQABAhCYTCgAADwoAAAu8jzA2AAAAAF1Z4g0BAAAsl6BzkwAA3AAACv//7L/YiQAM
AAYABQAAgAAABMAAAATABgAIAAAAAL9yb0rtPQ0AogEAAKIBAAAAFcUEiC4AEyAYpvgIAEUA
AZQBTwAAQIRjfgoAAAsKAAAPMDa8j5egc5NJtEz/AgABdGUPgHkAA444AAoIAN09haXABgAI
UExSU4AAAATAAAAEgAgACsGAwIGCDwAAgAIAJGkyzOOhSNSU7xrmelRnWFPfNcaw+PeYLkTv
MOUFKYGJgAQACAABAAOAAwAGgMEAAAAHARBLQU1FLUJTRCAxLjE0yUbB0gEAAEb7CABg6gAA
AAAAAAAAAACXoHOTZQ+AeQoAAA8AAAAAAAAAAAAAAAAFAAAACgAACwAAAAAAAAAAAAAAAAUA
AAAAAAAAvI8wNgEAAAABAHzEBAAAAAEAACyXoHOTAADcAAAK///sv9iJAAwABgAFAACAAAAE
wAAABMAGAAgAAAAAAgABdGUPgHkAA444AAoIAN09haXABgAIUExSU4AAAATAAAAEgAgACsGA
wIGCDwAAgAIAJGkyzOOhSNSU7xrmelRnWFPfNcaw+PeYLkTvMOUFKYGJgAQACAABAAOAAwAG
gMEAAIMWqLM0eYge24YU4YioA2W3R9AFv3JvSic+DQBqAQAAagEAAAATIBim+AAVxQSILggA
RQIBXAAAQABAhCUDCgAADwoAAAu8jzA2ZQ+AefNP0g0KAAEQS0FNRS1CU0QgMS4xNMlGwdIB
AABG+wgAYOoAAAAAAAAAAAAAl6Bzk2UPgHkKAAAPAAAAAAAAAAAAAAAABQAAAAoAAAsAAAAA
AAAAAAAAAAAFAAAAAAAAALyPMDYBAAAAAQB8xAQAAAABAAAsl6BzkwAA3AAACv//7L/YiQAM
AAYABQAAgAAABMAAAATABgAIAAAAAAIAAXRlD4B5AAOOOAAKCADdPYWlwAYACFBMUlOAAAAE
wAAABIAIAArBgMCBgg8AAIACACRpMszjoUjUlO8a5npUZ1hT3zXGsPj3mC5E7zDlBSmBiYAE
AAgAAQADgAMABoDBAACDFqizNHmIHtuGFOGIqANlt0fQBQADACrsv9iJAAAAAAAAAAB5byBt
b21tYSB3ZWFycyBhcm15IGJvb3RzAAAAv3JvSrA/DQBCAAAAQgAAAAAVxQSILgATIBim+AgA
RQAANAFQQABAhCTdCgAACwoAAA8wNryPl6Bzk3KS8AELAAAEAwAAEOy/2IkAA40eAAAAAL9y
b0raPw0AvgAAAL4AAAAAFcUEiC4AEyAYpvgIAEUCALABUUAAQIQkXgoAAAsKAAAPMDa8j5eg
c5NT/B5tAAMAkN09haUAAAAAAAAAAHlvIG1vbW1hIHdlYXJzIGFybXkgYm9vdHMABggwEBAo
AAAAAAwAAAAwEBAoDAAAADAQECie3gQIMBAQKAAAAAAQAAAAAAAAAAAAAAA83wYIPN8GCBAA
AACI3gYIABAQKAAAAAAAAAAAAAAAAAAAAAAAAAAAMBAQKDAQECgwEBAov3JvSvU/DQA+AAAA
PgAAAAATIBim+AAVxQSILggARQIAMAAAQABAhCYvCgAADwoAAAu8jzA2ZQ+Aedh5tT8DAAAQ
3T2FpQAA24AAAAAAwXJvSpA9DQBaAAAAWgAAAAATIBim+AAVxQSILggARQIATAAAQABAhCYT
CgAADwoAAAu8jzA2ZQ+AeU1OGNoAAwAq7L/YigAAAAEAAAAAeW8gbW9tbWEgd2VhcnMgYXJt
eSBib290cwAAAMFyb0q4Pg0AzgAAAM4AAAAAFcUEiC4AEyAYpvgIAEUCAMABU0AAQIQkTAoA
AAsKAAAPMDa8j5egc5OQQqYZAwAAEOy/2IoAA444AAAAAAADAJDdPYWmAAAAAQAAAAB5byBt
b21tYSB3ZWFycyBhcm15IGJvb3RzAAYIMBAQKAAAAAAMAAAAMBAQKAwAAAAwEBAont4ECDAQ
ECgAAAAAEAAAAAAAAAAAAAAAPN8GCDzfBggQAAAAiN4GCAAQECgAAAAAAAAAAAAAAAAAAAAA
AAAAADAQECgwEBAoMBAQKMJyb0qnCQEAPgAAAD4AAAAAEyAYpvgAFcUEiC4IAEUCADAAAEAA
QIQmLwoAAA8KAAALvI8wNmUPgHmtoLhIAwAAEN09haYAANsAAAAAAMNyb0pWPg0AWgAAAFoA
AAAAEyAYpvgAFcUEiC4IAEUCAEwAAEAAQIQmEwoAAA8KAAALvI8wNmUPgHmeQjbLAAMAKuy/
2IsAAAACAAAAAHlvIG1vbW1hIHdlYXJzIGFybXkgYm9vdHMAAADDcm9KOT8NAM4AAADOAAAA
ABXFBIguABMgGKb4CABFAgDAAVVAAECEJEoKAAALCgAADzA2vI+XoHOTQNHVMQMAABDsv9iL
AAOOOAAAAAAAAwCQ3T2FpwAAAAIAAAAAeW8gbW9tbWEgd2VhcnMgYXJteSBib290cwAGCDAQ
ECgAAAAADAAAADAQECgMAAAAMBAQKJ7eBAgwEBAoAAAAABAAAAAAAAAAAAAAADzfBgg83wYI
EAAAAIjeBggAEBAoAAAAAAAAAAAAAAAAAAAAAAAAAAAwEBAoMBAQKDAQECjEcm9KkQgBAD4A
AAA+AAAAABMgGKb4ABXFBIguCABFAgAwAABAAECEJi8KAAAPCgAAC7yPMDZlD4B5oMgUPQMA
ABDdPYWnAADagAAAAADFcm9K4z4NAFoAAABaAAAAABMgGKb4ABXFBIguCABFAgBMAABAAECE
JhMKAAAPCgAAC7yPMDZlD4B5PdDtZgADACrsv9iMAAAAAwAAAAB5byBtb21tYSB3ZWFycyBh
cm15IGJvb3RzAAAAxXJvStM/DQDOAAAAzgAAAAAVxQSILgATIBim+AgARQIAwAFXQABAhCRI
CgAACwoAAA8wNryPl6Bzkx0mi0cDAAAQ7L/YjAADjjgAAAAAAAMAkN09hagAAAADAAAAAHlv
IG1vbW1hIHdlYXJzIGFybXkgYm9vdHMABggwEBAoAAAAAAwAAAAwEBAoDAAAADAQECie3gQI
MBAQKAAAAAAQAAAAAAAAAAAAAAA83wYIPN8GCBAAAACI3gYIABAQKAAAAAAAAAAAAAAAAAAA
AAAAAAAAMBAQKDAQECgwEBAoxnJvSogIAQA+AAAAPgAAAAATIBim+AAVxQSILggARQIAMAAA
QABAhCYvCgAADwoAAAu8jzA2ZQ+AeXEhpSwDAAAQ3T2FqAAA2gAAAAAAx3JvSqY/DQA2AAAA
NgAAAAATIBim+AAVxQSILggARQIAKAAAQABAhCY3CgAADwoAAAu8jzA2ZQ+AeWt+iRkHAAAI
3T2FqMdyb0qyQA0APAAAADwAAAAAFcUEiC4AEyAYpvgIAEUAACQBWUAAQIQk5AoAAAsKAAAP
MDa8j5egc5MsaiINCAAABAAAAAAAAAAAAADHcm9K1kANADIAAAAyAAAAABMgGKb4ABXFBIgu
CABFAgAkAABAAECEJjsKAAAPCgAAC7yPMDZlD4B5q41olQ4AAAQ=

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="sctp_linux_server.cap"
Content-Transfer-Encoding: base64

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
AAQ=

--opJtzjQTFsWo+cga--
