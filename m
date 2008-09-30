From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 30 Sep 2008 19:57:39 +0000
Subject: [RFC PATCH] sctp: Rework the tsn map to use generic bitmap.
Message-Id: <1222804659-20503-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Can folks review this patch and see if I missed anything.  Also,
if you think that using bitmaps is not appropriate or more expensive
that arrays, we can change this to use a circular array and still
keep the size down.   In any case, I think we need to do something here
because a 4K+ association structure is terrible.

----

sctp: Rework the tsn map to use generic bitmap.

The tsn map currently use is 4K large and is stuck inside
the sctp_association structure making memory references REALLY
expensive.  What we really need is at most 4K worth of bits
so the biggest map we would have is 512 bytes.   Also, the
map is only really usefull when we have gaps to store and
report.  As such, starting with minimal map of say 32 TSNs (bits)
should be enough for normal low-loss operations.  We can grow
the map by some multiple of 32 along with some extra room any
time we receive the TSN which would put us outside of the map
boundry.  As we close gaps, we can shift the map to rebase
it on the latest TSN we've seen.  This saves 4088 bytes per
association just in the map alone along savings from the now
unnecessary structure members.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 include/net/sctp/constants.h |    4 +-
 include/net/sctp/structs.h   |    1 -
 include/net/sctp/tsnmap.h    |   39 ++-----
 net/sctp/associola.c         |    9 +-
 net/sctp/sm_make_chunk.c     |    5 +-
 net/sctp/sm_sideeffect.c     |    3 +-
 net/sctp/tsnmap.c            |  298 ++++++++++++++++++++----------------------
 net/sctp/ulpevent.c          |   10 +-
 8 files changed, 169 insertions(+), 200 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index c32ddf0..b05b055 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -261,7 +261,9 @@ enum { SCTP_ARBITRARY_COOKIE_ECHO_LEN = 200 };
  * must be less than 65535 (2^16 - 1), or we will have overflow
  * problems creating SACK's.
  */
-#define SCTP_TSN_MAP_SIZE 2048
+#define SCTP_TSN_MAP_INITIAL BITS_PER_LONG
+#define SCTP_TSN_MAP_INCREMENT SCTP_TSN_MAP_INITIAL
+#define SCTP_TSN_MAP_SIZE 4096
 #define SCTP_TSN_MAX_GAP  65535
 
 /* We will not record more than this many duplicate TSNs between two
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 94c62e4..9661d7b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1545,7 +1545,6 @@ struct sctp_association {
 		 * in tsn_map--we get it by calling sctp_tsnmap_get_ctsn().
 		 */
 		struct sctp_tsnmap tsn_map;
-		__u8 _map[sctp_tsnmap_storage_size(SCTP_TSN_MAP_SIZE)];
 
 		/* Ack State   : This flag indicates if the next received
 		 *             : packet is to be responded to with a
diff --git a/include/net/sctp/tsnmap.h b/include/net/sctp/tsnmap.h
index 099211b..6dabbee 100644
--- a/include/net/sctp/tsnmap.h
+++ b/include/net/sctp/tsnmap.h
@@ -60,18 +60,7 @@ struct sctp_tsnmap {
 	 * It points at one of the two buffers with which we will
 	 * ping-pong between.
 	 */
-	__u8 *tsn_map;
-
-	/* This marks the tsn which overflows the tsn_map, when the
-	 * cumulative ack point reaches this point we know we can switch
-	 * maps (tsn_map and overflow_map swap).
-	 */
-	__u32 overflow_tsn;
-
-	/* This is the overflow array for tsn_map.
-	 * It points at one of the other ping-pong buffers.
-	 */
-	__u8 *overflow_map;
+	unsigned long *tsn_map;
 
 	/* This is the TSN at tsn_map[0].  */
 	__u32 base_tsn;
