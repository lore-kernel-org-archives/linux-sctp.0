From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 09 Sep 2019 07:56:48 +0000
Subject: [PATCH net-next 2/5] sctp: add pf_expose per netns and sock and asoc
Message-Id: <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

As said in rfc7829, section 3, point 12:

  The SCTP stack SHOULD expose the PF state of its destination
  addresses to the ULP as well as provide the means to notify the
  ULP of state transitions of its destination addresses from
  active to PF, and vice versa.  However, it is recommended that
  an SCTP stack implementing SCTP-PF also allows for the ULP to be
  kept ignorant of the PF state of its destinations and the
  associated state transitions, thus allowing for retention of the
  simpler state transition model of [RFC4960] in the ULP.

Not only does it allow to expose the PF state to ULP, but also
allow to ignore sctp-pf to ULP.

So this patch is to add pf_expose per netns, sock and asoc. And in
sctp_assoc_control_transport(), ulp_notify will be set to false if
asoc->expose is not set.

It also allows a user to change pf_expose per netns by sysctl, and
pf_expose per sock and asoc will be initialized with it.

Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
to not allow a user to query the state of a sctp-pf peer address
when pf_expose is not enabled, as said in section 7.3.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  7 +++++++
 include/net/sctp/structs.h |  2 ++
 include/uapi/linux/sctp.h  |  1 +
 net/sctp/associola.c       | 10 ++++++++--
 net/sctp/protocol.c        |  3 +++
 net/sctp/socket.c          | 12 ++++++++++--
 net/sctp/sysctl.c          |  7 +++++++
 7 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index bdc0f27..5234940c 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -97,6 +97,13 @@ struct netns_sctp {
 	int pf_enable;
 
 	/*
+	 * Disable Potentially-Failed state exposure, enabled by default
+	 * pf_expose	-  0  : disable pf state exposure
+	 *		- >0  : enable  pf state exposure
+	 */
+	int pf_expose;
+
+	/*
 	 * Policy for preforming sctp/socket accounting
 	 * 0   - do socket level accounting, all assocs share sk_sndbuf
 	 * 1   - do sctp accounting, each asoc may use sk_sndbuf bytes
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 503fbc3..c2d3317 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -215,6 +215,7 @@ struct sctp_sock {
 	__u32 adaptation_ind;
 	__u32 pd_point;
 	__u16	nodelay:1,
+		pf_expose:1,
 		reuse:1,
 		disable_fragments:1,
 		v4mapped:1,
@@ -2053,6 +2054,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
+	     pf_expose:1,       /* Expose pf state? */
 	     force_delay:1;
 
 	__u8 strreset_enable;
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 45a85d7..b6649d6 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -920,6 +920,7 @@ struct sctp_paddrinfo {
 enum sctp_spinfo_state {
 	SCTP_INACTIVE,
 	SCTP_PF,
+#define	SCTP_POTENTIALLY_FAILED		SCTP_PF
 	SCTP_ACTIVE,
 	SCTP_UNCONFIRMED,
 	SCTP_UNKNOWN = 0xffff  /* Value used for transport state unknown */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 7278b7e..461b1ffa 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,6 +86,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
 	asoc->pf_retrans  = sp->pf_retrans;
+	asoc->pf_expose   = sp->pf_expose;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
 	asoc->rto_max = msecs_to_jiffies(sp->rtoinfo.srto_max);
@@ -793,7 +794,9 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to heartbeat success, report the SCTP_ADDR_CONFIRMED
 		 * state to the user, otherwise report SCTP_ADDR_AVAILABLE.
 		 */
-		if (SCTP_UNCONFIRMED = transport->state &&
+		if (transport->state = SCTP_PF && !asoc->pf_expose)
+			ulp_notify = false;
+		if (transport->state && SCTP_UNCONFIRMED &&
 		    SCTP_HEARTBEAT_SUCCESS = error)
 			spc_state = SCTP_ADDR_CONFIRMED;
 		else
@@ -817,7 +820,10 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 
 	case SCTP_TRANSPORT_PF:
 		transport->state = SCTP_PF;
-		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
+		if (!asoc->pf_expose)
+			ulp_notify = false;
+		else
+			spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b48ffe8..de0f15f 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1220,6 +1220,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable pf state by default */
 	net->sctp.pf_enable = 1;
 
+	/* Enable pf state exposure by default */
+	net->sctp.pf_expose = 1;
+
 	/* Association.Max.Retrans  - 10 attempts
 	 * Path.Max.Retrans         - 5  attempts (per destination address)
 	 * Max.Init.Retransmits     - 8  attempts
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3e50a97..33b93bb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5040,6 +5040,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
+	sp->pf_expose   = net->sctp.pf_expose;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
 	sp->sackfreq	= 2;
@@ -5520,8 +5521,15 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 
 	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
 					   pinfo.spinfo_assoc_id);
-	if (!transport)
-		return -EINVAL;
+	if (!transport) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (transport->state = SCTP_PF && !transport->asoc->pf_expose) {
+		retval = -EACCES;
+		goto out;
+	}
 
 	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
 	pinfo.spinfo_state = transport->state;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 238cf17..eacc9a1 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -318,6 +318,13 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "pf_expose",
+		.data		= &init_net.sctp.pf_expose,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 
 	{ /* sentinel */ }
 };
-- 
2.1.0
