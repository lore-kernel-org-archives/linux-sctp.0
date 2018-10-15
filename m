From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Oct 2018 11:58:29 +0000
Subject: [PATCH net] sctp: use the pmtu from the icmp packet to update transport pathmtu
Message-Id: <de1ad572beb97767e535b7cf60da7b1de6cbfd4f.1539604709.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Other than asoc pmtu sync from all transports, sctp_assoc_sync_pmtu
is also processing transport pmtu_pending by icmp packets. But it's
meaningless to use sctp_dst_mtu(t->dst) as new pmtu for a transport.

The right pmtu value should come from the icmp packet, and it would
be saved into transport->mtu_info in this patch and used later when
the pmtu sync happens in sctp_sendmsg_to_asoc or sctp_packet_config.

Besides, without this patch, as pmtu can only be updated correctly
when receiving a icmp packet and no place is holding sock lock, it
will take long time if the sock is busy with sending packets.

Note that it doesn't process transport->mtu_info in .release_cb(),
as there is no enough information for pmtu update, like for which
asoc or transport. It is not worth traversing all asocs to check
pmtu_pending. So unlike tcp, sctp does this in tx path, for which
mtu_info needs to be atomic_t.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 ++
 net/sctp/associola.c       | 3 ++-
 net/sctp/input.c           | 1 +
 net/sctp/output.c          | 6 ++++++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 28a7c8e..a11f937 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -876,6 +876,8 @@ struct sctp_transport {
 	unsigned long sackdelay;
 	__u32 sackfreq;
 
+	atomic_t mtu_info;
+
 	/* When was the last time that we heard from this transport? We use
 	 * this to pick new active and retran paths.
 	 */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 297d9cf..a827a1f 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1450,7 +1450,8 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
 	/* Get the lowest pmtu of all the transports. */
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports) {
 		if (t->pmtu_pending && t->dst) {
-			sctp_transport_update_pmtu(t, sctp_dst_mtu(t->dst));
+			sctp_transport_update_pmtu(t,
+						   atomic_read(&t->mtu_info));
 			t->pmtu_pending = 0;
 		}
 		if (!pmtu || (t->pathmtu < pmtu))
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9bbc5f9..5c36a99 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -395,6 +395,7 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 		return;
 
 	if (sock_owned_by_user(sk)) {
+		atomic_set(&t->mtu_info, pmtu);
 		asoc->pmtu_pending = 1;
 		t->pmtu_pending = 1;
 		return;
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 7f849b0..67939ad 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -120,6 +120,12 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 			sctp_assoc_sync_pmtu(asoc);
 	}
 
+	if (asoc->pmtu_pending) {
+		if (asoc->param_flags & SPP_PMTUD_ENABLE)
+			sctp_assoc_sync_pmtu(asoc);
+		asoc->pmtu_pending = 0;
+	}
+
 	/* If there a is a prepend chunk stick it on the list before
 	 * any other chunks get appended.
 	 */
-- 
2.1.0
