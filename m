From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:50 +0000
Subject: [PATCH net-next 8/8] sctp: remove net sctp.x_enable working as a global switch
Message-Id: <37fe4fef4061a07a201684eef6377c9a2d5641e4.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
 <a2e37d8eb5b502e747eca1951e21c3d249bacf06.1566223325.git.lucien.xin@gmail.com>
 <b45828d4f886e9d1e92a8b68c1932af9ff80b562.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <b45828d4f886e9d1e92a8b68c1932af9ff80b562.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

The netns sctp feature flags shouldn't work as a global switch,
which is mostly like a firewall/netfilter's job. Also, it will
break asoc as it discard or accept chunks incorrectly when net
sctp.x_enable is changed after the asoc is created.

Since each type of chunk's processing function will check the
corresp asoc's feature flag, this 'global switch' should be
removed, and net sctp.x_enable will only work as the default
feature flags for the future sctp sockets/endpoints.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statetable.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 61ed9c6..88ea87f 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -976,26 +976,22 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
 	if (cid <= SCTP_CID_BASE_MAX)
 		return &chunk_event_table[cid][state];
 
-	if (net->sctp.prsctp_enable) {
-		if (cid = SCTP_CID_FWD_TSN || cid = SCTP_CID_I_FWD_TSN)
-			return &prsctp_chunk_event_table[0][state];
-	}
+	switch ((u16)cid) {
+	case SCTP_CID_FWD_TSN:
+	case SCTP_CID_I_FWD_TSN:
+		return &prsctp_chunk_event_table[0][state];
 
-	if (net->sctp.addip_enable) {
-		if (cid = SCTP_CID_ASCONF)
-			return &addip_chunk_event_table[0][state];
+	case SCTP_CID_ASCONF:
+		return &addip_chunk_event_table[0][state];
 
-		if (cid = SCTP_CID_ASCONF_ACK)
-			return &addip_chunk_event_table[1][state];
-	}
+	case SCTP_CID_ASCONF_ACK:
+		return &addip_chunk_event_table[1][state];
 
-	if (net->sctp.reconf_enable)
-		if (cid = SCTP_CID_RECONF)
-			return &reconf_chunk_event_table[0][state];
+	case SCTP_CID_RECONF:
+		return &reconf_chunk_event_table[0][state];
 
-	if (net->sctp.auth_enable) {
-		if (cid = SCTP_CID_AUTH)
-			return &auth_chunk_event_table[0][state];
+	case SCTP_CID_AUTH:
+		return &auth_chunk_event_table[0][state];
 	}
 
 	return &chunk_event_table_unknown[state];
-- 
2.1.0
