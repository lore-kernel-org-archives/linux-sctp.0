From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 31 May 2016 18:55:43 +0000
Subject: [PATCH v2 0/7] sctp: Add GSO support
Message-Id: <cover.1464718103.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Laight <David.Laight@ACULAB.COM>, Vlad Yasevich <vyasevich@gmail.com>, Alexander Duyck <alexander.duyck@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>

This patchset adds sctp GSO support.

Performance tests indicates that increases throughput by 10% if using
bigger chunk sizes, specially if bigger than MTU. For small chunks, it
doesn't help much if not using heavy firewall rules.

For small chunks it will probably be of more use once we get something
like MSG_MORE as David Laight had suggested.

v1->v2:
Added support for receiving GSO frames on SCTP stack, as requested by
Dave Miller.

Marcelo Ricardo Leitner (7):
  loopback: make use of NETIF_F_GSO_SOFTWARE
  skbuff: export skb_gro_receive
  sk_buff: allow segmenting based on frag sizes
  skbuff: introduce skb_gso_validate_mtu
  sctp: delay as much as possible skb_linearize
  sctp: Add GSO support
  sctp: improve debug message to also log curr pkt and new chunk size

 drivers/net/loopback.c          |   5 +-
 include/linux/netdev_features.h |   7 +-
 include/linux/netdevice.h       |   1 +
 include/linux/skbuff.h          |   8 +
 include/net/sctp/sctp.h         |   4 +
 include/net/sctp/structs.h      |   5 +
 net/core/ethtool.c              |   1 +
 net/core/skbuff.c               |  42 ++++-
 net/ipv4/af_inet.c              |   1 +
 net/ipv4/ip_forward.c           |   2 +-
 net/ipv4/ip_output.c            |   2 +-
 net/ipv6/ip6_output.c           |   2 +-
 net/mpls/af_mpls.c              |   2 +-
 net/sctp/Makefile               |   3 +-
 net/sctp/input.c                |  57 ++++---
 net/sctp/inqueue.c              |  78 +++++++--
 net/sctp/offload.c              | 106 ++++++++++++
 net/sctp/output.c               | 366 +++++++++++++++++++++++++++-------------
 net/sctp/protocol.c             |   3 +
 net/sctp/socket.c               |   2 +
 20 files changed, 530 insertions(+), 167 deletions(-)
 create mode 100644 net/sctp/offload.c

-- 
2.5.5

