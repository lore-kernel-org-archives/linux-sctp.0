From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 02 Jul 2018 10:21:13 +0000
Subject: [PATCHv2 net-next 3/5] sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams
Message-Id: <cbeee9df0afd61d4f1bf1ac08a627b1d8e9dcf6a.1530526661.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1530526661.git.lucien.xin@gmail.com>
 <6504d3609be85e1574b6f44051d2523342f9e955.1530526661.git.lucien.xin@gmail.com>
 <d4512b8239763cedc076bdbc3a10fe1fb9e88481.1530526661.git.lucien.xin@gmail.com>
In-Reply-To: <d4512b8239763cedc076bdbc3a10fe1fb9e88481.1530526661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, hideaki.yoshifuji@miraclelinux.com

spp_ipv6_flowlabel and spp_dscp are added in sctp_paddrparams in
this patch so that users could set sctp_sock/asoc/transport dscp
and flowlabel with spp_flags SPP_IPV6_FLOWLABEL or SPP_DSCP by
SCTP_PEER_ADDR_PARAMS , as described section 8.1.12 in RFC6458.

As said in last patch, it uses '| 0x100000' or '|0x1' to mark
flowlabel or dscp is set,  so that their values could be set
to 0.

Note that to guarantee that an old app built with old kernel
headers could work on the newer kernel, the param's check in
sctp_g/setsockopt_peer_addr_params() is also improved, which
follows the way that sctp_g/setsockopt_delayed_ack() or some
other sockopts' process that accept two types of params does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |   4 ++
 net/sctp/socket.c         | 177 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 175 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index c02986a..b479db5 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -763,6 +763,8 @@ enum  sctp_spp_flags {
 	SPP_SACKDELAY_DISABLE = 1<<6,	/*Disable SACK*/
 	SPP_SACKDELAY = SPP_SACKDELAY_ENABLE | SPP_SACKDELAY_DISABLE,
 	SPP_HB_TIME_IS_ZERO = 1<<7,	/* Set HB delay to 0 */
+	SPP_IPV6_FLOWLABEL = 1<<8,
+	SPP_DSCP = 1<<9,
 };
 
 struct sctp_paddrparams {
@@ -773,6 +775,8 @@ struct sctp_paddrparams {
 	__u32			spp_pathmtu;
 	__u32			spp_sackdelay;
 	__u32			spp_flags;
+	__u32			spp_ipv6_flowlabel;
+	__u8			spp_dscp;
 } __attribute__((packed, aligned(4)));
 
 /*
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf11f9c..452029f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2393,6 +2393,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
  *     uint32_t                spp_pathmtu;
  *     uint32_t                spp_sackdelay;
  *     uint32_t                spp_flags;
+ *     uint32_t                spp_ipv6_flowlabel;
+ *     uint8_t                 spp_dscp;
  * };
  *
  *   spp_assoc_id    - (one-to-many style socket) This is filled in the
@@ -2472,6 +2474,45 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
  *                     also that this field is mutually exclusive to
  *                     SPP_SACKDELAY_ENABLE, setting both will have undefined
  *                     results.
+ *
+ *                     SPP_IPV6_FLOWLABEL:  Setting this flag enables the
+ *                     setting of the IPV6 flow label value.  The value is
+ *                     contained in the spp_ipv6_flowlabel field.
+ *                     Upon retrieval, this flag will be set to indicate that
+ *                     the spp_ipv6_flowlabel field has a valid value returned.
+ *                     If a specific destination address is set (in the
+ *                     spp_address field), then the value returned is that of
+ *                     the address.  If just an association is specified (and
+ *                     no address), then the association's default flow label
+ *                     is returned.  If neither an association nor a destination
+ *                     is specified, then the socket's default flow label is
+ *                     returned.  For non-IPv6 sockets, this flag will be left
+ *                     cleared.
+ *
+ *                     SPP_DSCP:  Setting this flag enables the setting of the
+ *                     Differentiated Services Code Point (DSCP) value
+ *                     associated with either the association or a specific
+ *                     address.  The value is obtained in the spp_dscp field.
+ *                     Upon retrieval, this flag will be set to indicate that
+ *                     the spp_dscp field has a valid value returned.  If a
+ *                     specific destination address is set when called (in the
+ *                     spp_address field), then that specific destination
+ *                     address's DSCP value is returned.  If just an association
+ *                     is specified, then the association's default DSCP is
+ *                     returned.  If neither an association nor a destination is
+ *                     specified, then the socket's default DSCP is returned.
+ *
+ *   spp_ipv6_flowlabel
+ *                   - This field is used in conjunction with the
+ *                     SPP_IPV6_FLOWLABEL flag and contains the IPv6 flow label.
+ *                     The 20 least significant bits are used for the flow
+ *                     label.  This setting has precedence over any IPv6-layer
+ *                     setting.
+ *
+ *   spp_dscp        - This field is used in conjunction with the SPP_DSCP flag
+ *                     and contains the DSCP.  The 6 most significant bits are
+ *                     used for the DSCP.  This setting has precedence over any
+ *                     IPv4- or IPv6- layer setting.
  */
 static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 				       struct sctp_transport   *trans,
@@ -2611,6 +2652,51 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 		}
 	}
 
