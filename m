From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:15 +0000
Subject: [PATCH net-next 6/9] sctp: factor out sctp_sendmsg_update_sinfo from sctp_sendmsg
Message-Id: <ea4722d28716a0f98826a7853e1eb7c5f4d53ca9.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
 <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
 <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for trying to get sinfo from
asoc into sctp_sendmsg_update_sinfo.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf089e5..bd1a657 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1892,6 +1892,21 @@ static union sctp_addr *sctp_sendmsg_get_daddr(struct sock *sk,
 	return daddr;
 }
 
+static void sctp_sendmsg_update_sinfo(struct sctp_association *asoc,
+				      struct sctp_sndrcvinfo *sinfo,
+				      struct sctp_cmsgs *cmsgs)
+{
+	if (!cmsgs->srinfo && !cmsgs->sinfo) {
+		sinfo->sinfo_stream = asoc->default_stream;
+		sinfo->sinfo_ppid = asoc->default_ppid;
+		sinfo->sinfo_context = asoc->default_context;
+		sinfo->sinfo_assoc_id = sctp_assoc2id(asoc);
+	}
+
+	if (!cmsgs->srinfo)
+		sinfo->sinfo_timetolive = asoc->default_timetolive;
+}
+
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
@@ -1951,15 +1966,8 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		new_asoc = asoc;
 	}
 
-	if (!cmsgs.srinfo && !cmsgs.sinfo) {
-		sinfo->sinfo_stream = asoc->default_stream;
-		sinfo->sinfo_ppid = asoc->default_ppid;
-		sinfo->sinfo_context = asoc->default_context;
-		sinfo->sinfo_assoc_id = sctp_assoc2id(asoc);
-	}
-
-	if (!cmsgs.srinfo)
-		sinfo->sinfo_timetolive = asoc->default_timetolive;
+	/* Update snd_info with the asoc */
+	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
 
 	/* If an address is passed with the sendto/sendmsg call, it is used
 	 * to override the primary destination address in the TCP model, or
-- 
2.1.0

