From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 22:21:43 +0000
Subject: [PATCH net-next v2 0/3] sctp: Introduce sctp_flush_ctx
Message-Id: <cover.1526142994.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

This struct will hold all the context used during the outq flush, so we
don't have to pass lots of pointers all around.

Checked on x86_64, the compiler inlines all these functions and there is no
derreference added because of the struct.

This patchset depends on 'sctp: refactor sctp_outq_flush'

Changes since v1:
- updated to build on top of v2 of 'sctp: refactor sctp_outq_flush'

Marcelo Ricardo Leitner (3):
  sctp: add sctp_flush_ctx, a context struct on outq_flush routines
  sctp: add asoc and packet to sctp_flush_ctx
  sctp: checkpatch fixups

 net/sctp/outqueue.c | 259 ++++++++++++++++++++++++----------------------------
 1 file changed, 119 insertions(+), 140 deletions(-)

--
2.14.3