@@ -89,15 +78,15 @@ struct sctp_tsnmap {
 	 */
 	__u32 cumulative_tsn_ack_point;
 
+	/* This is the highest TSN we've marked.  */
+	__u32 max_tsn_seen;
+
 	/* This is the minimum number of TSNs we can track.  This corresponds
 	 * to the size of tsn_map.   Note: the overflow_map allows us to
 	 * potentially track more than this quantity.
 	 */
 	__u16 len;
 
-	/* This is the highest TSN we've marked.  */
-	__u32 max_tsn_seen;
-
 	/* Data chunks pending receipt. used by SCTP_STATUS sockopt */
 	__u16 pending_data;
 
@@ -110,24 +99,17 @@ struct sctp_tsnmap {
 
 	/* Record gap ack block information here.  */
 	struct sctp_gap_ack_block gabs[SCTP_MAX_GABS];
-
-	int malloced;
-
-	__u8 raw_map[0];
 };
 
 struct sctp_tsnmap_iter {
 	__u32 start;
 };
 
-/* This macro assists in creation of external storage for variable length
- * internal buffers.  We double allocate so the overflow map works.
- */
-#define sctp_tsnmap_storage_size(count) (sizeof(__u8) * (count) * 2)
-
 /* Initialize a block of memory as a tsnmap.  */
 struct sctp_tsnmap *sctp_tsnmap_init(struct sctp_tsnmap *, __u16 len,
-				     __u32 initial_tsn);
+				     __u32 initial_tsn, gfp_t gfp);
+
+void sctp_tsnmap_free(struct sctp_tsnmap *map);
 
 /* Test the tracking state of this TSN.
  * Returns:
@@ -138,7 +120,7 @@ struct sctp_tsnmap *sctp_tsnmap_init(struct sctp_tsnmap *, __u16 len,
 int sctp_tsnmap_check(const struct sctp_tsnmap *, __u32 tsn);
 
 /* Mark this TSN as seen.  */
-void sctp_tsnmap_mark(struct sctp_tsnmap *, __u32 tsn);
+int sctp_tsnmap_mark(struct sctp_tsnmap *, __u32 tsn);
 
 /* Mark this TSN and all lower as seen. */
 void sctp_tsnmap_skip(struct sctp_tsnmap *map, __u32 tsn);
@@ -183,10 +165,7 @@ static inline struct sctp_gap_ack_block *sctp_tsnmap_get_gabs(struct sctp_tsnmap
 /* Is there a gap in the TSN map?  */
 static inline int sctp_tsnmap_has_gap(const struct sctp_tsnmap *map)
 {
-	int has_gap;
-
-	has_gap = (map->cumulative_tsn_ack_point != map->max_tsn_seen);
-	return has_gap;
+	return (map->cumulative_tsn_ack_point != map->max_tsn_seen);
 }
 
 /* Mark a duplicate TSN.  Note:  limit the storage of duplicate TSN
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 49880c0..28f4401 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -283,8 +283,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
 
-	/* Set up the tsn tracking. */
-	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_SIZE, 0);
+	memset(&asoc->peer.tsn_map, 0, sizeof(struct sctp_tsnmap));
 
 	asoc->need_ecne = 0;
 
@@ -402,6 +401,8 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Dispose of any pending chunks on the inqueue. */
 	sctp_inq_free(&asoc->base.inqueue);
 
+	sctp_tsnmap_free(&asoc->peer.tsn_map);
+
 	/* Free ssnmap storage. */
 	sctp_ssnmap_free(asoc->ssnmap);
 
@@ -1122,8 +1123,8 @@ void sctp_assoc_update(struct sctp_association *asoc,
 	asoc->peer.rwnd = new->peer.rwnd;
 	asoc->peer.sack_needed = new->peer.sack_needed;
 	asoc->peer.i = new->peer.i;
-	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_SIZE,
-			 asoc->peer.i.initial_tsn);
+	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
+			 asoc->peer.i.initial_tsn, GFP_ATOMIC);
 
 	/* Remove any peer addresses not present in the new association. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 26d047c..a7f85d5 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2288,8 +2288,9 @@ int sctp_process_init(struct sctp_association *asoc, sctp_cid_t cid,
 	}
 
 	/* Set up the TSN tracking pieces.  */
-	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_SIZE,
-			 asoc->peer.i.initial_tsn);
+	if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
+				asoc->peer.i.initial_tsn, gfp))
+		goto clean_up;
 
 	/* RFC 2960 6.5 Stream Identifier and Stream Sequence Number
 	 *
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 56a7ba2..41b8a9b 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1152,7 +1152,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 
 		case SCTP_CMD_REPORT_TSN:
 			/* Record the arrival of a TSN.  */
