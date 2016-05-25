From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 May 2016 19:14:28 +0000
Subject: [PATCH net] sctp: sctp_diag should dump sctp socket type
Message-Id: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, phil@nwl.cc

Now we cannot distinguish that one sk is a udp or sctp style when
we use ss to dump sctp_info. it's necessary to dump it as well.

For sctp_diag, ss support is not officially available, thus there
are no official users of this yet, so we can add this field in the
middle of sctp_info without breaking user API.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 1 +
 net/sctp/socket.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index dacb5e7..3a406af 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -761,6 +761,7 @@ struct sctp_info {
 	__u32	sctpi_s_autoclose;
 	__u32	sctpi_s_adaptation_ind;
 	__u32	sctpi_s_pd_point;
+	__u32	sctpi_s_type;
 	__u8	sctpi_s_nodelay;
 	__u8	sctpi_s_disable_fragments;
 	__u8	sctpi_s_v4mapped;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 777d032..ebb8e41 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4216,6 +4216,7 @@ int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 		info->sctpi_s_autoclose = sp->autoclose;
 		info->sctpi_s_adaptation_ind = sp->adaptation_ind;
 		info->sctpi_s_pd_point = sp->pd_point;
+		info->sctpi_s_type = sp->type;
 		info->sctpi_s_nodelay = sp->nodelay;
 		info->sctpi_s_disable_fragments = sp->disable_fragments;
 		info->sctpi_s_v4mapped = sp->v4mapped;
-- 
2.1.0

