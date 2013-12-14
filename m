From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 14 Dec 2013 15:04:21 +0000
Subject: undetected closed apps
Message-Id: <52AC7375.6010505@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Folks,

I have a problem which manifests in kernels > 3.8. I am no sure how
best to debug it.
I have looked at strace and dont see anything different between when it
works (kernels <= 3.8) and when it doesnt (kernels > 3.8).
When i dump /proc/net/sctp/assocs I can see in the non-working case
the socket is still there - which means there is no way for the server
to be notified.
If kill the server, the socket disappears.

Is there something else that would help narrow this down?

cheers,
jamal

PS:
Essentially I have a client app that does some nasty stuff (on purpose
to test robustness). Client and server are connected locally within same
machine.
Client sends as fast as it can packets with partial reliability (timeout
of about 100ms). The only time client checks for any kernel obsoleted
msgs is when the send socket queue write will block.
