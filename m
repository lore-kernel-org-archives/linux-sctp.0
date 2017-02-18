From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Feb 2017 17:52:44 +0000
Subject: [PATCH net-next 0/2] sctp: support MSG_MORE flag when sending msg
Message-Id: <cover.1487440272.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

This patch is to add support for MSG_MORE on sctp. Patch 1/2 is an
improvement ahead of patch 2/2 to solve the close block problem
mentioned in https://patchwork.ozlabs.org/patch/372404/.

Xin Long (2):
  sctp: flush out queue once assoc state falls into SHUTDOWN_PENDING
  sctp: add support for MSG_MORE

 include/net/sctp/structs.h | 1 +
 net/sctp/output.c          | 9 +++------
 net/sctp/sm_sideeffect.c   | 4 ++++
 net/sctp/socket.c          | 1 +
 4 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.1.0

