From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 08:17:04 +0000
Subject: [PATCH 1/3] sctp: use transport to guess overhead  value of packet
Message-Id: <4C2DA080.8050101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Although the assoc is null, we can use af_specific of transport
to point to header size of IPv4 or IPv6.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index a646681..48177d3 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -127,7 +127,7 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
 		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
 		overhead = sp->pf->af->net_header_len;
 	} else {
-		overhead = sizeof(struct ipv6hdr);
+		overhead = transport->af_specific->net_header_len;
 	}
 	overhead += sizeof(struct sctphdr);
 	packet->overhead = overhead;
-- 
1.7.0
