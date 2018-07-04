From: =?UTF-8?Q?Martin_Schr=C3=B6der?= <martin@oneiros.de>
Date: Wed, 04 Jul 2018 13:09:12 +0000
Subject: Possible bug: Association always uses the primary source address in replies
Message-Id: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,
we have a server and a client. Both are connected to two different networks.
Betweeen these four networks there is a complex routing structure.
Due to an outage we have an outage from the primary interface of the server
to all networks of the client; there is still a route with the secondary
interface.

And then this happens:
1. The server is listening, the client is starting.
2. Client begins to start Init to the reachable (secondary) interface of
   the server
3. Server answers with Init ACK from his *primary* interface, which of
   course does not reach the client

Why does the server not answer on his secondary interface when there is
still a route on this interface to the client but uses the primary interface
which has no route?

Tested with 4.9 and 4.18.rc1.

Best
   Martin
