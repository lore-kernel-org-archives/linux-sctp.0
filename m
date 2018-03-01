From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:17 +0000
Subject: [PATCH net-next 8/9] sctp: improve some variables in sctp_sendmsg
Message-Id: <7dae2617b0b09ee14bb8509a455d32b3d73c9cb0.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
 <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
 <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
 <ea4722d28716a0f98826a7853e1eb7c5f4d53ca9.1519916440.git.lucien.xin@gmail.com>
 <45d67b278e2b79a28295148582e2fd22c1f45b57.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <45d67b278e2b79a28295148582e2fd22c1f45b57.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch mostly is to:

  - rename sinfo_flags as sflags, to make the indents look better, and
    also keep consistent with other sctp_sendmsg_xx functions.

  - replace new_asoc with bool new, no need to define a pointer here,
    as if new_asoc is set, it must be asoc.

  - rename the 'out_nounlock:' as 'out', shorter and nicer.

  - remove associd, only one place is using it now, just use
    sinfo->sinfo_assoc_id directly.

  - remove 'cmsgs' initialization in sctp_sendmsg, as it will be done
    in sctp_sendmsg_parse.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4260310..a1c78fc1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1910,28 +1910,28 @@ static void sctp_sendmsg_update_sinfo(struct sctp_association *asoc,
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_association *new_asoc = NULL, *asoc = NULL;
 	struct sctp_transport *transport = NULL;
 	struct sctp_sndrcvinfo _sinfo, *sinfo;
-	sctp_assoc_t associd = 0;
-	struct sctp_cmsgs cmsgs = { NULL };
-	__u16 sinfo_flags = 0;
+	struct sctp_association *asoc;
+	struct sctp_cmsgs cmsgs;
 	union sctp_addr *daddr;
+	bool new = false;
+	__u16 sflags;
 	int err;
 
 	/* Parse and get snd_info */
 	err = sctp_sendmsg_parse(sk, &cmsgs, &_sinfo, msg, msg_len);
 	if (err)
-		goto out_nounlock;
+		goto out;
 
 	sinfo  = &_sinfo;
-	sinfo_flags = sinfo->sinfo_flags;
+	sflags = sinfo->sinfo_flags;
 
 	/* Get daddr from msg */
 	daddr = sctp_sendmsg_get_daddr(sk, msg, &cmsgs);
 	if (IS_ERR(daddr)) {
 		err = PTR_ERR(daddr);
-		goto out_nounlock;
+		goto out;
 	}
 
 	lock_sock(sk);
@@ -1941,7 +1941,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		/* Look for a matching association on the endpoint. */
 		asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
 	} else {
-		asoc = sctp_id2assoc(sk, associd);
+		asoc = sctp_id2assoc(sk, sinfo->sinfo_assoc_id);
 		if (!asoc) {
 			err = -EPIPE;
 			goto out_unlock;
@@ -1949,24 +1949,23 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	}
 
 	if (asoc) {
-		err = sctp_sendmsg_check_sflags(asoc, sinfo_flags, msg,
-						msg_len);
+		err = sctp_sendmsg_check_sflags(asoc, sflags, msg, msg_len);
 		if (err <= 0)
 			goto out_unlock;
 	}
 
 	/* Do we need to create the association?  */
 	if (!asoc) {
-		err = sctp_sendmsg_new_asoc(sk, sinfo_flags, &cmsgs, daddr,
+		err = sctp_sendmsg_new_asoc(sk, sflags, &cmsgs, daddr,
 					    &transport);
 		if (err)
 			goto out_unlock;
 
 		asoc = transport->asoc;
-		new_asoc = asoc;
+		new = true;
 	}
 
-	if (!sctp_style(sk, TCP) && !(sinfo_flags & SCTP_ADDR_OVER))
+	if (!sctp_style(sk, TCP) && !(sflags & SCTP_ADDR_OVER))
 		transport = NULL;
 
 	/* Update snd_info with the asoc */
@@ -1974,12 +1973,12 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	/* Send msg to the asoc */
 	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
-	if (err < 0 && err != -ESRCH && new_asoc)
+	if (err < 0 && err != -ESRCH && new)
 		sctp_association_free(asoc);
 
 out_unlock:
 	release_sock(sk);
-out_nounlock:
+out:
 	return sctp_error(sk, msg->msg_flags, err);
 }
 
-- 
2.1.0

