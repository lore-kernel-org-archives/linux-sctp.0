From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:13:03 +0000
Subject: [PATCHv2 3/5] sctp: extend socket API for sched configuration
Message-Id: <AANLkTimEQkDpWorCF4HUq6N-xAnFz4xE89osAtcJY_Mn@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

Augment SCTP socket API with a new socket option SCTP_SCHED
to choose and configure multistream scheduling algorithm.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 include/net/sctp/structs.h |    4 ++
 include/net/sctp/user.h    |   19 ++++++++++
 net/sctp/outqueue.c        |    4 ++
 net/sctp/sm_sideeffect.c   |   45 +++++++++++++++++++++++--
 net/sctp/socket.c          |   80 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 52af764..1a76417 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -333,6 +333,8 @@ struct sctp_sock {

 	/* Multistream scheduling */
 	const struct sctp_sched_ops *sched_ops;
+	__u16 sched_config_len;
+	void *sched_config;

 	struct sctp_initmsg initmsg;
 	struct sctp_rtoinfo rtoinfo;
@@ -1173,6 +1175,8 @@ struct sctp_outq {

 	/* Multistream scheduling */
 	const struct sctp_sched_ops *sched_ops;
+	__u16 sched_config_len;
+	void *sched_config;

 	unsigned out_qlen;	/* Total length of queued data chunks. */

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 1e084f9..bb853d0 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -90,6 +90,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_PEER_AUTH_CHUNKS	26	/* Read only */
 #define SCTP_LOCAL_AUTH_CHUNKS	27	/* Read only */
 #define SCTP_GET_ASSOC_NUMBER	28	/* Read only */
+#define SCTP_SCHED	29	/* Configure multistream scheduling */

 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -708,6 +709,24 @@ typedef struct {
 	int sd;
 } sctp_peeloff_arg_t;

+/*
+ * SCTP Multistream Scheduling Structure (SCTP_SCHED)
+ *
+ *   This cmsghdr structure provides information for the multistream
+ *   scheduling algorithm used by a socket. The SCTP_SCHED socket option
+ *   uses this same data structure.
+ *
+ *   cmsg_level    cmsg_type      cmsg_data[]
+ *   ------------  ------------   ----------------------
+ *   IPPROTO_SCTP  SCTP_SCHED     struct sctp_sched
+ *
+ */
+
 #define SCTP_SCHED_NAME_MAX	16
+struct sctp_sched {
+	char  ssched_name[SCTP_SCHED_NAME_MAX];
+	__u16 ssched_config_len;
+	__u16 ssched_config[0];
+};

 #endif /* __net_sctp_user_h__ */
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 37ffa21..1d3bd2e 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -178,6 +178,8 @@ int sctp_outq_init(struct sctp_association *asoc,
struct sctp_outq *q,

 	/* initialize to the default FCFS at this stage */
 	q->sched_ops = sctp_default_sched_ops;
+	q->sched_config_len = 0;
+	q->sched_config = NULL;
 	err = q->sched_ops->init(q, gfp);
 	if (err)
 		return err;
@@ -269,6 +271,8 @@ void sctp_outq_free(struct sctp_outq *q)
 	sctp_outq_teardown(q);

 	q->sched_ops->release(q);
+	kfree(q->sched_config);
+	module_put(q->sched_ops->owner);

 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index f5e5e27..e240557 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -744,17 +744,54 @@ static void sctp_cmd_setup_t2(sctp_cmd_seq_t *cmds,
 }

 /* Helper function to change the state of an association. */
-static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
+static int sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 			       struct sctp_association *asoc,
-			       sctp_state_t state)
+			       sctp_state_t state,
+				gfp_t gfp)
 {
 	struct sock *sk = asoc->base.sk;
+	struct sctp_sock *sp = sctp_sk(sk);

 	asoc->state = state;

 	SCTP_DEBUG_PRINTK("sctp_cmd_new_state: asoc %p[%s]\n",
 			  asoc, sctp_state_tbl[state]);

+	/* Initialize mulitstream scheduling if user has customized it
+	 * Otherwise do nothing
+	 * Client: when entering COOKIE_ECHOED state
+	 * Server: when entering ESTABLISHED state
+	 */
+	if (sp->sched_ops != asoc->outqueue.sched_ops &&
+	(sctp_state(asoc, COOKIE_ECHOED) || sctp_state(asoc, ESTABLISHED))) {
+		if (!try_module_get(sp->sched_ops->owner))
+			return -EBUSY;
+		asoc->outqueue.sched_ops = sp->sched_ops;
+		asoc->outqueue.sched_config_len = sp->sched_config_len;
+		if (sp->sched_config_len) {
+			asoc->outqueue.sched_config = kmemdup(sp->sched_config,
+					sp->sched_config_len, gfp);
+			if (!asoc->outqueue.sched_config)
+				return -ENOMEM;
+		}
+		/* Initialize new data chunk queue(s)
+		 * Move data chunks from old queue to new queue(s)
+		 */
+		struct list_head *old = asoc->outqueue.out_chunk_list;
+		struct sctp_chunk *ch = NULL;
+		if (0 != asoc->outqueue.sched_ops->init(&asoc->outqueue, gfp))
+			return -ENOMEM;
+		while (!list_empty(old)) {
+			struct list_head *entry = old->next;
+			ch = list_entry(entry, struct sctp_chunk, list);
+			list_del_init(entry);
+			asoc->outqueue.out_qlen -= ch->skb->len;
+			asoc->outqueue.sched_ops->
+				enqueue_tail_data(&asoc->outqueue, ch);
+		}
+		kfree(old);
+	}
+
 	if (sctp_style(sk, TCP)) {
 		/* Change the sk->sk_state of a TCP-style socket that has
 		 * successfully completed a connect() call.
@@ -796,6 +833,7 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 		if (!sctp_style(sk, UDP))
 			sk->sk_state_change(sk);
 	}
+	return 0;
 }

 /* Helper function to delete an association. */
@@ -1250,7 +1288,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,

 		case SCTP_CMD_NEW_STATE:
 			/* Enter a new state.  */
-			sctp_cmd_new_state(commands, asoc, cmd->obj.state);
+			error = sctp_cmd_new_state(commands, asoc,
+						cmd->obj.state, gfp);
 			break;

 		case SCTP_CMD_REPORT_TSN:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7d461be..481f231 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2582,6 +2582,44 @@ static int sctp_setsockopt_initmsg(struct sock
*sk, char __user *optval, unsigne
 	return 0;
 }

+/* Set the multistream scheduling algorithm */
+static int sctp_setsockopt_sched(struct sock *sk, char __user *optval,
+						unsigned int optlen)
+{
+	struct sctp_sched *ssched = NULL;
+	struct sctp_sock *sp = sctp_sk(sk);
+	int ret = 0;
+
+	if (optlen < sizeof(struct sctp_sched))
+		return -EINVAL;
+
+	ssched = memdup_user(optval, optlen);
+	if (IS_ERR(ssched)) {
+		ret = PTR_ERR(ssched);
+		goto out;
+	}
+
+	if (optlen != sizeof(struct sctp_sched) + ssched->ssched_config_len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = sctp_set_sched(sk, ssched->ssched_name);
+	if (ret)
+		goto out;
+	sp->sched_config_len = ssched->ssched_config_len;
+	kfree(sp->sched_config);
+	if (sp->sched_config_len) {
+		sp->sched_config = kmemdup(ssched->ssched_config,
+					sp->sched_config_len, GFP_KERNEL);
+		if (!sp->sched_config)
+			ret = -ENOMEM;
+	}
+out:
+	kfree(ssched);
+	return ret;
+}
+
 /*
  * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
  *
@@ -3422,6 +3460,9 @@ SCTP_STATIC int sctp_setsockopt(struct sock *sk,
int level, int optname,
 	case SCTP_INITMSG:
 		retval = sctp_setsockopt_initmsg(sk, optval, optlen);
 		break;
+	case SCTP_SCHED:
+		retval = sctp_setsockopt_sched(sk, optval, optlen);
+		break;
 	case SCTP_DEFAULT_SEND_PARAM:
 		retval = sctp_setsockopt_default_send_param(sk, optval,
 							    optlen);
@@ -3646,6 +3687,8 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)

 	/* Initialize default multistream scheduling algorithm */
 	sp->sched_ops = sctp_default_sched_ops;
+	sp->sched_config_len = 0;
+	sp->sched_config = NULL;

 	/* Initialize default RTO related parameters.  These parameters can
 	 * be modified for with the SCTP_RTOINFO socket option.
@@ -3738,6 +3781,9 @@ SCTP_STATIC void sctp_destroy_sock(struct sock *sk)

 	SCTP_DEBUG_PRINTK("sctp_destroy_sock(sk: %p)\n", sk);

+	sctp_cleanup_sched(sk);
+	kfree(sctp_sk(sk)->sched_config);
+
 	/* Release our hold on the endpoint. */
 	ep = sctp_sk(sk)->ep;
 	sctp_endpoint_free(ep);
@@ -4354,7 +4400,38 @@ static int sctp_getsockopt_initmsg(struct sock
*sk, int len, char __user *optval
 	return 0;
 }

+/* Get the multistream scheduling algorithm */
+static int sctp_getsockopt_sched(struct sock *sk, int len, char __user *optval,
+							int __user *optlen)
+{
+	struct sctp_sched *ssched;
+	int sz = sizeof(struct sctp_sched) + sctp_sk(sk)->sched_config_len;
+	int ret = 0;
+
+	if (len < sz)
+		return -EINVAL;
+
+	ssched = kmalloc(sz, GFP_KERNEL);
+	if (!ssched)
+		return -ENOMEM;
+	memcpy(ssched->ssched_name, sctp_sk(sk)->sched_ops->name,
+					SCTP_SCHED_NAME_MAX);
+	ssched->ssched_config_len = sctp_sk(sk)->sched_config_len;
+	memcpy(ssched->ssched_config, sctp_sk(sk)->sched_config,
+					ssched->ssched_config_len);
+
+	if (copy_to_user(optval, ssched, sz)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (put_user(sz, optlen))
+		ret = -EFAULT;

+out:
+	kfree(ssched);
+	return ret;
+}
+
 static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
 				      char __user *optval, int __user *optlen)
 {
@@ -5299,6 +5376,9 @@ SCTP_STATIC int sctp_getsockopt(struct sock *sk,
int level, int optname,
 	case SCTP_INITMSG:
 		retval = sctp_getsockopt_initmsg(sk, len, optval, optlen);
 		break;
+	case SCTP_SCHED:
+		retval = sctp_getsockopt_sched(sk, len, optval, optlen);
+		break;
 	case SCTP_GET_PEER_ADDRS:
 		retval = sctp_getsockopt_peer_addrs(sk, len, optval,
 						    optlen);
-- 
1.7.0.4
