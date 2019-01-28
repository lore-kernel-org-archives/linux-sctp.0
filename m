From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:36 +0000
Subject: [PATCH net-next 14/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_DEFAULT_SNDIN
Message-Id: <b4094ac0945bbea9ebe455b4357e983400bfe8bb.1548659198.git.lucien.xin@gmail.com>
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
 <5d9d0bf635fb89cc3933b256e5e41dd3958c61d6.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <5d9d0bf635fb89cc3933b256e5e41dd3958c61d6.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_default_sndinfo and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_default_sndinfo,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_DEFAULT_SNDINFO in this patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3d3b4f0..6a674cf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3067,20 +3067,37 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
 		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && info.snd_assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
+
 	if (asoc) {
 		asoc->default_stream = info.snd_sid;
 		asoc->default_flags = info.snd_flags;
 		asoc->default_ppid = info.snd_ppid;
 		asoc->default_context = info.snd_context;
-	} else {
+
+		return 0;
+	}
+
+	if (info.snd_assoc_id = SCTP_FUTURE_ASSOC ||
+	    info.snd_assoc_id = SCTP_ALL_ASSOC) {
 		sp->default_stream = info.snd_sid;
 		sp->default_flags = info.snd_flags;
 		sp->default_ppid = info.snd_ppid;
 		sp->default_context = info.snd_context;
 	}
 
+	if (info.snd_assoc_id = SCTP_CURRENT_ASSOC ||
+	    info.snd_assoc_id = SCTP_ALL_ASSOC) {
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
+			asoc->default_stream = info.snd_sid;
+			asoc->default_flags = info.snd_flags;
+			asoc->default_ppid = info.snd_ppid;
+			asoc->default_context = info.snd_context;
+		}
+	}
+
 	return 0;
 }
 
@@ -6287,8 +6304,10 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
 		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && info.snd_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
+
 	if (asoc) {
 		info.snd_sid = asoc->default_stream;
 		info.snd_flags = asoc->default_flags;
-- 
2.1.0
