From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 19 Apr 2013 07:59:37 +0000
Subject: [PATCH net-next] net: sctp: minor: remove dead code from sctp_packet
Message-Id: <1366358377-7623-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

struct sctp_packet is currently embedded into sctp_transport or
sits on the stack as 'singleton' in sctp_outq_flush(). Therefore,
its member 'malloced' is always 0, thus a kfree() is never called.
Because of that, we can just remove this code.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 That is finally the last one of all these cases to get rid of
 'malloced' structure members.

 include/net/sctp/structs.h | 3 +--
 net/sctp/output.c          | 5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 64d4698..1bd4c41 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -714,8 +714,7 @@ struct sctp_packet {
 	    has_sack:1,		/* This packet contains a SACK chunk. */
 	    has_auth:1,		/* This packet contains an AUTH chunk */
 	    has_data:1,		/* This packet contains at least 1 DATA chunk */
-	    ipfragok:1,		/* So let ip fragment this packet */
-	    malloced:1;		/* Is it malloced? */
+	    ipfragok:1;		/* So let ip fragment this packet */
 };
 
 struct sctp_packet *sctp_packet_init(struct sctp_packet *,
diff --git a/net/sctp/output.c b/net/sctp/output.c
index f5200a2..bbef4a7 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -136,7 +136,7 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
 	packet->overhead = overhead;
 	sctp_packet_reset(packet);
 	packet->vtag = 0;
-	packet->malloced = 0;
+
 	return packet;
 }
 
@@ -151,9 +151,6 @@ void sctp_packet_free(struct sctp_packet *packet)
 		list_del_init(&chunk->list);
 		sctp_chunk_free(chunk);
 	}
-
-	if (packet->malloced)
-		kfree(packet);
 }
 
 /* This routine tries to append the chunk to the offered packet. If adding
-- 
1.7.11.7

