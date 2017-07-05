From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 05 Jul 2017 00:32:22 +0000
Subject: [PATCH net-next 04/11] sctp: remove the typedef sctp_hostname_param_t
Message-Id: <8d2e6145478bb4d24185d4ffd5547c7058f0dca9.1499214692.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1499214692.git.lucien.xin@gmail.com>
 <6ba452f31d10acdc95f3cf679ecab15833f7843c.1499214692.git.lucien.xin@gmail.com>
 <77fa3a776118873a7e5d8203dd59011995b0e865.1499214692.git.lucien.xin@gmail.com>
 <090c24ed353f37a2bbce41ecc5feec6fc8cffa8b.1499214692.git.lucien.xin@gmail.com>
In-Reply-To: <090c24ed353f37a2bbce41ecc5feec6fc8cffa8b.1499214692.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Remove this typedef, there is even no places using it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index d8f9d8f..c43e906 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -291,10 +291,10 @@ struct sctp_cookie_preserve_param {
 };
 
 /* Section 3.3.2.1 Host Name Address (11) */
-typedef struct sctp_hostname_param {
+struct sctp_hostname_param {
 	struct sctp_paramhdr param_hdr;
 	uint8_t hostname[0];
-} sctp_hostname_param_t;
+};
 
 /* Section 3.3.2.1 Supported Address Types (12) */
 typedef struct sctp_supported_addrs_param {
-- 
2.1.0

