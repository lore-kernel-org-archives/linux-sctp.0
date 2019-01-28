From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:35 +0000
Subject: [PATCH net-next 13/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_DEFAULT_SEND_
Message-Id: <5d9d0bf635fb89cc3933b256e5e41dd3958c61d6.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
 <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
 <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
 <a6316f97dbdcfbde1104e2296df9d8b24958a7df.1548659198.git.lucien.xin@gmail.com>
 <17140f5cc5fc1961e3e7cf74888affd55e0e6c06.1548659198.git.lucien.xin@gmail.com>
 <ea9e2c6de0c242a440773e99e22a59a72b77776d.1548659198.git.lucien.xin@gmail.com>
 <33a798e9b29f2dcbe6dd132cb801b4960d1411a5.1548659198.git.lucien.xin@gmail.com>
 <d2e888e961165b773dfbf68847af5f2d0ac864c0.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <d2e888e961165b773dfbf68847af5f2d0ac864c0.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_default_send_param and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_default_send_param,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_DEFAULT_SEND_PARAM in this patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f72148d..3d3b4f0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3009,15 +3009,22 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
 		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && info.sinfo_assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
+
 	if (asoc) {
 		asoc->default_stream = info.sinfo_stream;
 		asoc->default_flags = info.sinfo_flags;
 		asoc->default_ppid = info.sinfo_ppid;
 		asoc->default_context = info.sinfo_context;
 		asoc->default_timetolive = info.sinfo_timetolive;
-	} else {
+
+		return 0;
+	}
+
+	if (info.sinfo_assoc_id = SCTP_FUTURE_ASSOC ||
+	    info.sinfo_assoc_id = SCTP_ALL_ASSOC) {
 		sp->default_stream = info.sinfo_stream;
 		sp->default_flags = info.sinfo_flags;
 		sp->default_ppid = info.sinfo_ppid;
@@ -3025,6 +3032,17 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
 		sp->default_timetolive = info.sinfo_timetolive;
 	}
 
+	if (info.sinfo_assoc_id = SCTP_CURRENT_ASSOC ||
+	    info.sinfo_assoc_id = SCTP_ALL_ASSOC) {
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
+			asoc->default_stream = info.sinfo_stream;
+			asoc->default_flags = info.sinfo_flags;
+			asoc->default_ppid = info.sinfo_ppid;
+			asoc->default_context = info.sinfo_context;
+			asoc->default_timetolive = info.sinfo_timetolive;
+		}
+	}
+
 	return 0;
 }
 
@@ -6223,8 +6241,10 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
 		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && info.sinfo_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
+
 	if (asoc) {
 		info.sinfo_stream = asoc->default_stream;
 		info.sinfo_flags = asoc->default_flags;
-- 
2.1.0
