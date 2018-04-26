From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:55 +0000
Subject: [PATCH net-next 06/13] sctp: introduce sctp_assoc_update_frag_point
Message-Id: <cf4652a542b44682ed93e5b61349b6f8b4aa9228.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

and avoid the open-coded versions of it.

Now sctp_datamsg_from_user can just re-use asoc->frag_point as it will
always be updated.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h    | 20 --------------------
 include/net/sctp/structs.h |  1 +
 net/sctp/associola.c       | 24 +++++++++++++++++-------
 net/sctp/chunk.c           | 12 +-----------
 net/sctp/socket.c          |  2 +-
 5 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 0b98e4683f108670c65a0a7aceaf9a736d54bf29..350c65620a4eb35ba2af0d59fef70e2b8b461e44 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -428,26 +428,6 @@ static inline int sctp_list_single_entry(struct list_head *head)
 	return (head->next != head) && (head->next = head->prev);
 }
 
-/* Break down data chunks at this point.  */
-static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
-{
-	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
-	struct sctp_af *af = sp->pf->af;
-	int frag = pmtu;
-
-	frag -= af->ip_options_len(asoc->base.sk);
-	frag -= af->net_header_len;
-	frag -= sizeof(struct sctphdr) + sctp_datachk_len(&asoc->stream);
-
-	if (asoc->user_frag)
-		frag = min_t(int, frag, asoc->user_frag);
-
-	frag = SCTP_TRUNC4(min_t(int, frag, SCTP_MAX_CHUNK_LEN -
-					    sctp_datachk_len(&asoc->stream)));
-
-	return frag;
-}
-
 static inline void sctp_assoc_pending_pmtu(struct sctp_association *asoc)
 {
 	sctp_assoc_sync_pmtu(asoc);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c5e244be8f1ea99118cac9ada0cfce871cb15d3f..ebf809eed33add7905ddd13abf98712a833ae0e0 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2097,6 +2097,7 @@ int sctp_assoc_update(struct sctp_association *old,
 
 __u32 sctp_association_get_next_tsn(struct sctp_association *);
 
+void sctp_assoc_update_frag_point(struct sctp_association *asoc);
 void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu);
 void sctp_assoc_sync_pmtu(struct sctp_association *asoc);
 void sctp_assoc_rwnd_increase(struct sctp_association *, unsigned int);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 85b362324084e9ba139a39293a527ef06824e55b..a29025418b96015dd0240013b0a7c636194da67b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -666,8 +666,6 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 
 	peer->pmtu_pending = 0;
 
-	asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
-
 	/* The asoc->peer.port might not be meaningful yet, but
 	 * initialize the packet structure anyway.
 	 */
@@ -1370,10 +1368,26 @@ sctp_assoc_choose_alter_transport(struct sctp_association *asoc,
 	}
 }
 
+void sctp_assoc_update_frag_point(struct sctp_association *asoc)
+{
+	int frag = sctp_mtu_payload(sctp_sk(asoc->base.sk), asoc->pathmtu,
+				    sctp_datachk_len(&asoc->stream));
+
+	if (asoc->user_frag)
+		frag = min_t(int, frag, asoc->user_frag);
+
+	frag = min_t(int, frag, SCTP_MAX_CHUNK_LEN -
+				sctp_datachk_len(&asoc->stream));
+
+	asoc->frag_point = SCTP_TRUNC4(frag);
+}
+
 void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
 {
-	if (asoc->pathmtu != pmtu)
+	if (asoc->pathmtu != pmtu) {
 		asoc->pathmtu = pmtu;
+		sctp_assoc_update_frag_point(asoc);
+	}
 
 	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
 		 asoc->pathmtu, asoc->frag_point);
@@ -1403,10 +1417,6 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
 	}
 
 	sctp_assoc_set_pmtu(asoc, pmtu);
-	asoc->frag_point = sctp_frag_point(asoc, pmtu);
-
-	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
-		 asoc->pathmtu, asoc->frag_point);
 }
 
 /* Should we send a SACK to update our peer? */
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index be296d633e951c8df322d560150973b5b2bdce5b..79daa98208c391c780440144d69bc7be875c3476 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -172,8 +172,6 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	struct list_head *pos, *temp;
 	struct sctp_chunk *chunk;
 	struct sctp_datamsg *msg;
-	struct sctp_sock *sp;
-	struct sctp_af *af;
 	int err;
 
 	msg = sctp_datamsg_new(GFP_KERNEL);
@@ -192,12 +190,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	/* This is the biggest possible DATA chunk that can fit into
 	 * the packet
 	 */
-	sp = sctp_sk(asoc->base.sk);
-	af = sp->pf->af;
-	max_data = asoc->pathmtu - af->net_header_len -
-		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream) -
-		   af->ip_options_len(asoc->base.sk);
-	max_data = SCTP_TRUNC4(max_data);
+	max_data = asoc->frag_point;
 
 	/* If the the peer requested that we authenticate DATA chunks
 	 * we need to account for bundling of the AUTH chunks along with
@@ -222,9 +215,6 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 		}
 	}
 
-	/* Check what's our max considering the above */
-	max_data = min_t(size_t, max_data, asoc->frag_point);
-
 	/* Set first_len and then account for possible bundles on first frag */
 	first_len = max_data;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b9d14f57146b8e551c28379e379158231fb40ae7..21bf457be3ea321457107256c12ccb93e1fbab06 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3251,7 +3251,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 			       sctp_datachk_len(&asoc->stream);
 		}
 		asoc->user_frag = val;
-		asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
+		sctp_assoc_update_frag_point(asoc);
 	} else {
 		if (params.assoc_id && sctp_style(sk, UDP))
 			return -EINVAL;
-- 
2.14.3

