From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 11 Jun 2014 14:34:53 +0000
Subject: [PATCH net-next 1/5] ktime: add ktime_after and ktime_before helper
Message-Id: <1402497297-27100-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1402497297-27100-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1402497297-27100-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Add two minimal helper functions analogous to time_before() and
time_after() that will later on both be needed by SCTP code.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/linux/ktime.h    | 24 ++++++++++++++++++++++++
 net/sctp/sm_make_chunk.c |  2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 31c0cd1..3787f33 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -304,6 +304,30 @@ static inline int ktime_compare(const ktime_t cmp1, const ktime_t cmp2)
 	return 0;
 }
 
+/**
+ * ktime_after - Compare if a ktime_t value is bigger than another one.
+ * @cmp1:	comparable1
+ * @cmp2:	comparable2
+ *
+ * Return: true if cmp1 happened after cmp2.
+ */
+static inline bool ktime_after(const ktime_t cmp1, const ktime_t cmp2)
+{
+	return ktime_compare(cmp1, cmp2) > 0;
+}
+
+/**
+ * ktime_after - Compare if a ktime_t value is smaller than another one.
+ * @cmp1:	comparable1
+ * @cmp2:	comparable2
+ *
+ * Return: true if cmp1 happened before cmp2.
+ */
+static inline bool ktime_before(const ktime_t cmp1, const ktime_t cmp2)
+{
+	return ktime_compare(cmp1, cmp2) < 0;
+}
+
 static inline s64 ktime_to_us(const ktime_t kt)
 {
 	struct timeval tv = ktime_to_timeval(kt);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index fee5552..ae0e616 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1782,7 +1782,7 @@ no_hmac:
 	else
 		kt = ktime_get();
 
-	if (!asoc && ktime_compare(bear_cookie->expiration, kt) < 0) {
+	if (!asoc && ktime_before(bear_cookie->expiration, kt)) {
 		/*
 		 * Section 3.3.10.3 Stale Cookie Error (3)
 		 *
-- 
1.7.11.7

