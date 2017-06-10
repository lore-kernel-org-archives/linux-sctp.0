From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2017 06:48:14 +0000
Subject: [PATCH net] sctp: disable BH in sctp_for_each_endpoint
Message-Id: <fc2c69db46c2dc7c877a54fc0b0917d99d0b7f0c.1497077294.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now sctp holds read_lock when foreach sctp_ep_hashtable without disabling
BH. If CPU schedules to another thread A at this moment, the thread A may
be trying to hold the write_lock with disabling BH.

As BH is disabled and CPU cannot schedule back to the thread holding the
read_lock, while the thread A keeps waiting for the read_lock. A dead
lock would be triggered by this.

This patch is to fix this dead lock by calling read_lock_bh instead to
disable BH when holding the read_lock in sctp_for_each_endpoint.

Fixes: 626d16f50f39 ("sctp: export some apis or variables for sctp_diag and reuse some for proc")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f16c8d9..30aa0a5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4622,13 +4622,13 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 
 	for (head = sctp_ep_hashtable; hash < sctp_ep_hashsize;
 	     hash++, head++) {
-		read_lock(&head->lock);
+		read_lock_bh(&head->lock);
 		sctp_for_each_hentry(epb, &head->chain) {
 			err = cb(sctp_ep(epb), p);
 			if (err)
 				break;
 		}
-		read_unlock(&head->lock);
+		read_unlock_bh(&head->lock);
 	}
 
 	return err;
-- 
2.1.0