+	if (params->spp_flags & SPP_IPV6_FLOWLABEL) {
+		if (trans && trans->ipaddr.sa.sa_family = AF_INET6) {
+			trans->flowlabel = params->spp_ipv6_flowlabel &
+					   SCTP_FLOWLABEL_VAL_MASK;
+			trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+		} else if (asoc) {
+			list_for_each_entry(trans,
+					    &asoc->peer.transport_addr_list,
+					    transports) {
+				if (trans->ipaddr.sa.sa_family != AF_INET6)
+					continue;
+				trans->flowlabel = params->spp_ipv6_flowlabel &
+						   SCTP_FLOWLABEL_VAL_MASK;
+				trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+			}
+			asoc->flowlabel = params->spp_ipv6_flowlabel &
+					  SCTP_FLOWLABEL_VAL_MASK;
+			asoc->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+		} else if (sctp_opt2sk(sp)->sk_family = AF_INET6) {
+			sp->flowlabel = params->spp_ipv6_flowlabel &
+					SCTP_FLOWLABEL_VAL_MASK;
+			sp->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+		}
+	}
+
+	if (params->spp_flags & SPP_DSCP) {
+		if (trans) {
+			trans->dscp = params->spp_dscp & SCTP_DSCP_VAL_MASK;
+			trans->dscp |= SCTP_DSCP_SET_MASK;
+		} else if (asoc) {
+			list_for_each_entry(trans,
+					    &asoc->peer.transport_addr_list,
+					    transports) {
+				trans->dscp = params->spp_dscp &
+					      SCTP_DSCP_VAL_MASK;
+				trans->dscp |= SCTP_DSCP_SET_MASK;
+			}
+			asoc->dscp = params->spp_dscp & SCTP_DSCP_VAL_MASK;
+			asoc->dscp |= SCTP_DSCP_SET_MASK;
+		} else {
+			sp->dscp = params->spp_dscp & SCTP_DSCP_VAL_MASK;
+			sp->dscp |= SCTP_DSCP_SET_MASK;
+		}
+	}
+
 	return 0;
 }
 
@@ -2625,11 +2711,18 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	int error;
 	int hb_change, pmtud_change, sackdelay_change;
 
-	if (optlen != sizeof(struct sctp_paddrparams))
+	if (optlen = sizeof(params)) {
+		if (copy_from_user(&params, optval, optlen))
+			return -EFAULT;
+	} else if (optlen = ALIGN(offsetof(struct sctp_paddrparams,
+					    spp_ipv6_flowlabel), 4)) {
+		if (copy_from_user(&params, optval, optlen))
+			return -EFAULT;
+		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
+			return -EINVAL;
+	} else {
 		return -EINVAL;
-
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
+	}
 
 	/* Validate flags and value parameters. */
 	hb_change        = params.spp_flags & SPP_HB;
@@ -5453,6 +5546,45 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
  *                     also that this field is mutually exclusive to
  *                     SPP_SACKDELAY_ENABLE, setting both will have undefined
  *                     results.
