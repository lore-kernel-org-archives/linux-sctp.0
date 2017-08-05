From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 05 Aug 2017 11:59:51 +0000
Subject: [PATCH net-next 01/14] sctp: remove the typedef sctp_lower_cwnd_t
Message-Id: <88e505f76dd927887d8cdcc7de2b82595237aa85.1501934087.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1501934086.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1501934086.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to remove the typedef sctp_lower_cwnd_t, and
replace with enum sctp_lower_cwnd in the places where it's
using this typedef.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h | 4 ++--
 include/net/sctp/structs.h   | 3 ++-
 net/sctp/transport.c         | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 9b18044..761064e 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -378,12 +378,12 @@ typedef enum {
 } sctp_retransmit_reason_t;
 
 /* Reasons to lower cwnd. */
-typedef enum {
+enum sctp_lower_cwnd {
 	SCTP_LOWER_CWND_T3_RTX,
 	SCTP_LOWER_CWND_FAST_RTX,
 	SCTP_LOWER_CWND_ECNE,
 	SCTP_LOWER_CWND_INACTIVE,
-} sctp_lower_cwnd_t;
+};
 
 
 /* SCTP-AUTH Necessary constants */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 66cd763..53802d8 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -950,7 +950,8 @@ int sctp_transport_hold(struct sctp_transport *);
 void sctp_transport_put(struct sctp_transport *);
 void sctp_transport_update_rto(struct sctp_transport *, __u32);
 void sctp_transport_raise_cwnd(struct sctp_transport *, __u32, __u32);
-void sctp_transport_lower_cwnd(struct sctp_transport *, sctp_lower_cwnd_t);
+void sctp_transport_lower_cwnd(struct sctp_transport *t,
+			       enum sctp_lower_cwnd reason);
 void sctp_transport_burst_limited(struct sctp_transport *);
 void sctp_transport_burst_reset(struct sctp_transport *);
 unsigned long sctp_transport_timeout(struct sctp_transport *);
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 80a97c8..2d9bd37 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -490,7 +490,7 @@ void sctp_transport_raise_cwnd(struct sctp_transport *transport,
  * detected.
  */
 void sctp_transport_lower_cwnd(struct sctp_transport *transport,
-			       sctp_lower_cwnd_t reason)
+			       enum sctp_lower_cwnd reason)
 {
 	struct sctp_association *asoc = transport->asoc;
 
-- 
2.1.0

