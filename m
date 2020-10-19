From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:27 +0000
Subject: [PATCHv4 net-next 10/16] sctp: add udphdr to overhead when udp_port is set
Message-Id: <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
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
In-Reply-To: <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

sctp_mtu_payload() is for calculating the frag size before making
chunks from a msg. So we should only add udphdr size to overhead
when udp socks are listening, as only then sctp can handle the
incoming sctp over udp packets and outgoing sctp over udp packets
will be possible.

Note that we can't do this according to transport->encap_port, as
different transports may be set to different values, while the
chunks were made before choosing the transport, we could not be
able to meet all rfc6951#section-5.6 recommends.

v1->v2:
  - Add udp_port for sctp_sock to avoid a potential race issue, it
    will be used in xmit path in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h    | 7 +++++--
 include/net/sctp/structs.h | 1 +
 net/sctp/socket.c          | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index bfd87a0..86f74f2 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -578,10 +578,13 @@ static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
 {
 	__u32 overhead = sizeof(struct sctphdr) + extra;
 
-	if (sp)
+	if (sp) {
 		overhead += sp->pf->af->net_header_len;
-	else
+		if (sp->udp_port)
+			overhead += sizeof(struct udphdr);
+	} else {
 		overhead += sizeof(struct ipv6hdr);
+	}
 
 	if (WARN_ON_ONCE(mtu && mtu <= overhead))
 		mtu = overhead;
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 81464ae..80f7149 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,7 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__be16 udp_port;
 	__be16 encap_port;
 
 	/* This is the max_retrans value for new associations. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2a9ee9b..a710917 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4928,6 +4928,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->udp_port    = htons(net->sctp.udp_port);
 	sp->encap_port  = htons(net->sctp.encap_port);
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
-- 
2.1.0
