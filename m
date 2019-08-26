From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Aug 2019 08:30:02 +0000
Subject: [PATCH net-next 1/3] sctp: make ecn flag per netns and endpoint
Message-Id: <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to add ecn flag for both netns_sctp and sctp_endpoint,
net->sctp.ecn_enable is set 1 by default, and ep->ecn_enable will
be initialized with net->sctp.ecn_enable.

asoc->peer.ecn_capable will be set during negotiation only when
ep->ecn_enable is set on both sides.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  3 +++
 include/net/sctp/structs.h |  3 ++-
 net/sctp/endpointola.c     |  1 +
 net/sctp/protocol.c        |  3 +++
 net/sctp/sm_make_chunk.c   | 16 ++++++++++++----
 5 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 0db7fb3..bdc0f27 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -128,6 +128,9 @@ struct netns_sctp {
 	/* Flag to indicate if stream interleave is enabled */
 	int intl_enable;
 
+	/* Flag to indicate if ecn is enabled */
+	int ecn_enable;
+
 	/*
 	 * Policy to control SCTP IPv4 address scoping
 	 * 0   - Disable IPv4 address scoping
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index daac1ef..503fbc3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1322,7 +1322,8 @@ struct sctp_endpoint {
 	/* SCTP-AUTH: endpoint shared keys */
 	struct list_head endpoint_shared_keys;
 	__u16 active_key_id;
-	__u8  auth_enable:1,
+	__u8  ecn_enable:1,
+	      auth_enable:1,
 	      intl_enable:1,
 	      prsctp_enable:1,
 	      asconf_enable:1,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 75a407d..ea53049 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -106,6 +106,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	 */
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 	ep->reconf_enable = net->sctp.reconf_enable;
+	ep->ecn_enable = net->sctp.ecn_enable;
 
 	/* Remember who we are attached to.  */
 	ep->base.sk = sk;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2d47adc..b48ffe8 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1254,6 +1254,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Disable AUTH by default. */
 	net->sctp.auth_enable = 0;
 
+	/* Enable ECN by default. */
+	net->sctp.ecn_enable = 1;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 338278f..e41ed2e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -244,7 +244,9 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 
 	chunksize = sizeof(init) + addrs_len;
 	chunksize += SCTP_PAD4(SCTP_SAT_LEN(num_types));
-	chunksize += sizeof(ecap_param);
+
+	if (asoc->ep->ecn_enable)
+		chunksize += sizeof(ecap_param);
 
 	if (asoc->ep->prsctp_enable)
 		chunksize += sizeof(prsctp_param);
@@ -335,7 +337,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	sctp_addto_chunk(retval, sizeof(sat), &sat);
 	sctp_addto_chunk(retval, num_types * sizeof(__u16), &types);
 
-	sctp_addto_chunk(retval, sizeof(ecap_param), &ecap_param);
+	if (asoc->ep->ecn_enable)
+		sctp_addto_chunk(retval, sizeof(ecap_param), &ecap_param);
 
 	/* Add the supported extensions parameter.  Be nice and add this
 	 * fist before addiding the parameters for the extensions themselves
@@ -2597,8 +2600,13 @@ static int sctp_process_param(struct sctp_association *asoc,
 		break;
 
 	case SCTP_PARAM_ECN_CAPABLE:
-		asoc->peer.ecn_capable = 1;
-		break;
+		if (asoc->ep->ecn_enable) {
+			asoc->peer.ecn_capable = 1;
+			break;
+		}
+		/* Fall Through */
+		goto fall_through;
+
 
 	case SCTP_PARAM_ADAPTATION_LAYER_IND:
 		asoc->peer.adaptation_ind = ntohl(param.aind->adaptation_ind);
-- 
2.1.0
