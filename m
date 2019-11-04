From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 04 Nov 2019 05:16:24 +0000
Subject: [PATCH linux-4.14.y 0/2] sctp: fix a memory leak
Message-Id: <cover.1572844054.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org, gregkh@linuxfoundation.org

These 2 patches are missed in linux-4.14.y, it will cause crash
when commit 63dfb7938b13 ("sctp: change sctp_prot .no_autobind
with true") is backported only.

Conflicts:
  - Context difference in Patch 1/2 due to the lack of
    Commit c981f254cc82.

Xin Long (2):
  sctp: fix the issue that flags are ignored when using kernel_connect
  sctp: not bind the socket in sctp_connect

 include/net/sctp/sctp.h |  2 ++
 net/sctp/ipv6.c         |  2 +-
 net/sctp/protocol.c     |  2 +-
 net/sctp/socket.c       | 55 ++++++++++++++++++++++++++-----------------------
 4 files changed, 33 insertions(+), 28 deletions(-)

-- 
2.1.0
