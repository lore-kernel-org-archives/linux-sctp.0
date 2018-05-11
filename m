From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 11 May 2018 23:28:07 +0000
Subject: [PATCH net-next 0/8] sctp: refactor sctp_outq_flush
Message-Id: <cover.1526077476.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

Currently sctp_outq_flush does many different things and arguably
unrelated, such as doing transport selection and outq dequeueing.

This patchset refactors it into smaller and more dedicated functions.
The end behavior should be the same.

The next patchset will rework the function parameters.

Marcelo Ricardo Leitner (8):
  sctp: add sctp_packet_singleton
  sctp: factor out sctp_outq_select_transport
  sctp: move the flush of ctrl chunks into its own function
  sctp: move outq data rtx code out of sctp_outq_flush
  sctp: move flushing of data chunks out of sctp_outq_flush
  sctp: move transport flush code out of sctp_outq_flush
  sctp: make use of gfp on retransmissions
  sctp: rework switch cases in sctp_outq_flush_data

 net/sctp/outqueue.c | 593 +++++++++++++++++++++++++++-------------------------
 1 file changed, 311 insertions(+), 282 deletions(-)

--
2.14.3
