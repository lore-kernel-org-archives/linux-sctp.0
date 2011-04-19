From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 05:07:55 +0000
Subject: [PATCH net-next-2.6 0/8] sctp: some cleanup and tiny fix for add/del
Message-Id: <4DAD18AB.3040401@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

Series of 8 patches against net-next-2.6, include some cleanup
and tiny fix for add/del ip, which have been waiting on vlad's
lksctp-dev tree for long times.

Shan Wei (5):
      sctp: delete unused macro definition of sctp_chunk_is_control
      sctp: fix the comment of sctp_sf_violation_paramlen()
      sctp: use common head of addr parameter to access member in addr-unrelated code
      sctp: kill abandoned SCTP_CMD_TRANSMIT command
      sctp: use memdup_user to copy data from userspace

Vlad Yasevich (3):
      sctp: teach CACC algorithm about removed transports
      sctp: Allow bindx_del to accept 0 port.
      sctp: Release all routes when processing acks ADD_IP or DEL_IP

 include/net/sctp/command.h   |    1 -
 include/net/sctp/constants.h |    1 -
 net/sctp/input.c             |    2 +-
 net/sctp/outqueue.c          |   11 ++++++++---
 net/sctp/sm_make_chunk.c     |   18 +++++++-----------
 net/sctp/sm_sideeffect.c     |    6 ------
 net/sctp/sm_statefuns.c      |    5 +++--
 net/sctp/socket.c            |   28 +++++++++++-----------------
 8 files changed, 30 insertions(+), 42 deletions(-)


