From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 20 Mar 2017 09:46:27 +0000
Subject: [PATCH net] sctp: declare struct sctp_stream before using it
Message-Id: <1a16b414118d0876373774654d86e2a2a936b9d1.1490003187.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

sctp_stream_free uses struct sctp_stream as a param, but struct sctp_stream
is defined after it's declaration.

This patch is to declare struct sctp_stream before sctp_stream_free.

Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 4f64519..592dece 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -83,6 +83,7 @@ struct sctp_bind_addr;
 struct sctp_ulpq;
 struct sctp_ep_common;
 struct crypto_shash;
+struct sctp_stream;
 
 
 #include <net/sctp/tsnmap.h>
-- 
2.1.0

