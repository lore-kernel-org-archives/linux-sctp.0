From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 09 Jul 2016 11:47:39 +0000
Subject: [PATCH net-next 0/6] sctp: implement rfc7496 in sctp
Message-Id: <cover.1468064737.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

This patchset implements "Additional Policies for the Partially Reliable
Stream Control Transmission Protocol Extension" described on RFC7496.

The Partially Reliable SCTP (PR-SCTP) extension defined in [RFC3758]
provides a generic method for senders to abandon user messages. The
decision to abandon a user message is sender side only, and the exact
condition is called a "PR-SCTP policy". This patchset implements 3
policies:

 1. Timed Reliability:  This allows the sender to specify a timeout for
    a user message after which the SCTP stack abandons the user message.

 2. Limited Retransmission Policy:  Allows limitation of the number of
    retransmissions.

 3. Priority Policy:  Allows removal of lower-priority messages if space
    for higher-priority messages is needed in the send buffer.

Patch 1-3 add some sockopts in sctp to set/get pr_sctp policy status.
Patch 4-6 implement these 3 policies one by one.

Xin Long (6):
  sctp: add SCTP_PR_SUPPORTED on sctp sockopt
  sctp: add SCTP_DEFAULT_PRINFO into sctp sockopt
  sctp: add SCTP_PR_ASSOC_STATUS on sctp sockopt
  sctp: implement prsctp TTL policy
  sctp: implement prsctp RTX policy
  sctp: implement prsctp PRIO policy

 include/net/sctp/structs.h |  23 ++++-
 include/uapi/linux/sctp.h  |  42 ++++++++
 net/sctp/associola.c       |   1 +
 net/sctp/chunk.c           |  25 ++++-
 net/sctp/endpointola.c     |   1 +
 net/sctp/output.c          |   2 +
 net/sctp/outqueue.c        |  99 +++++++++++++++++++
 net/sctp/sm_make_chunk.c   |  27 +++--
 net/sctp/socket.c          | 240 ++++++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 447 insertions(+), 13 deletions(-)

-- 
2.1.0

