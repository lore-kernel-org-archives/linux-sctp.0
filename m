From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:33 +0000
Subject: [PATCHv3 net-next 08/16] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Message-Id: <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This patch is to implement:

  rfc6951#section-6.1: Get or Set the Remote UDP Encapsulation Port Number

with the param of the struct:

  struct sctp_udpencaps {
    sctp_assoc_t sue_assoc_id;
    struct sockaddr_storage sue_address;
    uint16_t sue_port;
  };

the encap_port of sock, assoc or transport can be changed by users,
which also means it allows the different transports of the same asoc
to have different encap_port value.

v1->v2:
  - no change.
v2->v3:
  - fix the endian warning when setting values between encap_port and
    sue_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |   7 +++
 net/sctp/socket.c         | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 28ad40d..cb78e7a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -140,6 +140,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ECN_SUPPORTED	130
 #define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 #define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
+#define SCTP_REMOTE_UDP_ENCAPS_PORT	132
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -1197,6 +1198,12 @@ struct sctp_event {
 	uint8_t se_on;
 };
 
+struct sctp_udpencaps {
+	sctp_assoc_t sue_assoc_id;
+	struct sockaddr_storage sue_address;
+	uint16_t sue_port;
+};
+
 /* SCTP Stream schedulers */
 enum sctp_sched_type {
 	SCTP_SS_FCFS,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 09b94cd..26e464b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4417,6 +4417,55 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_encap_port(struct sock *sk,
+				      struct sctp_udpencaps *encap,
+				      unsigned int optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	__be16 encap_port;
+
+	if (optlen != sizeof(*encap))
+		return -EINVAL;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	encap_port = (__force __be16)encap->sue_port;
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap->sue_address,
+					   encap->sue_assoc_id);
+		if (!t)
+			return -EINVAL;
+
+		t->encap_port = encap_port;
+		return 0;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap->sue_assoc_id);
+	if (!asoc && encap->sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	/* If changes are for association, also apply encap to each
+	 * transport.
+	 */
+	if (asoc) {
+		list_for_each_entry(t, &asoc->peer.transport_addr_list,
+				    transports)
+			t->encap_port = encap_port;
+
+		return 0;
+	}
+
+	sctp_sk(sk)->encap_port = encap_port;
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4636,6 +4685,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_setsockopt_encap_port(sk, kopt, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7791,6 +7843,65 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_encap_port(struct sock *sk, int len,
+				      char __user *optval, int __user *optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_udpencaps encap;
+	struct sctp_transport *t;
+	__be16 encap_port;
+
+	if (len < sizeof(encap))
+		return -EINVAL;
+
+	len = sizeof(encap);
+	if (copy_from_user(&encap, optval, len))
+		return -EFAULT;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap.sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap.sue_address,
+					   encap.sue_assoc_id);
+		if (!t) {
+			pr_debug("%s: failed no transport\n", __func__);
+			return -EINVAL;
+		}
+
+		encap_port = t->encap_port;
+		goto out;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap.sue_assoc_id);
+	if (!asoc && encap.sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		pr_debug("%s: failed no association\n", __func__);
+		return -EINVAL;
+	}
+
+	if (asoc) {
+		encap_port = asoc->encap_port;
+		goto out;
+	}
+
+	encap_port = sctp_sk(sk)->encap_port;
+
+out:
+	encap.sue_port = (__force uint16_t)encap_port;
+	if (copy_to_user(optval, &encap, len))
+		return -EFAULT;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -8011,6 +8122,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_getsockopt_pf_expose(sk, len, optval, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_getsockopt_encap_port(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0
