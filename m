From: Matt <mattator@gmail.com>
Date: Fri, 14 Nov 2014 16:54:14 +0000
Subject: Is it possible to schedule packets from userspace ?
Message-Id: <CADHp1NxYf7bWiO6e2YjOVrA8ruRK_JLv5fNAWRdjMSZ5Xby3cA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

hi,

I would like to test different CMT-SCTP scheduling strategies that
mimic an MPTCP-like connection (ie. per path buffer, one ordered
stream of data).

My question is:
is it possible with the current implementation to schedule packets
from userspace, ie to let the application choose over which path to
send which packet ?

If yes, could you give me a few function names/pointers on wher to
look at please ? I've seen some tutorials on the net, but none with
the previous usecase.

Cheers
Matt
