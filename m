From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Mon, 16 Mar 2015 16:37:54 +0000
Subject: Strange slow transfer behavior on local host connection
Message-Id: <CAAyB5cLzqMaFbN=exbmNh-OZWgML4CXAvnH8HnH_-iW5VERm6A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello everyone,

We have found a very strange behavior where the transfer is
particularly slower when sending data to a socket connecting ports on
the same host, but rather faster to the socket connecting ports on
different host.  /proc/net/sctp/assoc shows that TX_QUEUE of same host
socket buffers a lot of data but RX_QUEUE of the socket on the
receiving side is almost empty. On the contrary, both TX_QUEUE and
RX_QUEUE are almost empty for those sockets connecting different
hosts.

We first thought this might because the processing difference between
local and remote hosts, but the problem remains the same even for a
symmetric case where both hosts send same messages to both its own
local and remote receiver, and receive messages via different local
and remote connections. In our opinion, the data transfer should be
faster or at least the same when sending to a socket connecting local
ports.

This problem particularly occurs when the message size is small, but
playing with SCTP NODELAY option doesn't help.

I'm not sure if I may have missed anything, but any comments to shed
lights on this, or suggestions to tune would be appreciated very much!

Regards,
Jerry
