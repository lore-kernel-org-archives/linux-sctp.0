From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 13:48:53 +0000
Subject: [PATCH net-next 01/15] udp: check udp sock encap_type in __udp_lib_err
Message-Id: <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

There is a chance that __udp4/6_lib_lookup() returns a udp encap
sock in __udp_lib_err(), like the udp encap listening sock may
use the same port as remote encap port, in which case it should
go to __udp4/6_lib_err_encap() for more validation before
processing the icmp packet.

This patch is to check encap_type in __udp_lib_err() for the
further validation for a encap sock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..ca04a8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -702,7 +702,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..cde9b88 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -560,7 +560,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-- 
2.1.0
