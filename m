From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Wed, 03 Dec 2014 16:11:10 +0000
Subject: Problem with a host having an UNREACHABLE address ?
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

   Hi,

I've another problem to submit to your knowledge !

I test my SCTP messaging small application between two hosts far away
one from another, with possible packet loss on the net. Each of them is
advertising two different [IPv4] addresses, but in fact, on one host,
one IP isn't actually connected and can't be used for messages.

When I start SCTP messages exchanges, the hosts are using the first
address, which is working, and messages are correctly transmitted. On
the peer of the failing-IP host, I get notifications that this IP
address is UNREACHABLE, it's correct. In fact, I get one notification
each 100ms, but this can probably be setup.
The problem is that after some time of message exchanges, about 20
seconds, the hosts get a LOST notification for the association and no
message can't be sent anymore until a new association is built.

Should I do something when I get a UNREACHABLE peer change notification
? is the LOST related to these UNREACHABLE notifications, or should I
look for other cause ? I didn't saw this behavior during my tests (on
virtual hosts)...

                Thanks for you help,
                               Fred.

