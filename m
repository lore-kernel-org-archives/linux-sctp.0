From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Apr 2016 21:38:02 +0000
Subject: Re: [PATCH 0/2] sctp: Add GSO support
Message-Id: <20160429213802.GC5676@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1461965035.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1461965035.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>, Alexander Duyck <alexander.duyck@gmail.com>, Xin Long <lucien.xin@gmail.com>

Cc'ing Xin. Sorry Xin.

On Fri, Apr 29, 2016 at 06:33:31PM -0300, Marcelo Ricardo Leitner wrote:
> This patchset adds sctp GSO support.
> 
> Performance tests indicates that increases throughput by 10% if using
> bigger chunk sizes, specially if bigger than MTU. For small chunks, it
> doesn't help much if not using heavy firewall rules.
> 
> For small chunks it will probably be of more use once we get something
> like MSG_MORE as David Laight had suggested.
> 
> I believe I could address all comments from the RFC attempt.
> 
> Marcelo Ricardo Leitner (2):
>   skbuff: export skb_gro_receive
>   sctp: Add GSO support
> 
>  include/linux/netdev_features.h |   7 +-
>  include/linux/netdevice.h       |   1 +
>  include/linux/skbuff.h          |   7 +
>  include/net/sctp/sctp.h         |   4 +
>  include/net/sctp/structs.h      |   2 +
>  net/core/skbuff.c               |  11 +-
>  net/ipv4/af_inet.c              |   1 +
>  net/sctp/Makefile               |   3 +-
>  net/sctp/offload.c              |  98 +++++++++++
>  net/sctp/output.c               | 348 +++++++++++++++++++++++++++-------------
>  net/sctp/protocol.c             |   3 +
>  net/sctp/socket.c               |   2 +
>  12 files changed, 366 insertions(+), 121 deletions(-)
>  create mode 100644 net/sctp/offload.c
> 
> -- 

