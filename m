From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Oct 2018 19:07:50 +0000
Subject: [PATCH net-next 1/2] sctp: count both sk and asoc sndbuf with skb truesize and sctp_chunk size
Message-Id: <69e02c98600ba4e4142056bd25fbe3a006f94e52.1539716812.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1539716812.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1539716812.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Now it's confusing that asoc sndbuf_used is doing memory accounting with
SCTP_DATA_SNDSIZE(chunk) + sizeof(sk_buff) + sizeof(sctp_chunk) while sk
sk_wmem_alloc is doing that with skb->truesize + sizeof(sctp_chunk).

It also causes sctp_prsctp_prune to count with a wrong freed memory when
sndbuf_policy is not set.

To make this right and also keep consistent between asoc sndbuf_used, sk
sk_wmem_alloc and sk_wmem_queued, use skb->truesize + sizeof(sctp_chunk)
for them.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h |  5 -----
 net/sctp/outqueue.c          |  8 ++------
 net/sctp/socket.c            | 21 ++++++---------------
 3 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 86f034b..8dadc74 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -148,11 +148,6 @@ SCTP_SUBTYPE_CONSTRUCTOR(PRIMITIVE,	enum sctp_event_primitive, primitive)
 #define sctp_chunk_is_data(a) (a->chunk_hdr->type = SCTP_CID_DATA || \
 			       a->chunk_hdr->type = SCTP_CID_I_DATA)
 
-/* Calculate the actual data size in a data chunk */
-#define SCTP_DATA_SNDSIZE(c) ((int)((unsigned long)(c->chunk_end) - \
-				    (unsigned long)(c->chunk_hdr) - \
-				    sctp_datachk_len(&c->asoc->stream)))
-
 /* Internal error codes */
 enum sctp_ierror {
 	SCTP_IERROR_NO_ERROR	        = 0,
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 42191ed..9cb854b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -385,9 +385,7 @@ static int sctp_prsctp_prune_sent(struct sctp_association *asoc,
 			asoc->outqueue.outstanding_bytes -= sctp_data_size(chk);
 		}
 
-		msg_len -= SCTP_DATA_SNDSIZE(chk) +
-			   sizeof(struct sk_buff) +
-			   sizeof(struct sctp_chunk);
+		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		if (msg_len <= 0)
 			break;
 	}
@@ -421,9 +419,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 		}
 
-		msg_len -= SCTP_DATA_SNDSIZE(chk) +
-			   sizeof(struct sk_buff) +
-			   sizeof(struct sctp_chunk);
+		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
 		if (msg_len <= 0)
 			break;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f73e9d3..c6f2950 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -166,12 +166,9 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 	/* Save the chunk pointer in skb for sctp_wfree to use later.  */
 	skb_shinfo(chunk->skb)->destructor_arg = chunk;
 
-	asoc->sndbuf_used += SCTP_DATA_SNDSIZE(chunk) +
-				sizeof(struct sk_buff) +
-				sizeof(struct sctp_chunk);
-
 	refcount_add(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc);
-	sk->sk_wmem_queued += chunk->skb->truesize;
+	asoc->sndbuf_used += chunk->skb->truesize + sizeof(struct sctp_chunk);
+	sk->sk_wmem_queued += chunk->skb->truesize + sizeof(struct sctp_chunk);
 	sk_mem_charge(sk, chunk->skb->truesize);
 }
 
@@ -8460,17 +8457,11 @@ static void sctp_wfree(struct sk_buff *skb)
 	struct sctp_association *asoc = chunk->asoc;
 	struct sock *sk = asoc->base.sk;
 
-	asoc->sndbuf_used -= SCTP_DATA_SNDSIZE(chunk) +
-				sizeof(struct sk_buff) +
-				sizeof(struct sctp_chunk);
-
-	WARN_ON(refcount_sub_and_test(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc));
-
-	/*
-	 * This undoes what is done via sctp_set_owner_w and sk_mem_charge
-	 */
-	sk->sk_wmem_queued   -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
+	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
+	asoc->sndbuf_used -= skb->truesize + sizeof(struct sctp_chunk);
+	WARN_ON(refcount_sub_and_test(sizeof(struct sctp_chunk),
+				      &sk->sk_wmem_alloc));
 
 	if (chunk->shkey) {
 		struct sctp_shared_key *shkey = chunk->shkey;
-- 
2.1.0
