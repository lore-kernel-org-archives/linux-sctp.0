From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 09:58:23 +0000
Subject: [PATCH] sctp: Implement sctpCurrEstab MIB item when changing association's
Message-Id: <4C3D8A3F.8040903@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


sctpCurrEstab counter is set based on the state of association, 
so when using SCTP_CMD_NEW_STATE command to change state,
If the state becomes ESTABLISHED, then increase the counter.
If the state is changed from ESTABLISHED state or SHUTDOWN relevant state into CLOSED,
then reduce the counter.

In addition, this patch also reduces the size of the module.

i386 results:
# gcc --version
gcc (GCC) 4.4.3 20100211 (Red Hat 4.4.3-6)

# codiff net/sctp-pre/sctp.ko net/sctp/sctp.ko 
net/sctp/sm_statefuns.c:
 13 structs changed
  sctp_sf_do_6_3_3_rtx       |  -25
  sctp_sf_do_9_1_prm_abort   |  -31
  sctp_sf_t5_timer_expire    |  -25
  sctp_sf_t4_timer_expire    |  -25
  sctp_sf_t2_timer_expire    |  -25
  __sctp_sf_do_9_1_abort     |  -25
  sctp_sf_abort_violation    |  -42
  sctp_sf_sendbeat_8_3       |  -25
  sctp_sf_violation_paramlen |  -25
  sctp_sf_do_asconf_ack      |  -50
  sctp_sf_do_4_C             |  -25
  sctp_sf_do_9_2_final       |  -25
  sctp_eat_data              |  -29
  sctp_sf_do_5_2_4_dupcook   |  -62
  sctp_sf_do_5_1E_ca         |  -25
  sctp_sf_do_5_1D_ce         |  -25
 16 functions changed, 489 bytes removed, diff: -489

net/sctp/sm_sideeffect.c:
 13 structs changed
  sctp_do_sm                | +130
 1 function changed, 130 bytes added, diff: +130

net/sctp/sctp.ko:
 17 functions changed, 130 bytes added, 489 bytes removed, diff: -359


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/sm_sideeffect.c |   30 +++++++++++++++++++++++-------
 net/sctp/sm_statefuns.c  |   18 ------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index f5e5e27..ab515bd 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -749,11 +749,12 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 			       sctp_state_t state)
 {
 	struct sock *sk = asoc->base.sk;
+	sctp_state_t old_state = asoc->state;
 
 	asoc->state = state;
 
-	SCTP_DEBUG_PRINTK("sctp_cmd_new_state: asoc %p[%s]\n",
-			  asoc, sctp_state_tbl[state]);
+	SCTP_DEBUG_PRINTK("sctp_cmd_new_state: asoc %p[%s -> %s]\n", asoc,
+			   sctp_state_tbl[old_state], sctp_state_tbl[state]);
 
 	if (sctp_style(sk, TCP)) {
 		/* Change the sk->sk_state of a TCP-style socket that has
@@ -768,7 +769,9 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 			sk->sk_shutdown |= RCV_SHUTDOWN;
 	}
 
-	if (sctp_state(asoc, COOKIE_WAIT)) {
+	switch (state) {
+	case SCTP_STATE_COOKIE_WAIT:
+
 		/* Reset init timeouts since they may have been
 		 * increased due to timer expirations.
 		 */
@@ -776,11 +779,12 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 						asoc->rto_initial;
 		asoc->timeouts[SCTP_EVENT_TIMEOUT_T1_COOKIE]  						asoc->rto_initial;
-	}
+		break;
+
+	case SCTP_STATE_ESTABLISHED:
+	case SCTP_STATE_SHUTDOWN_RECEIVED:
+	case SCTP_STATE_CLOSED:
 
-	if (sctp_state(asoc, ESTABLISHED) ||
-	    sctp_state(asoc, CLOSED) ||
-	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {
 		/* Wake up any processes waiting in the asoc's wait queue in
 		 * sctp_wait_for_connect() or sctp_wait_for_sndbuf().
 		 */
@@ -795,6 +799,18 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 		 */
 		if (!sctp_style(sk, UDP))
 			sk->sk_state_change(sk);
+
+		if (old_state != SCTP_STATE_ESTABLISHED &&
+		    sctp_state(asoc, ESTABLISHED))
+			SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
+
+		if (old_state >= SCTP_STATE_ESTABLISHED &&
+		    sctp_state(asoc, CLOSED))
+			SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
+
+		break;
+	default:
+		break;
 	}
 }
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..33a900b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -258,7 +258,6 @@ sctp_disposition_t sctp_sf_do_4_C(const struct sctp_endpoint *ep,
 			SCTP_STATE(SCTP_STATE_CLOSED));
 
 	SCTP_INC_STATS(SCTP_MIB_SHUTDOWNS);
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 
@@ -803,7 +802,6 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
-	SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
 	SCTP_INC_STATS(SCTP_MIB_PASSIVEESTABS);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 
@@ -891,7 +889,6 @@ sctp_disposition_t sctp_sf_do_5_1E_ca(const struct sctp_endpoint *ep,
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T1_COOKIE));
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
-	SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
 	SCTP_INC_STATS(SCTP_MIB_ACTIVEESTABS);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 	if (asoc->autoclose)
