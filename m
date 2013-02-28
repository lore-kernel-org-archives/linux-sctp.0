From: "Lee A. Roberts" <lee.roberts@hp.com>
Date: Thu, 28 Feb 2013 14:37:27 +0000
Subject: [PATCH v3 1/4] sctp: fix association hangs due to off-by-one errors in sctp_tsnmap_grow()
Message-Id: <1362062250-26749-2-git-send-email-lee.roberts@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
In-Reply-To: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, lee.roberts@hp.com

From: "Lee A. Roberts" <lee.roberts@hp.com>

In sctp_tsnmap_mark(), correct off-by-one error when calculating
size value for sctp_tsnmap_grow().

In sctp_tsnmap_grow(), correct off-by-one error when copying
and resizing the tsnmap.  If max_tsn_seen is in the LSB of the
word, this bit can be lost, causing the corresponding packet
to be transmitted again and to be entered as a duplicate into
the SCTP reassembly/ordering queues.  Change parameter name
from "gap" (zero-based index) to "size" (one-based) to enhance
code readability.

Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
---
 net/sctp/tsnmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/tsnmap.c b/net/sctp/tsnmap.c
index 5f25e0c..396c451 100644
--- a/net/sctp/tsnmap.c
+++ b/net/sctp/tsnmap.c
@@ -51,7 +51,7 @@
 static void sctp_tsnmap_update(struct sctp_tsnmap *map);
 static void sctp_tsnmap_find_gap_ack(unsigned long *map, __u16 off,
 				     __u16 len, __u16 *start, __u16 *end);
-static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 gap);
+static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 size);
 
 /* Initialize a block of memory as a tsnmap.  */
 struct sctp_tsnmap *sctp_tsnmap_init(struct sctp_tsnmap *map, __u16 len,
@@ -124,7 +124,7 @@ int sctp_tsnmap_mark(struct sctp_tsnmap *map, __u32 tsn,
 
 	gap = tsn - map->base_tsn;
 
-	if (gap >= map->len && !sctp_tsnmap_grow(map, gap))
+	if (gap >= map->len && !sctp_tsnmap_grow(map, gap + 1))
 		return -ENOMEM;
 
 	if (!sctp_tsnmap_has_gap(map) && gap = 0) {
@@ -360,23 +360,24 @@ __u16 sctp_tsnmap_num_gabs(struct sctp_tsnmap *map,
 	return ngaps;
 }
 
-static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 gap)
+static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 size)
 {
 	unsigned long *new;
 	unsigned long inc;
 	u16  len;
 
-	if (gap >= SCTP_TSN_MAP_SIZE)
+	if (size > SCTP_TSN_MAP_SIZE)
 		return 0;
 
-	inc = ALIGN((gap - map->len),BITS_PER_LONG) + SCTP_TSN_MAP_INCREMENT;
+	inc = ALIGN((size - map->len), BITS_PER_LONG) + SCTP_TSN_MAP_INCREMENT;
 	len = min_t(u16, map->len + inc, SCTP_TSN_MAP_SIZE);
 
 	new = kzalloc(len>>3, GFP_ATOMIC);
 	if (!new)
 		return 0;
 
-	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn);
+	bitmap_copy(new, map->tsn_map,
+		map->max_tsn_seen - map->cumulative_tsn_ack_point);
 	kfree(map->tsn_map);
 	map->tsn_map = new;
 	map->len = len;
-- 
1.7.9.5

