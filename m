From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 09 Sep 2019 07:56:51 +0000
Subject: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
 <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
 <4836d0d8bb96e807b63f46e6c59af78b9b3e286b.1568015756.git.lucien.xin@gmail.com>
 <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
added to allow a user to change ps_retrans per sock/asoc/transport, as
other 2 paddrthlds: pf_retrans, pathmaxrxt.

Note that ps_retrans is not allowed to be greater than pf_retrans.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a15cc28..dfd81e1 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
 	struct sockaddr_storage spt_address;
 	__u16 spt_pathmaxrxt;
 	__u16 spt_pathpfthld;
+	__u16 spt_pathcpthld;
 };
 
 /*
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5e2098b..5b9774d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			   sizeof(struct sctp_paddrthlds)))
 		return -EFAULT;
 
+	if (val.spt_pathpfthld > val.spt_pathcpthld)
+		return -EINVAL;
+
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
 					       val.spt_assoc_id);
@@ -3963,6 +3966,7 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 		if (val.spt_pathmaxrxt)
 			trans->pathmaxrxt = val.spt_pathmaxrxt;
 		trans->pf_retrans = val.spt_pathpfthld;
+		trans->ps_retrans = val.spt_pathcpthld;
 
 		return 0;
 	}
@@ -3978,17 +3982,20 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			if (val.spt_pathmaxrxt)
 				trans->pathmaxrxt = val.spt_pathmaxrxt;
 			trans->pf_retrans = val.spt_pathpfthld;
+			trans->ps_retrans = val.spt_pathcpthld;
 		}
 
 		if (val.spt_pathmaxrxt)
 			asoc->pathmaxrxt = val.spt_pathmaxrxt;
 		asoc->pf_retrans = val.spt_pathpfthld;
+		asoc->ps_retrans = val.spt_pathcpthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		if (val.spt_pathmaxrxt)
 			sp->pathmaxrxt = val.spt_pathmaxrxt;
 		sp->pf_retrans = val.spt_pathpfthld;
+		sp->ps_retrans = val.spt_pathcpthld;
 	}
 
 	return 0;
@@ -7232,6 +7239,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		if (!trans)
 			return -ENOENT;
 
+		val.spt_pathcpthld = trans->ps_retrans;
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
 
@@ -7244,11 +7252,13 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		return -EINVAL;
 
 	if (asoc) {
+		val.spt_pathcpthld = asoc->ps_retrans;
 		val.spt_pathpfthld = asoc->pf_retrans;
 		val.spt_pathmaxrxt = asoc->pathmaxrxt;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
+		val.spt_pathcpthld = sp->ps_retrans;
 		val.spt_pathpfthld = sp->pf_retrans;
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
-- 
2.1.0
