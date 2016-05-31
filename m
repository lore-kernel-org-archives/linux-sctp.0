From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 31 May 2016 18:55:50 +0000
Subject: [PATCH v2 7/7] sctp: improve debug message to also log curr pkt and new chunk size
Message-Id: <7de2dcb3ca0ba008f2b4b759c24ff2e26c71be13.1464718103.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1464718103.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1464718103.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Laight <David.Laight@ACULAB.COM>, Vlad Yasevich <vyasevich@gmail.com>, Alexander Duyck <alexander.duyck@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>

This is useful for debugging packet sizes.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Tested-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 60499a69179d255c47da1fa19b73147917a050bf..90d2e125c2f5e0e1ecb33a7eab10772e5b39567c 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -182,7 +182,8 @@ sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
 	sctp_xmit_t retval;
 	int error = 0;
 
-	pr_debug("%s: packet:%p chunk:%p\n", __func__, packet, chunk);
+	pr_debug("%s: packet:%p size:%lu chunk:%p size:%d\n", __func__,
+		 packet, packet->size, chunk, chunk->skb ? chunk->skb->len : -1);
 
 	switch ((retval = (sctp_packet_append_chunk(packet, chunk)))) {
 	case SCTP_XMIT_PMTU_FULL:
-- 
2.5.5

