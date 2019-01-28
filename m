From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:23 +0000
Subject: [PATCH net-next 01/24] sctp: introduce SCTP_FUTURE/CURRENT/ALL_ASSOC
Message-Id: <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to add 3 constants SCTP_FUTURE_ASSOC,
SCTP_CURRENT_ASSOC and SCTP_ALL_ASSOC for reserved
assoc_ids, as defined in rfc6458#section-7.2.

And add the process for them when doing lookup and
inserting in sctp_id2assoc and sctp_assoc_set_id.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h | 4 ++++
 net/sctp/associola.c      | 7 +++++--
 net/sctp/socket.c         | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index d584073..b8f2c4d 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -59,6 +59,10 @@
 
 typedef __s32 sctp_assoc_t;
 
+#define SCTP_FUTURE_ASSOC	0
+#define SCTP_CURRENT_ASSOC	1
+#define SCTP_ALL_ASSOC		2
+
 /* The following symbols come from the Sockets API Extensions for
  * SCTP <draft-ietf-tsvwg-sctpsocket-07.txt>.
  */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 201c888..b99f163 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1651,8 +1651,11 @@ int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 	if (preload)
 		idr_preload(gfp);
 	spin_lock_bh(&sctp_assocs_id_lock);
-	/* 0 is not a valid assoc_id, must be >= 1 */
-	ret = idr_alloc_cyclic(&sctp_assocs_id, asoc, 1, 0, GFP_NOWAIT);
+	/* 0, 1, 2 are used as SCTP_FUTURE_ASSOC, SCTP_CURRENT_ASSOC and
+	 * SCTP_ALL_ASSOC, so an available id must be > SCTP_ALL_ASSOC.
+	 */
+	ret = idr_alloc_cyclic(&sctp_assocs_id, asoc, SCTP_ALL_ASSOC + 1, 0,
+			       GFP_NOWAIT);
 	spin_unlock_bh(&sctp_assocs_id_lock);
 	if (preload)
 		idr_preload_end();
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f93c3cf..a52d132 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -248,7 +248,7 @@ struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id)
 	}
 
 	/* Otherwise this is a UDP-style socket. */
-	if (!id || (id = (sctp_assoc_t)-1))
+	if (id <= SCTP_ALL_ASSOC)
 		return NULL;
 
 	spin_lock_bh(&sctp_assocs_id_lock);
-- 
2.1.0
