From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 21 Jun 2008 16:04:44 +0000
Subject: [PATCH net-next] sctp: Mark GET_PEER|LOCAL_ADDR_OLD deprecated.
Message-Id: <12140642842183-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Socket options SCTP_GET_PEER_ADDR_OLD, SCTP_GET_PEER_ADDR_NUM_OLD,
SCTP_GET_LOCAL_ADDR_OLD, and SCTP_GET_PEER_LOCAL_ADDR_NUM_OLD
have been replaced by newer versions a since 2005.  It's time
to officially deprecate them and schedule them for removal.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 net/sctp/socket.c                          |   12 ++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5b3f31f..5378511 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -312,3 +312,15 @@ When:	2.6.26
 Why:	Implementation became generic; users should now include
 	linux/semaphore.h instead.
 Who:	Matthew Wilcox <willy@linux.intel.com>
+
+---------------------------
+
+What:	SCTP_GET_PEER_ADDRS_NUM_OLD, SCTP_GET_PEER_ADDRS_OLD,
+	SCTP_GET_LOCAL_ADDRS_NUM_OLD, SCTP_GET_LOCAL_ADDRS_OLD
+When: 	June 2009
+Why:    A newer version of the options have been introduced in 2005 that
+	removes the limitions of the old API.  The sctp library has been
+        converted to use these new options at the same time.  Any user
+	space app that directly uses the old options should convert to using
+	the new options.
+Who:	Vlad Yasevich <vladislav.yasevich@hp.com>
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f98650c..56df94e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4223,6 +4223,8 @@ static int sctp_getsockopt_peer_addrs_num_old(struct sock *sk, int len,
 	if (copy_from_user(&id, optval, sizeof(sctp_assoc_t)))
 		return -EFAULT;
 
+	printk(KERN_WARNING "SCTP: Use of SCTP_GET_PEER_ADDRS_NUM_OLD "
+			    "socket option deprecated\n");
 	/* For UDP-style sockets, id specifies the association to query.  */
 	asoc = sctp_id2assoc(sk, id);
 	if (!asoc)
@@ -4262,6 +4264,9 @@ static int sctp_getsockopt_peer_addrs_old(struct sock *sk, int len,
 
 	if (getaddrs.addr_num <= 0) return -EINVAL;
 
+	printk(KERN_WARNING "SCTP: Use of SCTP_GET_PEER_ADDRS_OLD "
+			    "socket option deprecated\n");
+
 	/* For UDP-style sockets, id specifies the association to query.  */
 	asoc = sctp_id2assoc(sk, getaddrs.assoc_id);
 	if (!asoc)
@@ -4355,6 +4360,9 @@ static int sctp_getsockopt_local_addrs_num_old(struct sock *sk, int len,
 	if (copy_from_user(&id, optval, sizeof(sctp_assoc_t)))
 		return -EFAULT;
 
+	printk(KERN_WARNING "SCTP: Use of SCTP_GET_LOCAL_ADDRS_NUM_OLD "
+			    "socket option deprecated\n");
+
 	/*
 	 *  For UDP-style sockets, id specifies the association to query.
 	 *  If the id field is set to the value '0' then the locally bound
@@ -4513,6 +4521,10 @@ static int sctp_getsockopt_local_addrs_old(struct sock *sk, int len,
 		return -EFAULT;
 
 	if (getaddrs.addr_num <= 0) return -EINVAL;
+
+	printk(KERN_WARNING "SCTP: Use of SCTP_GET_LOCAL_ADDRS_OLD "
+			    "socket option deprecated\n");
+
 	/*
 	 *  For UDP-style sockets, id specifies the association to query.
 	 *  If the id field is set to the value '0' then the locally bound
-- 
1.5.2.5

