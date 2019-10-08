From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:25:06 +0000
Subject: [PATCHv2 net-next 4/5] sctp: add support for Primary Path Switchover
Message-Id: <045f7763d7b6bb2ccba3bfc78202b0a28131c6d6.1570533716.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <bca4cbf1bee8ad2379b2fe9536b3404fc0935579.1570533716.git.lucien.xin@gmail.com>
 <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This is a new feature defined in section 5 of rfc7829: "Primary Path
Switchover". By introducing a new tunable parameter:

  Primary.Switchover.Max.Retrans (PSMR)

The primary path will be changed to another active path when the path
error counter on the old primary path exceeds PSMR, so that "the SCTP
sender is allowed to continue data transmission on a new working path
even when the old primary destination address becomes active again".

This patch is to add this tunable parameter, 'ps_retrans' per netns,
sock, asoc and transport. It also allows a user to change ps_retrans
per netns by sysctl, and ps_retrans per sock/asoc/transport will be
initialized with it.

The check will be done in sctp_do_8_2_transport_strike() when this
feature is enabled.

Note this feature is disabled by initializing 'ps_retrans' per netns
as 0xffff by default, and its value can't be less than 'pf_retrans'
when changing by sysctl.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  6 ++++++
 include/net/sctp/structs.h | 11 ++++++++---
 net/sctp/associola.c       |  3 +++
 net/sctp/protocol.c        |  3 +++
 net/sctp/sm_sideeffect.c   |  5 +++++
 net/sctp/socket.c          |  1 +
 net/sctp/sysctl.c          |  9 +++++++++
 7 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 5234940c..cab0903 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -89,6 +89,12 @@ struct netns_sctp {
 	 */
 	int pf_retrans;
 
+	/* Primary.Switchover.Max.Retrans sysctl value
+	 * taken from:
+	 * https://tools.ietf.org/html/rfc7829
+	 */
+	int ps_retrans;
+
 	/*
 	 * Disable Potentially-Failed feature, the feature is enabled by default
 	 * pf_enable	-  0  : disable pf
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c2d3317..3680a93 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -184,7 +184,8 @@ struct sctp_sock {
 	__u32 flowlabel;
 	__u8  dscp;
 
-	int pf_retrans;
+	__u16 pf_retrans;
+	__u16 ps_retrans;
 
 	/* The initial Path MTU to use for new associations. */
 	__u32 pathmtu;
@@ -897,7 +898,9 @@ struct sctp_transport {
 	 * and will be initialized from the assocs value.  This can be changed
 	 * using the SCTP_PEER_ADDR_THLDS socket option
 	 */
-	int pf_retrans;
+	__u16 pf_retrans;
+	/* Used for primary path switchover. */
+	__u16 ps_retrans;
 	/* PMTU	      : The current known path MTU.  */
 	__u32 pathmtu;
 
@@ -1773,7 +1776,9 @@ struct sctp_association {
 	 * and will be initialized from the assocs value.  This can be
 	 * changed using the SCTP_PEER_ADDR_THLDS socket option
 	 */
-	int pf_retrans;
+	__u16 pf_retrans;
+	/* Used for primary path switchover. */
+	__u16 ps_retrans;
 
 	/* Maximum number of times the endpoint will retransmit INIT  */
 	__u16 max_init_attempts;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1c30fda..8aaa7c3 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,6 +86,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
 	asoc->pf_retrans  = sp->pf_retrans;
+	asoc->ps_retrans  = sp->ps_retrans;
 	asoc->pf_expose   = sp->pf_expose;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
@@ -625,6 +626,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 
 	/* And the partial failure retrans threshold */
 	peer->pf_retrans = asoc->pf_retrans;
+	/* And the primary path switchover retrans threshold */
+	peer->ps_retrans = asoc->ps_retrans;
 
 	/* Initialize the peer's SACK delay timeout based on the
 	 * association configured value.
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a303011..84a3d75 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1217,6 +1217,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Max.Burst		    - 4 */
 	net->sctp.max_burst			= SCTP_DEFAULT_MAX_BURST;
 
+	/* Disable of Primary Path Switchover by default */
+	net->sctp.ps_retrans = 0xffff;
+
 	/* Enable pf state by default */
 	net->sctp.pf_enable = 1;
 
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index e52b212..acd737d 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -567,6 +567,11 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 					     SCTP_FAILED_THRESHOLD);
 	}
 
+	if (transport->error_count > transport->ps_retrans &&
+	    asoc->peer.primary_path = transport &&
+	    asoc->peer.active_path != transport)
+		sctp_assoc_set_primary(asoc, asoc->peer.active_path);
+
 	/* E2) For the destination address for which the timer
 	 * expires, set RTO <- RTO * 2 ("back off the timer").  The
 	 * maximum value discussed in rule C7 above (RTO.max) may be
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 82faf78..7dfb2c5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5075,6 +5075,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
+	sp->ps_retrans  = net->sctp.ps_retrans;
 	sp->pf_expose   = net->sctp.pf_expose;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index eacc9a1..c9ebfc2 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -212,6 +212,15 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	{
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
-- 
2.1.0
