From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Nov 2015 22:17:37 +0000
Subject: [PATCH] netfilter: nf_ct_sctp: move ip_ct_sctp away from UAPI
Message-Id: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

ip_ct_sctp is an internal structure, embedded by the union
nf_conntrack_proto to store sctp-specific information at conntrack
entries. It has no business with UAPI.

This patch moves it from UAPI to a saner place, together with similar
structs for other protocols.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

No need to update MAINTAINERS.
New header is pulled in automatically due to path preference.

 include/linux/netfilter/nf_conntrack_sctp.h      | 13 +++++++++++++
 include/uapi/linux/netfilter/nf_conntrack_sctp.h | 12 +++---------
 2 files changed, 16 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_sctp.h

diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
new file mode 100644
index 0000000000000000000000000000000000000000..22a16a23cd8a7e3d6d000ee7249477a3fef11604
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -0,0 +1,13 @@
+#ifndef _NF_CONNTRACK_SCTP_H
+#define _NF_CONNTRACK_SCTP_H
+/* SCTP tracking. */
+
+#include <uapi/linux/netfilter/nf_conntrack_sctp.h>
+
+struct ip_ct_sctp {
+	enum sctp_conntrack state;
+
+	__be32 vtag[IP_CT_DIR_MAX];
+};
+
+#endif /* _NF_CONNTRACK_SCTP_H */
diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index ed4e776e1242f586cf1062646903e9afc7bb1af6..2cbc366c3fb4725d06a2def46ac0d54d0dc184f6 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -1,5 +1,5 @@
-#ifndef _NF_CONNTRACK_SCTP_H
-#define _NF_CONNTRACK_SCTP_H
+#ifndef _UAPI_NF_CONNTRACK_SCTP_H
+#define _UAPI_NF_CONNTRACK_SCTP_H
 /* SCTP tracking. */
 
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
@@ -18,10 +18,4 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_MAX
 };
 
-struct ip_ct_sctp {
-	enum sctp_conntrack state;
-
-	__be32 vtag[IP_CT_DIR_MAX];
-};
-
-#endif /* _NF_CONNTRACK_SCTP_H */
+#endif /* _UAPI_NF_CONNTRACK_SCTP_H */
-- 
2.4.3

