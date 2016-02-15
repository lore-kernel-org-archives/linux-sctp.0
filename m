From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Feb 2016 06:28:03 +0000
Subject: [PATCH net 1/3] sctp: move rcu_read_lock from __sctp_lookup_association to sctp_lookup_association
Message-Id: <c805e4a1994f53947351e8d4dd79609fd206e807.1455517541.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1455517541.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1455517541.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

__sctp_lookup_association() is only invoked by sctp_v4_err() and
sctp_rcv(), both which run on the rx BH, and it has been protected
by rcu_read_lock [see ip_local_deliver_finish() / ipv6_rcv()].

So we can move it to sctp_lookup_association, only let
sctp_lookup_association use rcu_read_lock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 49d2cc7..21a2d6b 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -937,7 +937,6 @@ static struct sctp_association *__sctp_lookup_association(
 	struct sctp_transport *t;
 	struct sctp_association *asoc = NULL;
 
-	rcu_read_lock();
 	t = sctp_addrs_lookup_transport(net, local, peer);
 	if (!t || !sctp_transport_hold(t))
 		goto out;
@@ -949,7 +948,6 @@ static struct sctp_association *__sctp_lookup_association(
 	sctp_transport_put(t);
 
 out:
-	rcu_read_unlock();
 	return asoc;
 }
 
@@ -962,7 +960,9 @@ struct sctp_association *sctp_lookup_association(struct net *net,
 {
 	struct sctp_association *asoc;
 
+	rcu_read_lock();
 	asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
+	rcu_read_unlock();
 
 	return asoc;
 }
-- 
2.1.0

