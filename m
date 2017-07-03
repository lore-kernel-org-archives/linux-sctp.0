From: Neil Horman <nhorman@hmswarspite.think-freely.org>
Date: Mon, 03 Jul 2017 20:13:30 +0000
Subject: [PATCH v2] lksctp-tools: Add sctp_peeloff_flags function
Message-Id: <20170703201330.29691-1-nhorman@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

With the addition of the SCTP_SOCKOPT_PEELOFF_FLAGS socket option for
linux, this patch adds a library function to support its use.  For non
linux systems, when the call is used with a 0 flag set, the behavior
will be identical to sctp_peeloff, and with a non-zero flag set for
non-linux operating systems, a runtime error will be returned.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevic@redhat.com>
CC: Daniel Borkmann <dborkman@redhat.com>

---
Change Notes

v2)
	* Cleaned up man page documentation
	* Consolodated if (flags) check
---
 man/sctp_peeloff.3         | 16 ++++++++++++++++
 src/include/netinet/sctp.h |  6 ++++++
 src/lib/peeloff.c          | 45 +++++++++++++++++++++++++++++++--------------
 3 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/man/sctp_peeloff.3 b/man/sctp_peeloff.3
index 7cbde5d..6ad2cfd 100644
--- a/man/sctp_peeloff.3
+++ b/man/sctp_peeloff.3
@@ -15,6 +15,7 @@ sctp_peeloff \- Branch off an association into a separate socket.
 .B #include <netinet/sctp.h>
 .sp
 .BI "int sctp_peeloff(int " sd ", sctp_assoc_t " assoc_id );
+.BI "int sctp_peeloff_flags(int " sd ", sctp_assoc_t " assoc_id ", unsigned " flags );
 .fi
 .SH DESCRIPTION
 .B sctp_peeloff
@@ -28,6 +29,18 @@ This is particularly desirable when, for instance, the application wishes to
 have a number of sporadic message senders/receivers remain under the original
 one-to-many style socket, but branch off those assocations carrying high volume
 data traffic into their own separate socket descriptors.
+
+.B sctp_peeloff_flags
+is a variant of sctp_peeloff, in which flags describing the behavior of
+the newly peeled off socket can be specified.  Currently the supported flags
+are:
+.TP
+.B SOCK_NONBLOCK
+Specifies that the new socket should not block on io operations.
+.TP
+.B SOCK_CLOEXEC
+Specifies that the new socket should be closed when the owning process calls
+exec.
 .SH "RETURN VALUE"
 On success, the new socket descriptor representing the branched-off asociation is returned.
 On error, \-1 is returned, and
@@ -44,6 +57,9 @@ The assoc id passed is invalid or if the socket is a one-to-one style socket.
 .TP
 .B ENOTSOCK
 Argument is a descriptor for a file, not a socket.
+.SH NOTES
+.TP
+sctp_peeloff_flags is a linux specific variant of sctp_peeloff.  While it will compile on other systems, its use will result in an error return.  Portable code should use sctp_peeloff.
 .SH "SEE ALSO"
 .BR sctp (7)
 .BR sctp_bindx (3),
diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h
index 47571cd..560ca33 100644
--- a/src/include/netinet/sctp.h
+++ b/src/include/netinet/sctp.h
@@ -111,6 +111,7 @@ typedef __s32 sctp_assoc_t;
 
 /* SCTP socket option used to read per endpoint association statistics. */
 #define SCTP_GET_ASSOC_STATS    112      /* Read only */
+#define SCTP_SOCKOPT_PEELOFF_FLAGS 122
 
 /*
  * 5.2.1 SCTP Initiation Structure (SCTP_INIT)
@@ -802,6 +803,10 @@ typedef struct {
 	int sd;
 } sctp_peeloff_arg_t;
 
+typedef struct {
+	sctp_peeloff_arg_t p_arg;
+	unsigned flags;
+} sctp_peeloff_flags_arg_t;
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
@@ -809,6 +814,7 @@ int sctp_connectx(int sd, struct sockaddr *addrs, int addrcnt,
 		  sctp_assoc_t *id);
 
 int sctp_peeloff(int sd, sctp_assoc_t assoc_id);
+int sctp_peeloff_flags(int sd, sctp_assoc_t assoc_id, unsigned flags);
 
 /* Prototype for the library function sctp_opt_info defined in
  * API 7. Socket Options.
diff --git a/src/lib/peeloff.c b/src/lib/peeloff.c
index a870050..edd75a0 100644
--- a/src/lib/peeloff.c
+++ b/src/lib/peeloff.c
@@ -23,25 +23,42 @@
 #include <netinet/sctp.h> /* SCTP_SOCKOPT_BINDX_* */
 #include <errno.h>
 
-/* Branch off an association into a seperate socket.  This is a new SCTP API
- * described in the section 8.2 of the Sockets API Extensions for SCTP. 
- * This is implemented using the getsockopt() interface.
- */  
 int
-sctp_peeloff(int fd, sctp_assoc_t associd)
+sctp_peeloff_flags(int fd, sctp_assoc_t associd, unsigned flags)
 {
-	sctp_peeloff_arg_t peeloff;
-	socklen_t peeloff_size = sizeof(peeloff);
+	sctp_peeloff_flags_arg_t peeloff;
+	socklen_t peeloff_size;
 	int err;
 
-	peeloff.associd = associd;
-	peeloff.sd = 0;
-	err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF, &peeloff, 
-			 &peeloff_size); 
-	if (err < 0) {
-		return err;
+	peeloff.p_arg.associd = associd;
+	peeloff.p_arg.sd = 0;
+	peeloff.flags = flags;
+
+
+	if (flags) {
+		peeloff_size = sizeof(sctp_peeloff_flags_arg_t);
+		err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF_FLAGS, &peeloff,
+				 &peeloff_size);
+	} else {
+		peeloff_size = sizeof(sctp_peeloff_arg_t);
+		err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF, &peeloff.p_arg,
+				 &peeloff_size);
 	}
 
-	return peeloff.sd;
+	if (err < 0)
+		return err;
+
+	return peeloff.p_arg.sd;
 
 } /* sctp_peeloff() */
+
+/* Branch off an association into a seperate socket.  This is a new SCTP API
+ * described in the section 8.2 of the Sockets API Extensions for SCTP. 
+ * This is implemented using the getsockopt() interface.
+ */
+int
+sctp_peeloff(int fd, sctp_assoc_t associd)
+{
+	return sctp_peeloff_flags(fd, associd, 0);
+}
+
-- 
2.9.4