-			sctp_tsnmap_mark(&asoc->peer.tsn_map, cmd->obj.u32);
+			error = sctp_tsnmap_mark(&asoc->peer.tsn_map,
+						 cmd->obj.u32);
 			break;
 
 		case SCTP_CMD_REPORT_FWDTSN:
diff --git a/net/sctp/tsnmap.c b/net/sctp/tsnmap.c
index f3e58b2..6ccb51c 100644
--- a/net/sctp/tsnmap.c
+++ b/net/sctp/tsnmap.c
@@ -43,37 +43,46 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitmap.h>
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
 
 static void sctp_tsnmap_update(struct sctp_tsnmap *map);
-static void sctp_tsnmap_find_gap_ack(__u8 *map, __u16 off,
+static void sctp_tsnmap_find_gap_ack(unsigned long *map, __u16 off,
 				     __u16 len, __u16 base,
 				     int *started, __u16 *start,
 				     int *ended, __u16 *end);
+static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 gap);
 
 /* Initialize a block of memory as a tsnmap.  */
 struct sctp_tsnmap *sctp_tsnmap_init(struct sctp_tsnmap *map, __u16 len,
-				     __u32 initial_tsn)
+				     __u32 initial_tsn, gfp_t gfp)
 {
-	map->tsn_map = map->raw_map;
-	map->overflow_map = map->tsn_map + len;
-	map->len = len;
-
-	/* Clear out a TSN ack status.  */
-	memset(map->tsn_map, 0x00, map->len + map->len);
+	if (!map->tsn_map) {
+		map->tsn_map = kzalloc(len>>3, gfp);
+		if (map->tsn_map = NULL)
+			return NULL;
+
+		map->len = len;
+	} else {
+		bitmap_zero(map->tsn_map, map->len);
+	}
 
 	/* Keep track of TSNs represented by tsn_map.  */
 	map->base_tsn = initial_tsn;
-	map->overflow_tsn = initial_tsn + map->len;
 	map->cumulative_tsn_ack_point = initial_tsn - 1;
 	map->max_tsn_seen = map->cumulative_tsn_ack_point;
-	map->malloced = 0;
 	map->num_dup_tsns = 0;
 
 	return map;
 }
 
+void sctp_tsnmap_free(struct sctp_tsnmap *map)
+{
+	map->len = 0;
+	kfree(map->tsn_map);
+}
+
 /* Test the tracking state of this TSN.
  * Returns:
  *   0 if the TSN has not yet been seen
@@ -82,66 +91,69 @@ struct sctp_tsnmap *sctp_tsnmap_init(struct sctp_tsnmap *map, __u16 len,
  */
 int sctp_tsnmap_check(const struct sctp_tsnmap *map, __u32 tsn)
 {
-	__s32 gap;
-	int dup;
+	u16 gap;
+
+	/* Check to see if this is an old TSN */
+	if (TSN_lte(tsn, map->cumulative_tsn_ack_point))
+		return 1;
 
+	/* Verify that we can hold this TSN and that it will not
+	 * overlfow our map
+	 */
+	if (!TSN_lt(tsn, map->base_tsn + SCTP_TSN_MAP_SIZE))
+		return -1;
+		
 	/* Calculate the index into the mapping arrays.  */
 	gap = tsn - map->base_tsn;
 
-	/* Verify that we can hold this TSN.  */
-	if (gap >= (/* base */ map->len + /* overflow */ map->len)) {
-		dup = -1;
-		goto out;
-	}
-
-	/* Honk if we've already seen this TSN.
-	 * We have three cases:
-	 *	1. The TSN is ancient or belongs to a previous tsn_map.
-	 *	2. The TSN is already marked in the tsn_map.
-	 *	3. The TSN is already marked in the tsn_map_overflow.
-	 */
-	if (gap < 0 ||
-	    (gap < map->len && map->tsn_map[gap]) ||
-	    (gap >= map->len && map->overflow_map[gap - map->len]))
-		dup = 1;
+	/* Check to see if TSN has already been recorded.  */
+	if (gap < map->len && test_bit(gap, map->tsn_map))
+		return 1;
 	else
-		dup = 0;
-
-out:
-	return dup;
+		return 0;
 }
 
 
 /* Mark this TSN as seen.  */
