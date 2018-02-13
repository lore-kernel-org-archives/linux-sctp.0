From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Feb 2018 11:33:19 +0000
Subject: [PATCHv2 net 0/2] sctp: rename sctp diag file and add file comments for it
Message-Id: <cover.1518521415.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patchset is to remove the sctp_ prefix for sctp diag file,
and also to add the missing file comments for it.

v1->v2:
  split them into two patches as Marcelo suggested.

Xin Long (2):
  sctp: rename sctp_diag.c as diag.c
  sctp: add file comments in diag.c

 net/sctp/Makefile    |   2 +
 net/sctp/diag.c      | 557 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/sctp/sctp_diag.c | 526 ------------------------------------------------
 3 files changed, 559 insertions(+), 526 deletions(-)
 create mode 100644 net/sctp/diag.c
 delete mode 100644 net/sctp/sctp_diag.c

-- 
2.1.0

