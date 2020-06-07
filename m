From: Andreas Fink <afink@list.fink.org>
Date: Sun, 07 Jun 2020 12:18:40 +0000
Subject: EAGAIN
Message-Id: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello folks,

I run into a strange issue with SCTP under Linux and I'm not sure whats the right approach to fix this.

I have a listener thread which listens on a port for multiple inbound connections
I have a sender thread which sends packets to peers by using the same socket and doing a sctp_sendv call.
Sockets are always in non blocking mode.

When the remote side gets stopped (process killed),  the sctp_sendv starts returning 0 and errno is set to EAGAIN and we constantly retry.
We somehow didn't catch that this socket was down and end up in a busy loop (which we now fail after a certain amount of retries).

My question to you is whats the correct way to deal with EAGAIN here? Why are we not catching the assoc being down?
We have a sender thread and a receiver thread. The receiver thread is listening to events and should know.
Furthermore if the assoc is down the sctp_sendv could simply return something like socket not connected error instead of EAGAIN.

Or what am I missing here?


Andreas

PS: above was under Linux Debian Kernel 5.4.0-0.bpo.4.
