From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 05 Jul 2017 00:32:24 +0000
Subject: [PATCH net-next 06/11] sctp: remove struct sctp_ecn_capable_param
Message-Id: <f094b5d16ed0f3b6fa255462bf957a104584f220.1499214692.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1499214692.git.lucien.xin@gmail.com>
 <6ba452f31d10acdc95f3cf679ecab15833f7843c.1499214692.git.lucien.xin@gmail.com>
 <77fa3a776118873a7e5d8203dd59011995b0e865.1499214692.git.lucien.xin@gmail.com>
 <090c24ed353f37a2bbce41ecc5feec6fc8cffa8b.1499214692.git.lucien.xin@gmail.com>
 <8d2e6145478bb4d24185d4ffd5547c7058f0dca9.1499214692.git.lucien.xin@gmail.com>
 <951d998920ecfe28f690739cd311bca3060751ff.1499214692.git.lucien.xin@gmail.com>
In-Reply-To: <951d998920ecfe28f690739cd311bca3060751ff.1499214692.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Remove it, there is even no places using it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 3ca3ab7..7552482 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -302,11 +302,6 @@ struct sctp_supported_addrs_param {
 	__be16 types[0];
 };
 
-/* Appendix A. ECN Capable (32768) */
-typedef struct sctp_ecn_capable_param {
-	struct sctp_paramhdr param_hdr;
-} sctp_ecn_capable_param_t;
-
 /* ADDIP Section 3.2.6 Adaptation Layer Indication */
 typedef struct sctp_adaptation_ind_param {
 	struct sctp_paramhdr param_hdr;
-- 
2.1.0

