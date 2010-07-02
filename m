From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 08:17:24 +0000
Subject: [PATCH 2/3] sctp: export SctpT1Retransmits to /proc/net/sctp/snmp
Message-Id: <4C2DA094.3000601@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


SctpT1Retransmits is defined and counted, but is not exported
to snmp file.

We don't know if any user applications read this snmp file, so
we add it to he end of snmp file. This seems be more safe than
exporting it according to the definition in order.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 61aacfb..5584d1a 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -73,6 +73,7 @@ static const struct snmp_mib sctp_snmp_list[] = {
 	SNMP_MIB_ITEM("SctpInPktBacklog", SCTP_MIB_IN_PKT_BACKLOG),
 	SNMP_MIB_ITEM("SctpInPktDiscards", SCTP_MIB_IN_PKT_DISCARDS),
 	SNMP_MIB_ITEM("SctpInDataChunkDiscards", SCTP_MIB_IN_DATA_CHUNK_DISCARDS),
+	SNMP_MIB_ITEM("SctpT1Retransmits", SCTP_MIB_T1_RETRANSMITS),
 	SNMP_MIB_SENTINEL
 };
 
-- 
1.7.0
