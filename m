From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 08:17:38 +0000
Subject: [PATCH 3/3] sctp: add heartbeat expired counter to /proc/net/sctp/snmp
Message-Id: <4C2DA0A2.6070201@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Just like T4-RTO, T3-RXT timeout events, add HEARTBEAT timeout
counter for debug. It is useful because all these timeout events
cause association error counter to increase.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 include/net/sctp/sctp.h |    1 +
 net/sctp/proc.c         |    1 +
 net/sctp/sm_statefuns.c |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 65946bc..f7fb5de 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -263,6 +263,7 @@ enum {
 	SCTP_MIB_IN_PKT_BACKLOG,
 	SCTP_MIB_IN_PKT_DISCARDS,
 	SCTP_MIB_IN_DATA_CHUNK_DISCARDS,
+	SCTP_MIB_HEARTBEAT_EXPIREDS,
 	__SCTP_MIB_MAX
 };
 
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 5584d1a..53263ca 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -74,6 +74,7 @@ static const struct snmp_mib sctp_snmp_list[] = {
 	SNMP_MIB_ITEM("SctpInPktDiscards", SCTP_MIB_IN_PKT_DISCARDS),
 	SNMP_MIB_ITEM("SctpInDataChunkDiscards", SCTP_MIB_IN_DATA_CHUNK_DISCARDS),
 	SNMP_MIB_ITEM("SctpT1Retransmits", SCTP_MIB_T1_RETRANSMITS),
+	SNMP_MIB_ITEM("SctpHeartbeatExpireds", SCTP_MIB_HEARTBEAT_EXPIREDS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..8d3e223 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -974,6 +974,8 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 {
 	struct sctp_transport *transport = (struct sctp_transport *) arg;
 
+	SCTP_INC_STATS(SCTP_MIB_HEARTBEAT_EXPIREDS);
+
 	if (asoc->overall_error_count >= asoc->max_retrans) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
 				SCTP_ERROR(ETIMEDOUT));
-- 
1.7.0
