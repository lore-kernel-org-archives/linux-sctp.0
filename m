From: Robin Holt <holt@sgi.com>
Date: Sat, 02 Oct 2010 11:24:07 +0000
Subject: [Patch] Limit sysctl_sctp_mem initializer to prevent integer overflows.
Message-Id: <20101002112419.376412820@gulag1.americas.sgi.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Subject: [Patch] Limit sysctl_sctp_mem initializer to prevent integer overflows.

On a 16TB x86_64 machine, sysctl_sctp_mem[2] can integer overflow.
Set limit such that they are maximized without overflowing.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Willy Tarreau <w@1wt.eu>
To: linux-sctp@vger.kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>

---

 net/sctp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: pv1010932/net/sctp/protocol.c
=================================--- pv1010932.orig/net/sctp/protocol.c	2010-10-02 06:11:59.000000000 -0500
+++ pv1010932/net/sctp/protocol.c	2010-10-02 06:13:17.727949810 -0500
@@ -1162,7 +1162,8 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
-	 * memory, with a floor of 128 pages.
+	 * memory, with a floor of 128 pages, and a ceiling that prevents an
+	 * integer overflow.
 	 * Note this initializes the data in sctpv6_prot too
 	 * Unabashedly stolen from tcp_init
 	 */
@@ -1170,6 +1171,7 @@ SCTP_STATIC __init int sctp_init(void)
 	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_sctp_mem[0] = limit / 4 * 3;
 	sysctl_sctp_mem[1] = limit;
 	sysctl_sctp_mem[2] = sysctl_sctp_mem[0] * 2;