+ *
+ *                     SPP_IPV6_FLOWLABEL:  Setting this flag enables the
+ *                     setting of the IPV6 flow label value.  The value is
+ *                     contained in the spp_ipv6_flowlabel field.
+ *                     Upon retrieval, this flag will be set to indicate that
+ *                     the spp_ipv6_flowlabel field has a valid value returned.
+ *                     If a specific destination address is set (in the
+ *                     spp_address field), then the value returned is that of
+ *                     the address.  If just an association is specified (and
+ *                     no address), then the association's default flow label
+ *                     is returned.  If neither an association nor a destination
+ *                     is specified, then the socket's default flow label is
+ *                     returned.  For non-IPv6 sockets, this flag will be left
+ *                     cleared.
+ *
+ *                     SPP_DSCP:  Setting this flag enables the setting of the
+ *                     Differentiated Services Code Point (DSCP) value
+ *                     associated with either the association or a specific
+ *                     address.  The value is obtained in the spp_dscp field.
+ *                     Upon retrieval, this flag will be set to indicate that
+ *                     the spp_dscp field has a valid value returned.  If a
+ *                     specific destination address is set when called (in the
+ *                     spp_address field), then that specific destination
+ *                     address's DSCP value is returned.  If just an association
+ *                     is specified, then the association's default DSCP is
+ *                     returned.  If neither an association nor a destination is
+ *                     specified, then the socket's default DSCP is returned.
+ *
+ *   spp_ipv6_flowlabel
+ *                   - This field is used in conjunction with the
+ *                     SPP_IPV6_FLOWLABEL flag and contains the IPv6 flow label.
+ *                     The 20 least significant bits are used for the flow
+ *                     label.  This setting has precedence over any IPv6-layer
+ *                     setting.
+ *
+ *   spp_dscp        - This field is used in conjunction with the SPP_DSCP flag
+ *                     and contains the DSCP.  The 6 most significant bits are
+ *                     used for the DSCP.  This setting has precedence over any
+ *                     IPv4- or IPv6- layer setting.
  */
 static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 					    char __user *optval, int __user *optlen)
@@ -5462,9 +5594,15 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 
-	if (len < sizeof(struct sctp_paddrparams))
+	if (len >= sizeof(params))
+		len = sizeof(params);
+	else if (len >= ALIGN(offsetof(struct sctp_paddrparams,
+				       spp_ipv6_flowlabel), 4))
+		len = ALIGN(offsetof(struct sctp_paddrparams,
+				     spp_ipv6_flowlabel), 4);
+	else
 		return -EINVAL;
-	len = sizeof(struct sctp_paddrparams);
+
 	if (copy_from_user(&params, optval, len))
 		return -EFAULT;
 
@@ -5499,6 +5637,15 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 
 		/*draft-11 doesn't say what to return in spp_flags*/
 		params.spp_flags      = trans->param_flags;
+		if (trans->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
+			params.spp_ipv6_flowlabel = trans->flowlabel &
+						    SCTP_FLOWLABEL_VAL_MASK;
+			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+		}
+		if (trans->dscp & SCTP_DSCP_SET_MASK) {
+			params.spp_dscp	= trans->dscp & SCTP_DSCP_VAL_MASK;
+			params.spp_flags |= SPP_DSCP;
+		}
 	} else if (asoc) {
 		/* Fetch association values. */
 		params.spp_hbinterval = jiffies_to_msecs(asoc->hbinterval);
@@ -5508,6 +5655,15 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 
 		/*draft-11 doesn't say what to return in spp_flags*/
 		params.spp_flags      = asoc->param_flags;
+		if (asoc->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
+			params.spp_ipv6_flowlabel = asoc->flowlabel &
+						    SCTP_FLOWLABEL_VAL_MASK;
+			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+		}
+		if (asoc->dscp & SCTP_DSCP_SET_MASK) {
+			params.spp_dscp	= asoc->dscp & SCTP_DSCP_VAL_MASK;
+			params.spp_flags |= SPP_DSCP;
+		}
 	} else {
 		/* Fetch socket values. */
 		params.spp_hbinterval = sp->hbinterval;
@@ -5517,6 +5673,15 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 
 		/*draft-11 doesn't say what to return in spp_flags*/
 		params.spp_flags      = sp->param_flags;
+		if (sp->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
+			params.spp_ipv6_flowlabel = sp->flowlabel &
+						    SCTP_FLOWLABEL_VAL_MASK;
+			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+		}
+		if (sp->dscp & SCTP_DSCP_SET_MASK) {
+			params.spp_dscp	= sp->dscp & SCTP_DSCP_VAL_MASK;
+			params.spp_flags |= SPP_DSCP;
+		}
 	}
 
 	if (copy_to_user(optval, &params, len))
-- 
2.1.0

