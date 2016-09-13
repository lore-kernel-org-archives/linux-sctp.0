From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Sep 2016 18:04:17 +0000
Subject: [PATCHv2 net 0/6] sctp: fix the transmit err process
Message-Id: <cover.1473789537.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

This patchset is to improve the transmit err process and also fix some
issues.

After this patchset, once the chunks are enqueued successfully, even
if the chunks fail to send out, no matter because of nodst or nomem,
no err retruns back to users any more. Instead, they are taken care
of by retransmit.

v1->v2:
  - add more details to the changelog in patch 1/6
  - add Fixes: tag in patch 2/6, 3/6
  - also revert 69b5777f2e57 in patch 3/6

Xin Long (6):
  sctp: remove the unnecessary state check in sctp_outq_tail
  sctp: do not return the transmit err back to sctp_sendmsg
  sctp: free msg->chunks when sctp_primitive_SEND return err
  sctp: save transmit error to sk_err in sctp_outq_flush
  sctp: make sctp_outq_flush/tail/uncork return void
  sctp: not return ENOMEM err back in sctp_packet_transmit

 include/net/sctp/structs.h |  5 +--
 net/sctp/chunk.c           | 13 +++++++
 net/sctp/output.c          | 50 +++++++++++++-------------
 net/sctp/outqueue.c        | 88 ++++++++++++++++------------------------------
 net/sctp/sm_sideeffect.c   | 25 +++++--------
 net/sctp/socket.c          |  8 +++--
 6 files changed, 85 insertions(+), 104 deletions(-)

-- 
2.1.0

