From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 17:35:17 +0000
Subject: [PATCH net-next v3 0/3] sctp: Introduce sctp_flush_ctx
Message-Id: <cover.1526319083.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

This struct will hold all the context used during the outq flush, so we
don't have to pass lots of pointers all around.

Checked on x86_64, the compiler inlines all these functions and there is no
derreference added because of the struct.

This patchset depends on 'sctp: refactor sctp_outq_flush'

Changes since v1:
- updated to build on top of v2 of 'sctp: refactor sctp_outq_flush'

Changes since v2:
- fixed a rebase issue which reverted a change in patch 2.
- rebased on v3 of 'sctp: refactor sctp_outq_flush'

Marcelo Ricardo Leitner (3):
  sctp: add sctp_flush_ctx, a context struct on outq_flush routines
  sctp: add asoc and packet to sctp_flush_ctx
  sctp: checkpatch fixups

 net/sctp/outqueue.c | 257 ++++++++++++++++++++++++----------------------------
 1 file changed, 118 insertions(+), 139 deletions(-)

--
2.14.3

