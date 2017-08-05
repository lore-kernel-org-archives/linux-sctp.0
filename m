From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 05 Aug 2017 11:59:50 +0000
Subject: [PATCH net-next 00/14] sctp: remove typedefs from structures part 5
Message-Id: <cover.1501934086.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1501745729.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1501745729.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

As we know, typedef is suggested not to use in kernel, even checkpatch.pl
also gives warnings about it. Now sctp is using it for many structures.

All this kind of typedef's using should be removed. This patchset is the
part 5 to remove all typedefs in include/net/sctp/constants.h.

Just as the part 1-4, No any code's logic would be changed in these patches,
only cleaning up.

Xin Long (14):
  sctp: remove the typedef sctp_lower_cwnd_t
  sctp: remove the typedef sctp_retransmit_reason_t
  sctp: remove the typedef sctp_scope_policy_t
  sctp: remove the typedef sctp_scope_t
  sctp: remove the typedef sctp_transport_cmd_t
  sctp: remove the typedef sctp_sock_state_t
  sctp: remove the typedef sctp_xmit_t
  sctp: remove the typedef sctp_ierror_t
  sctp: remove the typedef sctp_state_t
  sctp: remove the typedef sctp_event_primitive_t
  sctp: remove the typedef sctp_event_other_t
  sctp: remove the typedef sctp_event_timeout_t
  sctp: remove the typedef sctp_event_t
  sctp: remove the typedef sctp_subtype_t

 include/net/sctp/command.h   |   8 +-
 include/net/sctp/constants.h |  89 +++++++++---------
 include/net/sctp/sctp.h      |   9 +-
 include/net/sctp/sm.h        |  21 ++---
 include/net/sctp/structs.h   |  42 +++++----
 net/sctp/associola.c         |  21 ++---
 net/sctp/bind_addr.c         |  20 ++--
 net/sctp/debug.c             |   8 +-
 net/sctp/endpointola.c       |   4 +-
 net/sctp/ipv6.c              |   6 +-
 net/sctp/output.c            |  60 ++++++------
 net/sctp/outqueue.c          |  10 +-
 net/sctp/primitive.c         |   4 +-
 net/sctp/probe.c             |   2 +-
 net/sctp/protocol.c          |   6 +-
 net/sctp/sm_make_chunk.c     |  29 +++---
 net/sctp/sm_sideeffect.c     |  46 ++++-----
 net/sctp/sm_statefuns.c      | 215 ++++++++++++++++++++++---------------------
 net/sctp/sm_statetable.c     |  23 +++--
 net/sctp/socket.c            |   4 +-
 net/sctp/sysctl.c            |   2 +-
 net/sctp/transport.c         |   2 +-
 22 files changed, 320 insertions(+), 311 deletions(-)

-- 
2.1.0

