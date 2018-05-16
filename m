From: Andreas Fink <afink@list.fink.org>
Date: Wed, 16 May 2018 12:02:46 +0000
Subject: SCTP nailed down connections trouble
Message-Id: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello all

I have detected that the Linux SCTP implementation behaves differently than the FreeBSD and MacOS X SCTP implementations and I am trying to find the proper way to work around this issue.
What I have is nailed down peer to peer SCTP associations as it is mandatory in the Sigtran world. This means the source and destination ports are preconfigured on both sides and both sides can establish the connection at any time. So there is no client and no server. 

For this to work I normally do

	socket()
	fcntl() to set to non blocking
	setsockopt() to set various options such as linger time, nodelay and reuseaddr and enable sctp events
	bind() to define the local IP's and ports to use
	sctp_connectx() to connect to the remote ip and port

After this a SCTP INIT is sent to the remote.

	if the remote is a Cisco ITP; the connection comes up normally and all works.
	If the remote is another linux box with the same software it fails because the Linux kernel sends back a SCTP ABORT. and sctp_connectx fails instead of waiting for the other side to come up.
	So we end up in a race condition that both sides have to send the SCTP INIT at the same time to have this working. Whenever one is faster, the other side generates ABORT and it fails again.


Under FreeBSD and MacOS, the sctp_connectx returns without an error (as its a non blocking socket) and my subsequent code then calls poll to wait for events or data to be delivered with a follow up call to sctp_recvmsg to process that data and/or events
I would expect  a SCTP UP message  to appear after the other side has done the same after the SCTP handshake completes.

Under Linux however sctp_connectx does immediately return with connection refused and we are stuck.
I have not figured out how this can be achieved reliably. constantly calling sctp_connectx can not be the solution as it would create a busy loop and probably a packet storm.

I have a minimalized code example on https://github.com/andreasfink/sctp-test.

That example  you run with 
	./sctp-test <localip> <localport> <remoteip> <remoteport>

when run under MacOS with a non existing host I get

./sctp-test 10.0.67.209 7000 1.2.3.4 7000
socket() successful
setting socket to non blocking
setting socket to blocking=0
fcntl successful
setsockopt(IPPROTO_SCTP,SCTP_EVENTS) successful
setsockopt(SOL_SOCKET,SO_LINGER,5) successful
setsockopt(SOL_SOCKET,SO_REUSEADDR) successful
setsockopt(IPPROTO_SCTP,SCTP_REUSE_PORT) successful
setsockopt(SCTP_NODELAY) successful
bind() successful
sctp_connectx() successful
 poll returns 0
 poll returns 0
 poll returns 0
 poll returns 0
 poll returns 0
 poll returns 0
 poll returns 0

when under Linux

to a non existing hist
./sctp-test 10.99.3.27 7000 1.2.3.4 7000
socket() successful
setting socket to non blocking
setting socket to blocking=0
fcntl successful
setsockopt(IPPROTO_SCTP,SCTP_EVENTS) successful
setsockopt(SOL_SOCKET,SO_LINGER,5) successful
setsockopt(SOL_SOCKET,SO_REUSEADDR) successful
setsockopt(SCTP_NODELAY) successful
bind() successful

(meaning sctp_connectx doesn't return here and locks)


under Linux to a existing host where the software is not started yet.

./sctp-test x.x.x.x 7000 y.y.y.y 8000
socket() successful
setting socket to non blocking
setting socket to blocking=0
fcntl successful
setsockopt(IPPROTO_SCTP,SCTP_EVENTS) successful
setsockopt(SOL_SOCKET,SO_LINGER,5) successful
setsockopt(SOL_SOCKET,SO_REUSEADDR) successful
setsockopt(IPPROTO_SCTP,SCTP_REUSE_PORT) not supported
setsockopt(SCTP_NODELAY) successful
bind() successful
sctp_connectx failed (111 Connection refused)

Note: the error is immediately returned. not after timeout.


I test with the lksctp version delivered with Debian 9 - strech. If theres some changes since that version in this area, let me know.

A second area where I found issues is on how to configure a specific port to be used for multiple connections. For example my local port 2000 can be used for a connection to host 1 or to host 2 and the individual sessions which are created as above will however not allow me to use the same port in a second socket even though the bind is not follwed with a listen and the sctp_connectx goes to  a different port. Workaround to this is to use different ports for every connection (which is not really nice). Maybe there's another way?




A. FInk
