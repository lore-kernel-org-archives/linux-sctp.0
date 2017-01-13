From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 13 Jan 2017 20:27:33 +0000
Subject: [PATCH net-next] sctp: remove unused var from sctp_process_asconf
Message-Id: <5da2cda90a7489b22ae98703d7543c5316bae375.1484336552.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Assigned but not used.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_make_chunk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index a15d824a313d310ed03ba77055d22b1c7c9d0662..80a9088084ac0d1116bf983fad9a0cdfddeefe44 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3210,7 +3210,6 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 	union sctp_params param;
 	sctp_addiphdr_t		*hdr;
 	union sctp_addr_param	*addr_param;
-	sctp_addip_param_t	*asconf_param;
 	struct sctp_chunk	*asconf_ack;
 	__be16	err_code;
 	int	length = 0;
@@ -3230,7 +3229,6 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 	 * asconf parameter.
 	 */
 	length = ntohs(addr_param->p.length);
-	asconf_param = (void *)addr_param + length;
 	chunk_len -= length;
 
 	/* create an ASCONF_ACK chunk.
-- 
2.9.3

