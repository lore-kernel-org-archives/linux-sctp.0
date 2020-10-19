From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:32 +0000
Subject: [PATCHv4 net-next 15/16] sctp: handle the init chunk matching an existing asoc
Message-Id: <81779bb5f9dbe452d91904f617d8083f1ba91a34.1603110316.git.lucien.xin@gmail.com>
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
 <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This is from Section 4 of draft-tuexen-tsvwg-sctp-udp-encaps-cons-03,
and it requires responding with an abort chunk with an error cause
when the udp source port of the received init chunk doesn't match the
encap port of the transport.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8edab15..af2b704 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -87,6 +87,13 @@ static enum sctp_disposition sctp_sf_tabort_8_4_8(
 					const union sctp_subtype type,
 					void *arg,
 					struct sctp_cmd_seq *commands);
+static enum sctp_disposition sctp_sf_new_encap_port(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					const struct sctp_association *asoc,
+					const union sctp_subtype type,
+					void *arg,
+					struct sctp_cmd_seq *commands);
 static struct sctp_sackhdr *sctp_sm_pull_sack(struct sctp_chunk *chunk);
 
 static enum sctp_disposition sctp_stop_t1_and_abort(
@@ -1493,6 +1500,10 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
+
+	if (SCTP_INPUT_CB(chunk->skb)->encap_port != chunk->transport->encap_port)
+		return sctp_sf_new_encap_port(net, ep, asoc, type, arg, commands);
+
 	/* Grab the INIT header.  */
 	chunk->subh.init_hdr = (struct sctp_inithdr *)chunk->skb->data;
 
@@ -3392,6 +3403,45 @@ static enum sctp_disposition sctp_sf_tabort_8_4_8(
 
 	sctp_packet_append_chunk(packet, abort);
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT, SCTP_PACKET(packet));
+
+	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
+
+	sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	return SCTP_DISPOSITION_CONSUME;
+}
+
+/* Handling of SCTP Packets Containing an INIT Chunk Matching an
+ * Existing Associations when the UDP encap port is incorrect.
+ *
+ * From Section 4 at draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
+ */
+static enum sctp_disposition sctp_sf_new_encap_port(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					const struct sctp_association *asoc,
+					const union sctp_subtype type,
+					void *arg,
+					struct sctp_cmd_seq *commands)
+{
+	struct sctp_packet *packet = NULL;
+	struct sctp_chunk *chunk = arg;
+	struct sctp_chunk *abort;
+
+	packet = sctp_ootb_pkt_new(net, asoc, chunk);
+	if (!packet)
+		return SCTP_DISPOSITION_NOMEM;
+
+	abort = sctp_make_new_encap_port(asoc, chunk);
+	if (!abort) {
+		sctp_ootb_pkt_free(packet);
+		return SCTP_DISPOSITION_NOMEM;
+	}
+
+	abort->skb->sk = ep->base.sk;
+
+	sctp_packet_append_chunk(packet, abort);
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT,
 			SCTP_PACKET(packet));
 
-- 
2.1.0