@@ -981,7 +978,6 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_ERROR));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
@@ -1789,7 +1785,6 @@ static sctp_disposition_t sctp_sf_do_dupcook_b(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
-	SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 
 	repl = sctp_make_cookie_ack(new_asoc, chunk);
@@ -1881,7 +1876,6 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(const struct sctp_endpoint *ep,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T1_COOKIE));
 		sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 				SCTP_STATE(SCTP_STATE_ESTABLISHED));
-		SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
 		sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START,
 				SCTP_NULL());
 
@@ -2419,7 +2413,6 @@ static sctp_disposition_t __sctp_sf_do_9_1_abort(const struct sctp_endpoint *ep,
 	/* ASSOC_FAILED will DELETE_TCB. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED, SCTP_PERR(error));
 	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 
 	return SCTP_DISPOSITION_ABORT;
 }
@@ -3278,7 +3271,6 @@ sctp_disposition_t sctp_sf_do_9_2_final(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_CLOSED));
 	SCTP_INC_STATS(SCTP_MIB_SHUTDOWNS);
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
 
 	/* ...and remove all record of the association. */
@@ -3667,7 +3659,6 @@ sctp_disposition_t sctp_sf_do_asconf_ack(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_ASCONF_ACK));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_ABORT;
 	}
 
@@ -3701,7 +3692,6 @@ sctp_disposition_t sctp_sf_do_asconf_ack(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_ASCONF_ACK));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_ABORT;
 	}
 
@@ -4276,7 +4266,6 @@ static sctp_disposition_t sctp_sf_abort_violation(
 					SCTP_ERROR(ECONNABORTED));
 			sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 					SCTP_PERR(SCTP_ERROR_PROTO_VIOLATION));
-			SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		}
 	} else {
 		packet = sctp_ootb_pkt_new(asoc, chunk);
@@ -4372,7 +4361,6 @@ static sctp_disposition_t sctp_sf_violation_paramlen(
 			SCTP_ERROR(ECONNABORTED));
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 			SCTP_PERR(SCTP_ERROR_PROTO_VIOLATION));
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
 
 discard:
@@ -4719,7 +4707,6 @@ sctp_disposition_t sctp_sf_do_9_1_prm_abort(
 			SCTP_PERR(SCTP_ERROR_USER_ABORT));
 
 	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 
 	return retval;
 }
@@ -5250,7 +5237,6 @@ sctp_disposition_t sctp_sf_do_6_3_3_rtx(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_ERROR));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
@@ -5464,7 +5450,6 @@ sctp_disposition_t sctp_sf_t2_timer_expire(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_ERROR));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
@@ -5548,7 +5533,6 @@ sctp_disposition_t sctp_sf_t4_timer_expire(
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_ERROR));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_ABORT;
 	}
 
@@ -5605,7 +5589,6 @@ sctp_disposition_t sctp_sf_t5_timer_expire(const struct sctp_endpoint *ep,
 			SCTP_PERR(SCTP_ERROR_NO_ERROR));
 
 	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 
 	return SCTP_DISPOSITION_DELETE_TCB;
 nomem:
@@ -6031,7 +6014,6 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_DATA));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_IERROR_NO_DATA;
 	}
 
-- 
1.6.3.3
