From: Robin Holt <holt@sgi.com>
Date: Fri, 01 Oct 2010 19:39:58 +0000
Subject: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
Message-Id: <20101001193958.GP14068@sgi.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-sctp@vger.kernel.org


On a 16TB system, we noticed that sysctl_tcp_mem[2] and sysctl_udp_mem[2]
were negative.  Code review indicates that the same should occur with
sysctl_sctp_mem[2].

There are a couple ways we could address this.  The one which appears most
reasonable would be to change the struct proto defintion for sysctl_mem
from an int to a long and handle all the associated fallout.

An alternative is to limit the calculation to 1/2 INT_MAX.  The downside
being that the administrator could not tune the system to use more than
INT_MAX memory when much more is available.

Is there a compelling reason to not change the structure's definition
over to longs instead of ints and deal with the fallout from that change?

Thanks,
Robin Holt
