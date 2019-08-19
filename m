From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:43 +0000
Subject: [PATCH net-next 1/8] sctp: add asconf_enable in struct sctp_endpoint
Message-Id: <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to make addip/asconf flag per endpoint,
and its value is initialized by the per netns flag,
net->sctp.addip_enable.

It also replaces the checks of net->sctp.addip_enable
with ep->asconf_enable in some places.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  1 +
 net/sctp/endpointola.c     |  3 ++-
 net/sctp/sm_make_chunk.c   | 18 +++++++++---------
 net/sctp/socket.c          | 17 +++++++----------
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index ba5c4f6..daac1ef 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1325,6 +1325,7 @@ struct sctp_endpoint {
 	__u8  auth_enable:1,
 	      intl_enable:1,
 	      prsctp_enable:1,
+	      asconf_enable:1,
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 69cebb2..38b8d7c 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -52,6 +52,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	if (!ep->digest)
 		return NULL;
 
+	ep->asconf_enable = net->sctp.addip_enable;
 	ep->auth_enable = net->sctp.auth_enable;
 	if (ep->auth_enable) {
 		/* Allocate space for HMACS and CHUNKS authentication
@@ -86,7 +87,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 		/* If the Add-IP functionality is enabled, we must
 		 * authenticate, ASCONF and ASCONF-ACK chunks
 		 */
-		if (net->sctp.addip_enable) {
+		if (ep->asconf_enable) {
 			auth_chunks->chunks[0] = SCTP_CID_ASCONF;
 			auth_chunks->chunks[1] = SCTP_CID_ASCONF_ACK;
 			auth_chunks->param_hdr.length diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 36bd8a6e..338278f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -207,7 +207,6 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 				  const struct sctp_bind_addr *bp,
 				  gfp_t gfp, int vparam_len)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	struct sctp_supported_ext_param ext_param;
 	struct sctp_adaptation_ind_param aiparam;
 	struct sctp_paramhdr *auth_chunks = NULL;
@@ -255,7 +254,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	 *  the ASCONF,the ASCONF-ACK, and the AUTH  chunks in its INIT and
 	 *  INIT-ACK parameters.
 	 */
-	if (net->sctp.addip_enable) {
+	if (asoc->ep->asconf_enable) {
 		extensions[num_ext] = SCTP_CID_ASCONF;
 		extensions[num_ext+1] = SCTP_CID_ASCONF_ACK;
 		num_ext += 2;
@@ -1964,7 +1963,9 @@ static int sctp_process_hn_param(const struct sctp_association *asoc,
 	return 0;
 }
 
-static int sctp_verify_ext_param(struct net *net, union sctp_params param)
+static int sctp_verify_ext_param(struct net *net,
+				 const struct sctp_endpoint *ep,
+				 union sctp_params param)
 {
 	__u16 num_ext = ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
 	int have_asconf = 0;
@@ -1991,7 +1992,7 @@ static int sctp_verify_ext_param(struct net *net, union sctp_params param)
 	if (net->sctp.addip_noauth)
 		return 1;
 
-	if (net->sctp.addip_enable && !have_auth && have_asconf)
+	if (ep->asconf_enable && !have_auth && have_asconf)
 		return 0;
 
 	return 1;
@@ -2001,7 +2002,6 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				   union sctp_params param)
 {
 	__u16 num_ext = ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-	struct net *net = sock_net(asoc->base.sk);
 	int i;
 
 	for (i = 0; i < num_ext; i++) {
@@ -2023,7 +2023,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			break;
 		case SCTP_CID_ASCONF:
 		case SCTP_CID_ASCONF_ACK:
-			if (net->sctp.addip_enable)
+			if (asoc->ep->asconf_enable)
 				asoc->peer.asconf_capable = 1;
 			break;
 		case SCTP_CID_I_DATA:
@@ -2145,12 +2145,12 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_SUPPORTED_EXT:
-		if (!sctp_verify_ext_param(net, param))
+		if (!sctp_verify_ext_param(net, ep, param))
 			return SCTP_IERROR_ABORT;
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (net->sctp.addip_enable)
+		if (ep->asconf_enable)
 			break;
 		goto fallthrough;
 
@@ -2605,7 +2605,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (!net->sctp.addip_enable)
+		if (!ep->asconf_enable)
 			goto fall_through;
 
 		addr_param = param.v + sizeof(struct sctp_addip_param);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 12503e1..559793f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -524,7 +524,6 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 				   struct sockaddr	*addrs,
 				   int 			addrcnt)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock		*sp;
 	struct sctp_endpoint		*ep;
 	struct sctp_association		*asoc;
@@ -539,12 +538,12 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 	int 				i;
 	int 				retval = 0;
 
-	if (!net->sctp.addip_enable)
-		return retval;
-
 	sp = sctp_sk(sk);
 	ep = sp->ep;
 
+	if (!ep->asconf_enable)
+		return retval;
+
 	pr_debug("%s: sk:%p, addrs:%p, addrcnt:%d\n",
 		 __func__, sk, addrs, addrcnt);
 
@@ -727,7 +726,6 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 				   struct sockaddr	*addrs,
 				   int			addrcnt)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock	*sp;
 	struct sctp_endpoint	*ep;
 	struct sctp_association	*asoc;
@@ -743,12 +741,12 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 	int			stored = 0;
 
 	chunk = NULL;
-	if (!net->sctp.addip_enable)
-		return retval;
-
 	sp = sctp_sk(sk);
 	ep = sp->ep;
 
+	if (!ep->asconf_enable)
+		return retval;
+
 	pr_debug("%s: sk:%p, addrs:%p, addrcnt:%d\n",
 		 __func__, sk, addrs, addrcnt);
 
@@ -3330,7 +3328,6 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optval,
 					     unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock	*sp;
 	struct sctp_association	*asoc = NULL;
 	struct sctp_setpeerprim	prim;
@@ -3340,7 +3337,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 
 	sp = sctp_sk(sk);
 
-	if (!net->sctp.addip_enable)
+	if (!sp->ep->asconf_enable)
 		return -EPERM;
 
 	if (optlen != sizeof(struct sctp_setpeerprim))
-- 
2.1.0
