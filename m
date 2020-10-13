From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:39 +0000
Subject: [PATCHv3 net-next 14/16] sctp: add the error cause for new encapsulation port restart
Message-Id: <df18ce9f94be0a58bbf1743071993b95696aed2d.1602574012.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
 <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
 <46f33eb9331b7e1e688a7f125201ad600ae83fbd.1602574012.git.lucien.xin@gmail.com>
 <c79a0be422c96fec9da194a20853811d93809393.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <c79a0be422c96fec9da194a20853811d93809393.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This patch is to add the function to make the abort chunk with
the error cause for new encapsulation port restart, defined
on Section 4.4 in draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.

v1->v2:
  - no change.
v2->v3:
  - no need to call htons() when setting nep.cur_port/new_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     | 20 ++++++++++++++++++++
 include/net/sctp/sm.h    |  3 +++
 net/sctp/sm_make_chunk.c | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 7673123..bb19265 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -482,11 +482,13 @@ enum sctp_error {
 	 *  11  Restart of an association with new addresses
 	 *  12  User Initiated Abort
 	 *  13  Protocol Violation
+	 *  14  Restart of an Association with New Encapsulation Port
 	 */
 
 	SCTP_ERROR_RESTART         = cpu_to_be16(0x0b),
 	SCTP_ERROR_USER_ABORT      = cpu_to_be16(0x0c),
 	SCTP_ERROR_PROTO_VIOLATION = cpu_to_be16(0x0d),
+	SCTP_ERROR_NEW_ENCAP_PORT  = cpu_to_be16(0x0e),
 
 	/* ADDIP Section 3.3  New Error Causes
 	 *
@@ -793,4 +795,22 @@ enum {
 	SCTP_FLOWLABEL_VAL_MASK = 0xfffff
 };
 
+/* UDP Encapsulation
+ * draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html#section-4-4
+ *
+ *   The error cause indicating an "Restart of an Association with
+ *   New Encapsulation Port"
+ *
+ * 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |        Cause Code = 14        |       Cause Length = 8        |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |   Current Encapsulation Port  |     New Encapsulation Port    |
+ * +-------------------------------+-------------------------------+
+ */
+struct sctp_new_encap_port_hdr {
+	__be16 cur_port;
+	__be16 new_port;
+};
+
 #endif /* __LINUX_SCTP_H__ */
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index a499341..fd223c9 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -221,6 +221,9 @@ struct sctp_chunk *sctp_make_violation_paramlen(
 struct sctp_chunk *sctp_make_violation_max_retrans(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk);
+struct sctp_chunk *sctp_make_new_encap_port(
+					const struct sctp_association *asoc,
+					const struct sctp_chunk *chunk);
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport);
 struct sctp_chunk *sctp_make_heartbeat_ack(const struct sctp_association *asoc,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 21d0ff1..f77484d 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1142,6 +1142,26 @@ struct sctp_chunk *sctp_make_violation_max_retrans(
 	return retval;
 }
 
+struct sctp_chunk *sctp_make_new_encap_port(const struct sctp_association *asoc,
+					    const struct sctp_chunk *chunk)
+{
+	struct sctp_new_encap_port_hdr nep;
+	struct sctp_chunk *retval;
+
+	retval = sctp_make_abort(asoc, chunk,
+				 sizeof(struct sctp_errhdr) + sizeof(nep));
+	if (!retval)
+		goto nodata;
+
+	sctp_init_cause(retval, SCTP_ERROR_NEW_ENCAP_PORT, sizeof(nep));
+	nep.cur_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
+	nep.new_port = chunk->transport->encap_port;
+	sctp_addto_chunk(retval, sizeof(nep), &nep);
+
+nodata:
+	return retval;
+}
+
 /* Make a HEARTBEAT chunk.  */
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport)
-- 
2.1.0