-void sctp_tsnmap_mark(struct sctp_tsnmap *map, __u32 tsn)
+int sctp_tsnmap_mark(struct sctp_tsnmap *map, __u32 tsn)
 {
-	__s32 gap;
+	u16 gap;
 
-	/* Vacuously mark any TSN which precedes the map base or
-	 * exceeds the end of the map.
-	 */
 	if (TSN_lt(tsn, map->base_tsn))
-		return;
-	if (!TSN_lt(tsn, map->base_tsn + map->len + map->len))
-		return;
-
-	/* Bump the max.  */
-	if (TSN_lt(map->max_tsn_seen, tsn))
-		map->max_tsn_seen = tsn;
+		return 0;
 
-	/* Assert: TSN is in range.  */
 	gap = tsn - map->base_tsn;
 
-	/* Mark the TSN as received.  */
-	if (gap < map->len)
-		map->tsn_map[gap]++;
-	else
-		map->overflow_map[gap - map->len]++;
+	if (gap >= map->len && !sctp_tsnmap_grow(map, gap))
+		return -ENOMEM;
 
-	/* Go fixup any internal TSN mapping variables including
-	 * cumulative_tsn_ack_point.
-	 */
-	sctp_tsnmap_update(map);
+	if (!sctp_tsnmap_has_gap(map) && gap = 0) {
+		/* In this case the map has no gaps and the tsn we are
+		 * recording is the next expected tsn.  We don't touch
+		 * the map but simply bump the values.
+		 */
+		map->max_tsn_seen++;
+		map->cumulative_tsn_ack_point++;
+		map->base_tsn++;
+	} else {
+		/* Either we already have a gap, or about to record a gap, so
+		 * have work to do.
+		 *
+		 * Bump the max.
+		 */
+		if (TSN_lt(map->max_tsn_seen, tsn))
+			map->max_tsn_seen = tsn;
+
+		/* Mark the TSN as received.  */
+		set_bit(gap, map->tsn_map);
+
+		/* Go fixup any internal TSN mapping variables including
+		 * cumulative_tsn_ack_point.
+		 */
+		sctp_tsnmap_update(map);
+	}
+
+	return 0;
 }
 
 
