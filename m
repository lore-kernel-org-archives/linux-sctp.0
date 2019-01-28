From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:41 +0000
Subject: [PATCH net-next 19/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_AUTH_DELETE_K
Message-Id: <8cc9dcf9afe96c746c525943dd95d51a804f0126.1548659198.git.lucien.xin@gmail.com>
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
 <b4094ac0945bbea9ebe455b4357e983400bfe8bb.1548659198.git.lucien.xin@gmail.com>
 <4a601f978a5364fb8f5c4ee97e314eb28087917f.1548659198.git.lucien.xin@gmail.com>
 <1788c2da8ddb39854267ea1321d725635a7c983e.1548659198.git.lucien.xin@gmail.com>
 <70a401b7942eae75d2834dcbefe242f5eb4ad28d.1548659198.git.lucien.xin@gmail.com>
 <a87d5c204cc640751b70c7df7947f4d57a62ab69.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <a87d5c204cc640751b70c7df7947f4d57a62ab69.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_del_key.
SCTP_CURRENT_ASSOC is supported for SCTP_AUTH_DELETE_KEY in this patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3345eb1..c3463f7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3883,8 +3883,9 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 				   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
+	struct sctp_authkeyid val;
+	int ret = 0;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -3895,11 +3896,32 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	return sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+	if (asoc)
+		return sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
 
+	if (val.scact_assoc_id = SCTP_FUTURE_ASSOC ||
+	    val.scact_assoc_id = SCTP_ALL_ASSOC) {
+		ret = sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+		if (ret)
+			return ret;
+	}
+
+	if (val.scact_assoc_id = SCTP_CURRENT_ASSOC ||
+	    val.scact_assoc_id = SCTP_ALL_ASSOC) {
+		list_for_each_entry(asoc, &ep->asocs, asocs) {
+			int res = sctp_auth_del_key_id(ep, asoc,
+						       val.scact_keynumber);
+
+			if (res && !ret)
+				ret = res;
+		}
+	}
+
+	return ret;
 }
 
 /*
-- 
2.1.0
