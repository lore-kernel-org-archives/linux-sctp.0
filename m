From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:34 +0000
Subject: [PATCHv3 net-next 09/16] sctp: allow changing transport encap_port by peer packets
Message-Id: <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
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
In-Reply-To: <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

As rfc6951#section-5.4 says:

  "After finding the SCTP association (which
   includes checking the verification tag), the UDP source port MUST be
   stored as the encapsulation port for the destination address the SCTP
   packet is received from (see Section 5.1).

   When a non-encapsulated SCTP packet is received by the SCTP stack,
   the encapsulation of outgoing packets belonging to the same
   association and the corresponding destination address MUST be
   disabled."

transport encap_port should be updated by a validated incoming packet's
udp src port.

We save the udp src port in sctp_input_cb->encap_port, and then update
the transport in two places:

  1. right after vtag is verified, which is required by RFC, and this
     allows the existent transports to be updated by the chunks that
     can only be processed on an asoc.

  2. right before processing the 'init' where the transports are added,
     and this allows building a sctp over udp connection by client with
     the server not knowing the remote encap port.

  3. when processing ootb_pkt and creating the temporary transport for
     the reply pkt.

Note that sctp_input_cb->header is removed, as it's not used any more
in sctp.

v1->v2:
  - Change encap_port as __be16 for sctp_input_cb.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sm.h      |  1 +
 include/net/sctp/structs.h |  7 +------
 net/sctp/ipv6.c            |  1 +
 net/sctp/protocol.c        | 11 ++++++++++-
 net/sctp/sm_make_chunk.c   |  1 +
 net/sctp/sm_statefuns.c    |  2 ++
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 5c491a3..a499341 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -380,6 +380,7 @@ sctp_vtag_verify(const struct sctp_chunk *chunk,
         if (ntohl(chunk->sctp_hdr->vtag) = asoc->c.my_vtag)
                 return 1;
 
+	chunk->transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
 	return 0;
 }
 
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index aa98e7e..81464ae 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1120,14 +1120,9 @@ static inline void sctp_outq_cork(struct sctp_outq *q)
  * sctp_input_cb is currently used on rx and sock rx queue
  */
 struct sctp_input_cb {
-	union {
-		struct inet_skb_parm	h4;
-#if IS_ENABLED(CONFIG_IPV6)
-		struct inet6_skb_parm	h6;
-#endif
-	} header;
 	struct sctp_chunk *chunk;
 	struct sctp_af *af;
+	__be16 encap_port;
 };
 #define SCTP_INPUT_CB(__skb)	((struct sctp_input_cb *)&((__skb)->cb[0]))
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 8a58f42..a064bf2 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1053,6 +1053,7 @@ static struct inet_protosw sctpv6_stream_protosw = {
 
 static int sctp6_rcv(struct sk_buff *skb)
 {
+	memset(skb->cb, 0, sizeof(skb->cb));
 	return sctp_rcv(skb) ? -1 : 0;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 5b74187..0d16e5e 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -843,6 +843,9 @@ static int sctp_ctl_sock_init(struct net *net)
 
 static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	memset(skb->cb, 0, sizeof(skb->cb));
+	SCTP_INPUT_CB(skb)->encap_port = udp_hdr(skb)->source;
+
 	skb_set_transport_header(skb, sizeof(struct udphdr));
 	sctp_rcv(skb);
 	return 0;
@@ -1139,9 +1142,15 @@ static struct inet_protosw sctp_stream_protosw = {
 	.flags      = SCTP_PROTOSW_FLAG
 };
 
+static int sctp4_rcv(struct sk_buff *skb)
+{
+	memset(skb->cb, 0, sizeof(skb->cb));
+	return sctp_rcv(skb);
+}
+
 /* Register with IP layer.  */
 static const struct net_protocol sctp_protocol = {
-	.handler     = sctp_rcv,
+	.handler     = sctp4_rcv,
 	.err_handler = sctp_v4_err,
 	.no_policy   = 1,
 	.netns_ok    = 1,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9a56ae2..21d0ff1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2321,6 +2321,7 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	 * added as the primary transport.  The source address seems to
 	 * be a better choice than any of the embedded addresses.
 	 */
+	asoc->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
 	if (!sctp_assoc_add_peer(asoc, peer_addr, gfp, SCTP_ACTIVE))
 		goto nomem;
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c669f8b..8edab15 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6268,6 +6268,8 @@ static struct sctp_packet *sctp_ootb_pkt_new(
 	if (!transport)
 		goto nomem;
 
+	transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
+
 	/* Cache a route for the transport with the chunk's destination as
 	 * the source address.
 	 */
-- 
2.1.0
