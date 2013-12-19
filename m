From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 19 Dec 2013 06:52:01 +0000
Subject: [PATCH net-next 4/5] sctp: fix checkpatch errors
Message-Id: <1387435922-24152-5-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387435922-24152-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1387435922-24152-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

fix up checkpatch errors:
that open brace { should be on the previous line
open brace '{' following function declarations go on the next line
ERROR: trailing statements should be on next line

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/auth.c     | 3 +--
 net/sctp/input.c    | 6 ++----
 net/sctp/protocol.c | 4 ++--
 net/sctp/socket.c   | 3 ++-
 net/sctp/ulpqueue.c | 3 ++-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index a594b3c..683c7d1 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -499,8 +499,7 @@ void sctp_auth_destroy_hmacs(struct crypto_hash *auth_hmacs[])
 	if (!auth_hmacs)
 		return;
 
-	for (i = 0; i < SCTP_AUTH_NUM_HMACS; i++)
-	{
+	for (i = 0; i < SCTP_AUTH_NUM_HMACS; i++) {
 		if (auth_hmacs[i])
 			crypto_free_hash(auth_hmacs[i]);
 	}
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 49aef00..01ffd6f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -180,8 +180,7 @@ int sctp_rcv(struct sk_buff *skb)
 	 * If a frame arrives on an interface and the receiving socket is
 	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
 	 */
-	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb)))
-	{
+	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb))) {
 		if (asoc) {
 			sctp_association_put(asoc);
 			asoc = NULL;
@@ -613,8 +612,7 @@ void sctp_v4_err(struct sk_buff *skb, __u32 info)
 		if (ICMP_FRAG_NEEDED = code) {
 			sctp_icmp_frag_needed(sk, asoc, transport, info);
 			goto out_unlock;
-		}
-		else {
+		} else {
 			if (ICMP_PROT_UNREACH = code) {
 				sctp_icmp_proto_unreachable(sk, asoc,
 							    transport);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 19bd4c5..34b7726 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1065,8 +1065,8 @@ static struct sctp_af sctp_af_inet = {
 #endif
 };
 
-struct sctp_pf *sctp_get_pf_specific(sa_family_t family) {
-
+struct sctp_pf *sctp_get_pf_specific(sa_family_t family)
+{
 	switch (family) {
 	case PF_INET:
 		return sctp_pf_inet_specific;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9f42c60..2df5564 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5443,7 +5443,8 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 		return -EFAULT;
 num:
 	len = sizeof(struct sctp_authchunks) + num_chunks;
-	if (put_user(len, optlen)) return -EFAULT;
+	if (put_user(len, optlen))
+		return -EFAULT;
 	if (put_user(num_chunks, &p->gauth_number_of_chunks))
 		return -EFAULT;
 	return 0;
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index c700369..5dc9411 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -336,7 +336,8 @@ static struct sctp_ulpevent *sctp_make_reassembled_event(struct net *net,
 		pos = f_frag->next;
 
 	/* Get the last skb in the f_frag's frag_list if present. */
-	for (last = list; list; last = list, list = list->next);
+	for (last = list; list; last = list, list = list->next)
+		;
 
 	/* Add the list of remaining fragments to the first fragments
 	 * frag_list.
-- 
1.7.12


