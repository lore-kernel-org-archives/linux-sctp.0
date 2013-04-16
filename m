From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 16 Apr 2013 21:07:10 +0000
Subject: [PATCH net-next 1/9] net: sctp: sctp_ssnmap: remove 'malloced' element from struct
Message-Id: <1366146438-8815-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

sctp_ssnmap_init() can only be called from sctp_ssnmap_new()
where malloced is always set to 1. Thus, when we call
sctp_ssnmap_free() the test for map->malloced evaluates always
to true.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/structs.h |  1 -
 net/sctp/ssnmap.c          | 23 ++++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index e12aa77..3c1bb8d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -399,7 +399,6 @@ struct sctp_stream {
 struct sctp_ssnmap {
 	struct sctp_stream in;
 	struct sctp_stream out;
-	int malloced;
 };
 
 struct sctp_ssnmap *sctp_ssnmap_new(__u16 in, __u16 out,
diff --git a/net/sctp/ssnmap.c b/net/sctp/ssnmap.c
index 825ea94..da86035 100644
--- a/net/sctp/ssnmap.c
+++ b/net/sctp/ssnmap.c
@@ -74,7 +74,6 @@ struct sctp_ssnmap *sctp_ssnmap_new(__u16 in, __u16 out,
 	if (!sctp_ssnmap_init(retval, in, out))
 		goto fail_map;
 
-	retval->malloced = 1;
 	SCTP_DBG_OBJCNT_INC(ssnmap);
 
 	return retval;
@@ -118,14 +117,16 @@ void sctp_ssnmap_clear(struct sctp_ssnmap *map)
 /* Dispose of a ssnmap.  */
 void sctp_ssnmap_free(struct sctp_ssnmap *map)
 {
-	if (map && map->malloced) {
-		int size;
-
-		size = sctp_ssnmap_size(map->in.len, map->out.len);
-		if (size <= KMALLOC_MAX_SIZE)
-			kfree(map);
-		else
-			free_pages((unsigned long)map, get_order(size));
-		SCTP_DBG_OBJCNT_DEC(ssnmap);
-	}
+	int size;
+
+	if (unlikely(!map))
+		return;
+
+	size = sctp_ssnmap_size(map->in.len, map->out.len);
+	if (size <= KMALLOC_MAX_SIZE)
+		kfree(map);
+	else
+		free_pages((unsigned long)map, get_order(size));
+
+	SCTP_DBG_OBJCNT_DEC(ssnmap);
 }
-- 
1.7.11.7

