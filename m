From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 11 Aug 2017 02:23:45 +0000
Subject: [PATCH net-next 01/14] sctp: remove the unused typedef sctp_packet_phandler_t
Message-Id: <e15322cc52e110730f2bcb77973222b687717369.1502417340.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1502417340.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1502417340.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Remove this function typedef, there is even no places
using it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index fbe6e81..73e9509 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -657,8 +657,6 @@ struct sctp_sockaddr_entry {
 
 #define SCTP_ADDRESS_TICK_DELAY	500
 
-typedef struct sctp_chunk *(sctp_packet_phandler_t)(struct sctp_association *);
-
 /* This structure holds lists of chunks as we are assembling for
  * transmission.
  */
-- 
2.1.0

