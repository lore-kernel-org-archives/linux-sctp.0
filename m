From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 16 May 2017 09:20:45 +0000
Subject: [PATCH net-next 7/7] sk_buff.h: improve description of CHECKSUM_{COMPLETE,UNNECESSARY}
Message-Id: <b44a70a3e512f0121f52dbf9683bf2d25f7e1941.1494883280.git.dcaratti@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Add FCoE to the list of protocols that can set CHECKSUM_UNNECESSARY; add a
note to CHECKSUM_COMPLETE section to specify that it does not apply to SCTP
and FCoE protocols.

Suggested-by: Tom Herbert <tom@herbertland.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Tom Herbert <tom@herbertland.com>
---
 include/linux/skbuff.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fe109fa..5a082db 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -109,6 +109,7 @@
  *       may perform further validation in this case.
  *     GRE: only if the checksum is present in the header.
  *     SCTP: indicates the CRC in SCTP header has been validated.
+ *     FCOE: indicates the CRC in FC frame has been validated.
  *
  *   skb->csum_level indicates the number of consecutive checksums found in
  *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.
@@ -126,8 +127,10 @@
  *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
  *   hardware doesn't need to parse L3/L4 headers to implement this.
  *
- *   Note: Even if device supports only some protocols, but is able to produce
- *   skb->csum, it MUST use CHECKSUM_COMPLETE, not CHECKSUM_UNNECESSARY.
+ *   Notes:
+ *   - Even if device supports only some protocols, but is able to produce
+ *     skb->csum, it MUST use CHECKSUM_COMPLETE, not CHECKSUM_UNNECESSARY.
+ *   - CHECKSUM_COMPLETE is not applicable to SCTP and FCoE protocols.
  *
  * CHECKSUM_PARTIAL:
  *
-- 
2.7.4

