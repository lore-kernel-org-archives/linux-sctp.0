From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 29 Apr 2018 15:56:30 +0000
Subject: [PATCH net-next 0/2] sctp: unify sctp_make_op_error_fixed and sctp_make_op_error_space
Message-Id: <cover.1525017179.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

These two variants are very close to each other and can be merged
to avoid code duplication. That's what this patchset does.

First, we allow sctp_init_cause to return errors, which then allow us to
add sctp_make_op_error_limited that handles both situations.

Marcelo Ricardo Leitner (2):
  sctp: allow sctp_init_cause to return errors
  sctp: add sctp_make_op_error_limited and reuse inner functions

 include/net/sctp/sm.h    |   2 +-
 net/sctp/sm_make_chunk.c | 134 ++++++++++++++++++-----------------------------
 2 files changed, 52 insertions(+), 84 deletions(-)

--
2.14.3

