From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 26 May 2010 09:51:17 +0000
Subject: [PATCH 2/4] sctp: use common head of addr parameter to access member
Message-Id: <4BFCEF15.2060508@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


The 'p' member of struct sctp_paramhdr is common part for
IPv4 addr parameter and IPv6 addr parameter in union sctp_addr_param.

For addr-related code, use specified addr parameter.
Otherwise, use common header to access type/length member.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/input.c         |    2 +-
 net/sctp/sm_make_chunk.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9b1dde5..ad3466a 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1011,7 +1011,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 
-	af = sctp_get_af_specific(param_type2af(param->v4.param_hdr.type));
+	af = sctp_get_af_specific(param_type2af(param->p.type));
 	if (unlikely(!af))
 		return NULL;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d8261f3..e04a3c1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2921,7 +2921,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	    asconf_param->param_hdr.type != SCTP_PARAM_SET_PRIMARY)
 		return SCTP_ERROR_UNKNOWN_PARAM;
 
-	switch (addr_param->v4.param_hdr.type) {
+	switch (addr_param->p.type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
 		if (!asoc->peer.ipv6_address)
 			return SCTP_ERROR_DNS_FAILED;
@@ -2934,7 +2934,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		return SCTP_ERROR_DNS_FAILED;
 	}
 
-	af = sctp_get_af_specific(param_type2af(addr_param->v4.param_hdr.type));
+	af = sctp_get_af_specific(param_type2af(addr_param->p.type));
 	if (unlikely(!af))
 		return SCTP_ERROR_DNS_FAILED;
 
@@ -3098,7 +3098,7 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 	/* Skip the address parameter and store a pointer to the first
 	 * asconf parameter.
 	 */
-	length = ntohs(addr_param->v4.param_hdr.length);
+	length = ntohs(addr_param->p.length);
 	asconf_param = (sctp_addip_param_t *)((void *)addr_param + length);
 	chunk_len -= length;
 
@@ -3175,7 +3175,7 @@ static void sctp_asconf_param_success(struct sctp_association *asoc,
 			((void *)asconf_param + sizeof(sctp_addip_param_t));
 
 	/* We have checked the packet before, so we do not check again.	*/
-	af = sctp_get_af_specific(param_type2af(addr_param->v4.param_hdr.type));
+	af = sctp_get_af_specific(param_type2af(addr_param->p.type));
 	af->from_addr_param(&addr, addr_param, htons(bp->port), 0);
 
 	switch (asconf_param->param_hdr.type) {
@@ -3302,7 +3302,7 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
 	/* Skip the address parameter in the last asconf sent and store a
 	 * pointer to the first asconf parameter.
 	 */
-	length = ntohs(addr_param->v4.param_hdr.length);
+	length = ntohs(addr_param->p.length);
 	asconf_param = (sctp_addip_param_t *)((void *)addr_param + length);
 	asconf_len -= length;
 
-- 
1.7.0





