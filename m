From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 22 Apr 2008 07:25:54 +0000
Subject: [PATCH] SCTP: Bring SCTP_DELAYED_ACK socket option into ietf API
Message-Id: <480D9302.6090706@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Brings delayed_ack socket option set/get into line with the latest ietf 
socket extensions API draft, while maintaining backwards compatibility.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

--- a/include/net/sctp/user.h	2008-04-18 13:45:11.000000000 -0400
+++ b/include/net/sctp/user.h	2008-04-19 08:36:05.000000000 -0400
@@ -93,8 +93,8 @@ enum sctp_optname {
 #define SCTP_STATUS SCTP_STATUS
 	SCTP_GET_PEER_ADDR_INFO,
 #define SCTP_GET_PEER_ADDR_INFO SCTP_GET_PEER_ADDR_INFO
-	SCTP_DELAYED_ACK_TIME,
-#define SCTP_DELAYED_ACK_TIME SCTP_DELAYED_ACK_TIME
+	SCTP_DELAYED_ACK,
+#define SCTP_DELAYED_ACK SCTP_DELAYED_ACK
 	SCTP_CONTEXT,	/* Receive Context */
 #define SCTP_CONTEXT SCTP_CONTEXT
 	SCTP_FRAGMENT_INTERLEAVE,
@@ -618,16 +618,29 @@ struct sctp_authkeyid {
 };
 
 
-/* 7.1.23. Delayed Ack Timer (SCTP_DELAYED_ACK_TIME)
+/*
+ * 7.1.23.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
  *
- *   This options will get or set the delayed ack timer.  The time is set
- *   in milliseconds.  If the assoc_id is 0, then this sets or gets the
- *   endpoints default delayed ack timer value.  If the assoc_id field is
- *   non-zero, then the set or get effects the specified association.
- */
+ * This option will effect the way delayed acks are performed.  This
+ * option allows you to get or set the delayed ack time, in
+ * milliseconds.  It also allows changing the delayed ack frequency.
+ * Changing the frequency to 1 disables the delayed sack algorithm.  If
+ * the assoc_id is 0, then this sets or gets the endpoints default
+ * values.  If the assoc_id field is non-zero, then the set or get
+ * effects the specified association for the one to many model (the
+ * assoc_id field is ignored by the one to one model).  Note that if
+ * sack_delay or sack_freq are 0 when setting this option, then the
+ * current values will remain unchanged.
+ */
+struct sctp_sack_info {
+	sctp_assoc_t	sack_assoc_id;
+	uint32_t	sack_delay;
+	uint32_t	sack_freq;
+};
+
 struct sctp_assoc_value {
-    sctp_assoc_t            assoc_id;
-    uint32_t                assoc_value;
+	sctp_assoc_t	assoc_id;
+	uint32_t	assoc_value;
 };
 
 /*
--- a/net/sctp/socket.c	2008-04-18 09:00:57.000000000 -0400
+++ b/net/sctp/socket.c	2008-04-19 08:35:21.000000000 -0400
@@ -2315,69 +2315,91 @@ static int sctp_setsockopt_peer_addr_par
 	return 0;
 }
 
-/* 7.1.23. Delayed Ack Timer (SCTP_DELAYED_ACK_TIME)
+/*
+ * 7.1.23.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
+ *
+ * This option will effect the way delayed acks are performed.  This
+ * option allows you to get or set the delayed ack time, in
+ * milliseconds.  It also allows changing the delayed ack frequency.
+ * Changing the frequency to 1 disables the delayed sack algorithm.  If
+ * the assoc_id is 0, then this sets or gets the endpoints default
+ * values.  If the assoc_id field is non-zero, then the set or get
+ * effects the specified association for the one to many model (the
+ * assoc_id field is ignored by the one to one model).  Note that if
+ * sack_delay or sack_freq are 0 when setting this option, then the
+ * current values will remain unchanged.
+ * 
+ * struct sctp_sack_info {
+ *     sctp_assoc_t            sack_assoc_id;
+ *     uint32_t                sack_delay;
+ *     uint32_t                sack_freq;
+ * };
  *
- *   This options will get or set the delayed ack timer.  The time is set
- *   in milliseconds.  If the assoc_id is 0, then this sets or gets the
- *   endpoints default delayed ack timer value.  If the assoc_id field is
- *   non-zero, then the set or get effects the specified association.
- *
- *   struct sctp_assoc_value {
- *       sctp_assoc_t            assoc_id;
- *       uint32_t                assoc_value;
- *   };
- *
- *     assoc_id    - This parameter, indicates which association the
- *                   user is preforming an action upon. Note that if
- *                   this field's value is zero then the endpoints
- *                   default value is changed (effecting future
- *                   associations only).
- *
- *     assoc_value - This parameter contains the number of milliseconds
- *                   that the user is requesting the delayed ACK timer
- *                   be set to. Note that this value is defined in
- *                   the standard to be between 200 and 500 milliseconds.
- *
- *                   Note: a value of zero will leave the value alone,
- *                   but disable SACK delay. A non-zero value will also
- *                   enable SACK delay.
+ * sack_assoc_id -  This parameter, indicates which association the user
+ *    is performing an action upon.  Note that if this field's value is
+ *    zero then the endpoints default value is changed (effecting future
+ *    associations only).
+ *
+ * sack_delay -  This parameter contains the number of milliseconds that
+ *    the user is requesting the delayed ACK timer be set to.  Note that
+ *    this value is defined in the standard to be between 200 and 500
+ *    milliseconds.
+ *
+ * sack_freq -  This parameter contains the number of packets that must
+ *    be received before a sack is sent without waiting for the delay
+ *    timer to expire.  The default value for this is 2, setting this
+ *    value to 1 will disable the delayed sack algorithm.
  */
 
-static int sctp_setsockopt_delayed_ack_time(struct sock *sk,
+static int sctp_setsockopt_delayed_ack(struct sock *sk,
 					    char __user *optval, int optlen)
 {
-	struct sctp_assoc_value  params;
+	struct sctp_sack_info    params;
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 
-	if (optlen != sizeof(struct sctp_assoc_value))
-		return - EINVAL;
+	if (optlen >= sizeof(struct sctp_sack_info)) {
+		optlen = sizeof(struct sctp_sack_info);
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
+		if (copy_from_user(&params, optval, optlen))
+			return -EFAULT;
+
+		if (params.sack_delay = 0 && params.sack_freq = 0)
+			return 0;
+
+		if (params.sack_freq)
+			params.sack_delay = 0;
+	} else if (optlen = sizeof(struct sctp_assoc_value)) {
+		printk(KERN_WARNING "SCTP: Use of struct sctp_sack_info "
+		       "in delayed_ack socket option deprecated\n");
+		printk(KERN_WARNING "SCTP: struct sctp_sack_info instead\n");
+		if (copy_from_user(&params, optval, optlen))
+			return -EFAULT;
+	} else
+		return - EINVAL;
 
 	/* Validate value parameter. */
-	if (params.assoc_value > 500)
+	if (params.sack_delay > 500)
 		return -EINVAL;
 
-	/* Get association, if assoc_id != 0 and the socket is a one
+	/* Get association, if sack_assoc_id != 0 and the socket is a one
 	 * to many style socket, and an association was not found, then
 	 * the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id && sctp_style(sk, UDP))
+	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
+	if (!asoc && params.sack_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
-	if (params.assoc_value) {
+	if (params.sack_delay) {
 		if (asoc) {
 			asoc->sackdelay -				msecs_to_jiffies(params.assoc_value);
+				msecs_to_jiffies(params.sack_delay);
 			asoc->param_flags  				(asoc->param_flags & ~SPP_SACKDELAY) |
 				SPP_SACKDELAY_ENABLE;
 		} else {
-			sp->sackdelay = params.assoc_value;
+			sp->sackdelay = params.sack_delay;
 			sp->param_flags  				(sp->param_flags & ~SPP_SACKDELAY) |
 				SPP_SACKDELAY_ENABLE;
@@ -2401,9 +2423,9 @@ static int sctp_setsockopt_delayed_ack_t
 		list_for_each(pos, &asoc->peer.transport_addr_list) {
 			trans = list_entry(pos, struct sctp_transport,
 					   transports);
-			if (params.assoc_value) {
+			if (params.sack_delay) {
 				trans->sackdelay -					msecs_to_jiffies(params.assoc_value);
+					msecs_to_jiffies(params.sack_delay);
 				trans->param_flags  					(trans->param_flags & ~SPP_SACKDELAY) |
 					SPP_SACKDELAY_ENABLE;
@@ -3204,8 +3226,8 @@ SCTP_STATIC int sctp_setsockopt(struct s
 		retval = sctp_setsockopt_peer_addr_params(sk, optval, optlen);
 		break;
 
-	case SCTP_DELAYED_ACK_TIME:
-		retval = sctp_setsockopt_delayed_ack_time(sk, optval, optlen);
+	case SCTP_DELAYED_ACK:
+		retval = sctp_setsockopt_delayed_ack(sk, optval, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
 		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
@@ -4017,70 +4039,90 @@ static int sctp_getsockopt_peer_addr_par
 	return 0;
 }
 
-/* 7.1.23. Delayed Ack Timer (SCTP_DELAYED_ACK_TIME)
+/*
+ * 7.1.23.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
  *
- *   This options will get or set the delayed ack timer.  The time is set
- *   in milliseconds.  If the assoc_id is 0, then this sets or gets the
- *   endpoints default delayed ack timer value.  If the assoc_id field is
- *   non-zero, then the set or get effects the specified association.
- *
- *   struct sctp_assoc_value {
- *       sctp_assoc_t            assoc_id;
- *       uint32_t                assoc_value;
- *   };
- *
- *     assoc_id    - This parameter, indicates which association the
- *                   user is preforming an action upon. Note that if
- *                   this field's value is zero then the endpoints
- *                   default value is changed (effecting future
- *                   associations only).
- *
- *     assoc_value - This parameter contains the number of milliseconds
- *                   that the user is requesting the delayed ACK timer
- *                   be set to. Note that this value is defined in
- *                   the standard to be between 200 and 500 milliseconds.
- *
- *                   Note: a value of zero will leave the value alone,
- *                   but disable SACK delay. A non-zero value will also
- *                   enable SACK delay.
+ * This option will effect the way delayed acks are performed.  This
+ * option allows you to get or set the delayed ack time, in
+ * milliseconds.  It also allows changing the delayed ack frequency.
+ * Changing the frequency to 1 disables the delayed sack algorithm.  If
+ * the assoc_id is 0, then this sets or gets the endpoints default
+ * values.  If the assoc_id field is non-zero, then the set or get
+ * effects the specified association for the one to many model (the
+ * assoc_id field is ignored by the one to one model).  Note that if
+ * sack_delay or sack_freq are 0 when setting this option, then the
+ * current values will remain unchanged.
+ * 
+ * struct sctp_sack_info {
+ *     sctp_assoc_t            sack_assoc_id;
+ *     uint32_t                sack_delay;
+ *     uint32_t                sack_freq;
+ * };
+ *
+ * sack_assoc_id -  This parameter, indicates which association the user
+ *    is performing an action upon.  Note that if this field's value is
+ *    zero then the endpoints default value is changed (effecting future
+ *    associations only).
+ *
+ * sack_delay -  This parameter contains the number of milliseconds that
+ *    the user is requesting the delayed ACK timer be set to.  Note that
+ *    this value is defined in the standard to be between 200 and 500
+ *    milliseconds.
+ *
+ * sack_freq -  This parameter contains the number of packets that must
+ *    be received before a sack is sent without waiting for the delay
+ *    timer to expire.  The default value for this is 2, setting this
+ *    value to 1 will disable the delayed sack algorithm.
  */
-static int sctp_getsockopt_delayed_ack_time(struct sock *sk, int len,
+static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 					    char __user *optval,
 					    int __user *optlen)
 {
-	struct sctp_assoc_value  params;
+	struct sctp_sack_info    params;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 
-	if (len < sizeof(struct sctp_assoc_value))
-		return - EINVAL;
-
-	len = sizeof(struct sctp_assoc_value);
+	if (len >= sizeof(struct sctp_sack_info)) {
+		len = sizeof(struct sctp_sack_info);
 
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+		if (copy_from_user(&params, optval, len))
+			return -EFAULT;
+	} else if (len = sizeof(struct sctp_assoc_value)) {
+		printk(KERN_WARNING "SCTP: Use of struct sctp_sack_info "
+		       "in delayed_ack socket option deprecated\n");
+		printk(KERN_WARNING "SCTP: struct sctp_sack_info instead\n");
+		if (copy_from_user(&params, optval, len))
+			return -EFAULT;
+	} else 
+		return - EINVAL;
 
-	/* Get association, if assoc_id != 0 and the socket is a one
+	/* Get association, if sack_assoc_id != 0 and the socket is a one
 	 * to many style socket, and an association was not found, then
 	 * the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id && sctp_style(sk, UDP))
+	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
+	if (!asoc && params.sack_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		/* Fetch association values. */
-		if (asoc->param_flags & SPP_SACKDELAY_ENABLE)
-			params.assoc_value = jiffies_to_msecs(
+		if (asoc->param_flags & SPP_SACKDELAY_ENABLE) {
+			params.sack_delay = jiffies_to_msecs(
 				asoc->sackdelay);
-		else
-			params.assoc_value = 0;
+			params.sack_freq = 0;
+		} else {
+			params.sack_delay = 0;
+			params.sack_freq = 1;
+		}
 	} else {
 		/* Fetch socket values. */
-		if (sp->param_flags & SPP_SACKDELAY_ENABLE)
-			params.assoc_value  = sp->sackdelay;
-		else
-			params.assoc_value  = 0;
+		if (sp->param_flags & SPP_SACKDELAY_ENABLE) {
+			params.sack_delay  = sp->sackdelay;
+			params.sack_freq = 0;
+		} else {
+			params.sack_delay  = 0;
+			params.sack_freq = 1;
+		}
 	}
 
 	if (copy_to_user(optval, &params, len))
@@ -5238,8 +5280,8 @@ SCTP_STATIC int sctp_getsockopt(struct s
 		retval = sctp_getsockopt_peer_addr_params(sk, len, optval,
 							  optlen);
 		break;
-	case SCTP_DELAYED_ACK_TIME:
-		retval = sctp_getsockopt_delayed_ack_time(sk, len, optval,
+	case SCTP_DELAYED_ACK:
+		retval = sctp_getsockopt_delayed_ack(sk, len, optval,
 							  optlen);
 		break;
 	case SCTP_INITMSG:


