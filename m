From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 22 Jul 2020 15:52:10 +0000
Subject: [PATCH net 0/2] sctp: shrink stream outq in the right place
Message-Id: <cover.1595433039.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Patch 1 is an improvement, and Patch 2 is a bug fix.

Xin Long (2):
  sctp: shrink stream outq only when new outcnt < old outcnt
  sctp: shrink stream outq when fails to do addstream reconf

 net/sctp/stream.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.1.0
