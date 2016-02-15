From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Feb 2016 06:28:02 +0000
Subject: [PATCH net 0/3] sctp: some cleanups for sctp
Message-Id: <cover.1455517541.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

There are some unused function and redundant rcu locks should be
removed.

Xin Long (3):
  sctp: move rcu_read_lock from __sctp_lookup_association to
    sctp_lookup_association
  sctp: remove rcu_read_lock in sctp_seq_dump_remote_addrs()
  sctp: remove the unused sctp_datamsg_free()

 include/net/sctp/structs.h |  1 -
 net/sctp/chunk.c           | 13 -------------
 net/sctp/input.c           |  4 ++--
 net/sctp/proc.c            |  2 --
 4 files changed, 2 insertions(+), 18 deletions(-)

-- 
2.1.0

