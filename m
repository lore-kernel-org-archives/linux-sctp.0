From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:31 +0000
Subject: [PATCHv4 net-next 14/16] sctp: add the error cause for new encapsulation port restart
Message-Id: <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
 <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
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