@@ -170,39 +182,14 @@ SCTP_STATIC int sctp_tsnmap_next_gap_ack(const struct sctp_tsnmap *map,
 	if (TSN_lte(map->max_tsn_seen, iter->start))
 		return 0;
 
-	/* Search the first mapping array.  */
-	if (iter->start - map->base_tsn < map->len) {
-
-		offset = iter->start - map->base_tsn;
-		sctp_tsnmap_find_gap_ack(map->tsn_map, offset, map->len, 0,
-					 &started, &start_, &ended, &end_);
-	}
-
-	/* Do we need to check the overflow map? */
-	if (!ended) {
-		/* Fix up where we'd like to start searching in the
-		 * overflow map.
-		 */
-		if (iter->start - map->base_tsn < map->len)
-			offset = 0;
-		else
-			offset = iter->start - map->base_tsn - map->len;
-
-		/* Search the overflow map.  */
-		sctp_tsnmap_find_gap_ack(map->overflow_map,
-					 offset,
-					 map->len,
-					 map->len,
-					 &started, &start_,
-					 &ended, &end_);
-	}
+	offset = iter->start - map->base_tsn;
+	sctp_tsnmap_find_gap_ack(map->tsn_map, offset, map->len, 0,
+				 &started, &start_, &ended, &end_);
 
-	/* The Gap Ack Block happens to end at the end of the
-	 * overflow map.
-	 */
+	/* The Gap Ack Block happens to end at the end of the map. */
 	if (started && !ended) {
 		ended++;
-		end_ = map->len + map->len - 1;
+		end_ = map->len - 1;
 	}
 
 	/* If we found a Gap Ack Block, return the start and end and
@@ -228,35 +215,33 @@ SCTP_STATIC int sctp_tsnmap_next_gap_ack(const struct sctp_tsnmap *map,
 /* Mark this and any lower TSN as seen.  */
 void sctp_tsnmap_skip(struct sctp_tsnmap *map, __u32 tsn)
 {
-	__s32 gap;
+	u32 gap;
 
-	/* Vacuously mark any TSN which precedes the map base or
-	 * exceeds the end of the map.
-	 */
 	if (TSN_lt(tsn, map->base_tsn))
 		return;
-	if (!TSN_lt(tsn, map->base_tsn + map->len + map->len))
+	if (!TSN_lt(tsn, map->base_tsn + SCTP_TSN_MAP_SIZE))
 		return;
 
 	/* Bump the max.  */
 	if (TSN_lt(map->max_tsn_seen, tsn))
 		map->max_tsn_seen = tsn;
 
-	/* Assert: TSN is in range.  */
 	gap = tsn - map->base_tsn + 1;
 
-	/* Mark the TSNs as received.  */
-	if (gap <= map->len)
-		memset(map->tsn_map, 0x01, gap);
-	else {
-		memset(map->tsn_map, 0x01, map->len);
-		memset(map->overflow_map, 0x01, (gap - map->len));
+	map->base_tsn += gap;
+	map->cumulative_tsn_ack_point += gap;
+	if (gap >= map->len) {
+		/* If our gap is larger then the map size, just
+		 * zero out the map.
+		 */
+		bitmap_zero(map->tsn_map, map->len);
+	} else {
+		/* If the gap is smaller then the map size,
+		 * shift the map by 'gap' bits and update further.
+		 */
+		bitmap_shift_right(map->tsn_map, map->tsn_map, gap, map->len);
+		sctp_tsnmap_update(map);
 	}
-
-	/* Go fixup any internal TSN mapping variables including
-	 * cumulative_tsn_ack_point.
-	 */
-	sctp_tsnmap_update(map);
 }
 
 /********************************************************************
@@ -268,27 +253,19 @@ void sctp_tsnmap_skip(struct sctp_tsnmap *map, __u32 tsn)
  */
 static void sctp_tsnmap_update(struct sctp_tsnmap *map)
 {
-	__u32 ctsn;
-
-	ctsn = map->cumulative_tsn_ack_point;
-	do {
-		ctsn++;
-		if (ctsn = map->overflow_tsn) {
-			/* Now tsn_map must have been all '1's,
-			 * so we swap the map and check the overflow table
-			 */
-			__u8 *tmp = map->tsn_map;
-			memset(tmp, 0, map->len);
-			map->tsn_map = map->overflow_map;
-			map->overflow_map = tmp;
-
-			/* Update the tsn_map boundaries.  */
-			map->base_tsn += map->len;
-			map->overflow_tsn += map->len;
-		}
-	} while (map->tsn_map[ctsn - map->base_tsn]);
+	u16 len;
+	unsigned long zero_bit;
+
+
+	len = map->max_tsn_seen - map->cumulative_tsn_ack_point;
+	zero_bit = find_first_zero_bit(map->tsn_map, len);
+	if (!zero_bit)
+		return;		/* The first 0-bit is bit 0.  nothing to do */
+
+	map->base_tsn += zero_bit;
+	map->cumulative_tsn_ack_point += zero_bit; 
 
-	map->cumulative_tsn_ack_point = ctsn - 1; /* Back up one. */
+	bitmap_shift_right(map->tsn_map, map->tsn_map, zero_bit, map->len);
 }
 
 /* How many data chunks  are we missing from our peer?
@@ -299,31 +276,19 @@ __u16 sctp_tsnmap_pending(struct sctp_tsnmap *map)
 	__u32 max_tsn = map->max_tsn_seen;
 	__u32 base_tsn = map->base_tsn;
 	__u16 pending_data;
-	__s32 gap, start, end, i;
+	u32 gap, i;
 
 	pending_data = max_tsn - cum_tsn;
 	gap = max_tsn - base_tsn;
 
-	if (gap <= 0 || gap >= (map->len + map->len))
+	if (gap = 0 || gap >= map->len)
 		goto out;
 
-	start = ((cum_tsn >= base_tsn) ? (cum_tsn - base_tsn + 1) : 0);
-	end = ((gap > map->len ) ? map->len : gap + 1);
-
-	for (i = start; i < end; i++) {
-		if (map->tsn_map[i])
+	for (i = 0; i < gap+1; i++) {
+		if (test_bit(i, map->tsn_map))
 			pending_data--;
 	}
 
-	if (gap >= map->len) {
-		start = 0;
-		end = gap - map->len + 1;
-		for (i = start; i < end; i++) {
-			if (map->overflow_map[i])
-				pending_data--;
-		}
-	}
-
 out:
 	return pending_data;
 }
@@ -334,7 +299,7 @@ out:
  * The flags "started" and "ended" tell is if we found the beginning
  * or (respectively) the end of a Gap Ack Block.
  */
-static void sctp_tsnmap_find_gap_ack(__u8 *map, __u16 off,
+static void sctp_tsnmap_find_gap_ack(unsigned long *map, __u16 off,
 				     __u16 len, __u16 base,
 				     int *started, __u16 *start,
 				     int *ended, __u16 *end)
@@ -348,14 +313,10 @@ static void sctp_tsnmap_find_gap_ack(__u8 *map, __u16 off,
 	/* Also, stop looking past the maximum TSN seen. */
 
 	/* Look for the start. */
-	if (!(*started)) {
-		for (; i < len; i++) {
-			if (map[i]) {
-				(*started)++;
-				*start = base + i;
-				break;
-			}
-		}
+	i = find_next_bit(map, len, off);
+	if (i < len) {
+		(*started)++;
+		*start = base + i;
 	}
 
 	/* Look for the end.  */
@@ -363,12 +324,10 @@ static void sctp_tsnmap_find_gap_ack(__u8 *map, __u16 off,
 		/* We have found the start, let's find the
 		 * end.  If we find the end, break out.
 		 */
-		for (; i < len; i++) {
-			if (!map[i]) {
-				(*ended)++;
-				*end = base + i - 1;
-				break;
-			}
+		i = find_next_zero_bit(map, len, i);
+		if (i < len) {
+			(*ended)++;
+			*end = base + i - 1;
 		}
 	}
 }
@@ -376,21 +335,18 @@ static void sctp_tsnmap_find_gap_ack(__u8 *map, __u16 off,
 /* Renege that we have seen a TSN.  */
 void sctp_tsnmap_renege(struct sctp_tsnmap *map, __u32 tsn)
 {
-	__s32 gap;
+	u32 gap;
 
 	if (TSN_lt(tsn, map->base_tsn))
 		return;
-	if (!TSN_lt(tsn, map->base_tsn + map->len + map->len))
+	/* Assert: TSN is in range.  */
+	if (!TSN_lt(tsn, map->base_tsn + map->len))
 		return;
 
-	/* Assert: TSN is in range.  */
 	gap = tsn - map->base_tsn;
 
 	/* Pretend we never saw the TSN.  */
-	if (gap < map->len)
-		map->tsn_map[gap] = 0;
-	else
-		map->overflow_map[gap - map->len] = 0;
+	clear_bit(gap, map->tsn_map);
 }
 
 /* How many gap ack blocks do we have recorded? */
@@ -416,3 +372,27 @@ __u16 sctp_tsnmap_num_gabs(struct sctp_tsnmap *map)
 	}
 	return gabs;
 }
+
+static int sctp_tsnmap_grow(struct sctp_tsnmap *map, u16 gap)
+{
+	unsigned long *new;
+	unsigned long inc;
+	u16  len;
+
+	if (gap >= SCTP_TSN_MAP_SIZE)
+		return 0;
+
+	inc = ALIGN((gap - map->len),BITS_PER_LONG) + SCTP_TSN_MAP_INCREMENT;
+	len = min_t(u16, map->len + inc, SCTP_TSN_MAP_SIZE);
+
+	new = kzalloc(len>>3, GFP_ATOMIC);
+	if (!new)
+		return 0;
+
+	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn);
+	kfree(map->tsn_map);
+	map->tsn_map = new;
+	map->len = len;
+
+	return 1;
+}
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index a1f654a..5f186ca 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -713,7 +713,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	/* Now that all memory allocations for this chunk succeeded, we
 	 * can mark it as received so the tsn_map is updated correctly.
 	 */
-	sctp_tsnmap_mark(&asoc->peer.tsn_map, ntohl(chunk->subh.data_hdr->tsn));
+	if (sctp_tsnmap_mark(&asoc->peer.tsn_map,
+			     ntohl(chunk->subh.data_hdr->tsn)))
+		goto fail_mark;
 
 	/* First calculate the padding, so we don't inadvertently
 	 * pass up the wrong length to the user.
@@ -755,8 +757,12 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	event->msg_flags |= chunk->chunk_hdr->flags;
 	event->iif = sctp_chunk_iif(chunk);
 
-fail:
 	return event;
+
+fail_mark:
+	kfree_skb(skb);
+fail:
+	return NULL;
 }
 
 /* Create a partial delivery related event.
-- 
1.5.3.5

