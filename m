From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:18 +0000
Subject: [PATCH net-next 9/9] sctp: adjust some codes in a better order in sctp_sendmsg
Message-Id: <777c34d435febfa0d708a4f748b4894d1cc89c77.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
 <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
 <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
 <ea4722d28716a0f98826a7853e1eb7c5f4d53ca9.1519916440.git.lucien.xin@gmail.com>
 <45d67b278e2b79a28295148582e2fd22c1f45b57.1519916440.git.lucien.xin@gmail.com>
 <7dae2617b0b09ee14bb8509a455d32b3d73c9cb0.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <7dae2617b0b09ee14bb8509a455d32b3d73c9cb0.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_sendmsg_new_asoc and SCTP_ADDR_OVER check is only necessary
when daddr is set, so move them up to if (daddr) statement.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a1c78fc1..7fa7603 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1936,38 +1936,38 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	lock_sock(sk);
 
-	/* If a msg_name has been specified, assume this is to be used.  */
+	/* Get and check or create asoc */
 	if (daddr) {
-		/* Look for a matching association on the endpoint. */
 		asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
+		if (asoc) {
+			err = sctp_sendmsg_check_sflags(asoc, sflags, msg,
+							msg_len);
+			if (err <= 0)
+				goto out_unlock;
+		} else {
+			err = sctp_sendmsg_new_asoc(sk, sflags, &cmsgs, daddr,
+						    &transport);
+			if (err)
+				goto out_unlock;
+
+			asoc = transport->asoc;
+			new = true;
+		}
+
+		if (!sctp_style(sk, TCP) && !(sflags & SCTP_ADDR_OVER))
+			transport = NULL;
 	} else {
 		asoc = sctp_id2assoc(sk, sinfo->sinfo_assoc_id);
 		if (!asoc) {
 			err = -EPIPE;
 			goto out_unlock;
 		}
-	}
 
-	if (asoc) {
 		err = sctp_sendmsg_check_sflags(asoc, sflags, msg, msg_len);
 		if (err <= 0)
 			goto out_unlock;
 	}
 
-	/* Do we need to create the association?  */
-	if (!asoc) {
-		err = sctp_sendmsg_new_asoc(sk, sflags, &cmsgs, daddr,
-					    &transport);
-		if (err)
-			goto out_unlock;
-
-		asoc = transport->asoc;
-		new = true;
-	}
-
-	if (!sctp_style(sk, TCP) && !(sflags & SCTP_ADDR_OVER))
-		transport = NULL;
-
 	/* Update snd_info with the asoc */
 	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
 
-- 
2.1.0

