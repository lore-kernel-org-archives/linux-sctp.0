From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 07:07:38 +0000
Subject: [PATCH net] sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit
Message-Id: <b3325c7aa29d1981dabd897b25eae421f7055b0d.1542524858.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now sctp increases sk_wmem_alloc by 1 when doing set_owner_w for the
skb allocked in sctp_packet_transmit and decreases by 1 when freeing
this skb.

But when this skb goes through networking stack, some subcomponents
might change skb->truesize and add the same amount on sk_wmem_alloc.
However sctp doesn't know the amount to decrease by, it would cause
a leak on sk->sk_wmem_alloc and the sock can never be freed.

Xiumei found this issue when it hit esp_output_head() by using sctp
over ipsec, where skb->truesize is added and so is sk->sk_wmem_alloc.

Since sctp has used sk_wmem_queued to count for writable space since
Commit cd305c74b0f8 ("sctp: use sk_wmem_queued to check for writable
space"), it's ok to fix it by counting sk_wmem_alloc by skb truesize
in sctp_packet_transmit.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 67939ad..88dfa6a 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -396,25 +396,6 @@ enum sctp_xmit sctp_packet_append_chunk(struct sctp_packet *packet,
 	return retval;
 }
 
-static void sctp_packet_release_owner(struct sk_buff *skb)
-{
-	sk_free(skb->sk);
-}
-
-static void sctp_packet_set_owner_w(struct sk_buff *skb, struct sock *sk)
-{
-	skb_orphan(skb);
-	skb->sk = sk;
-	skb->destructor = sctp_packet_release_owner;
-
-	/*
-	 * The data chunks have already been accounted for in sctp_sendmsg(),
-	 * therefore only reserve a single byte to keep socket around until
-	 * the packet has been transmitted.
-	 */
-	refcount_inc(&sk->sk_wmem_alloc);
-}
-
 static void sctp_packet_gso_append(struct sk_buff *head, struct sk_buff *skb)
 {
 	if (SCTP_OUTPUT_CB(head)->last = head)
@@ -601,7 +582,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	if (!head)
 		goto out;
 	skb_reserve(head, packet->overhead + MAX_HEADER);
-	sctp_packet_set_owner_w(head, sk);
+	skb_set_owner_w(head, sk);
 
 	/* set sctp header */
 	sh = skb_push(head, sizeof(struct sctphdr));
-- 
2.1.0
