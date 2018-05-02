From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 02 May 2018 16:12:27 +0000
Subject: [PATCHv2 lksctp-tools 3/3] man: add the man docs for sctp_sendv and sctp_recvv
Message-Id: <e39e1ee366913bb06fe9acb556f400c5206dfc70.1525277218.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Based on the description on rfc6458, this patch adds the man docs
for these two functions.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/Makefile.am      |  2 +-
 man/sctp.7           |  2 ++
 man/sctp_bindx.3     |  2 ++
 man/sctp_connectx.3  |  2 ++
 man/sctp_getladdrs.3 |  2 ++
 man/sctp_getpaddrs.3 |  2 ++
 man/sctp_opt_info.3  |  2 ++
 man/sctp_peeloff.3   |  2 ++
 man/sctp_recvmsg.3   |  1 +
 man/sctp_recvv.3     | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/sctp_send.3      |  4 ++-
 man/sctp_sendmsg.3   |  2 ++
 man/sctp_sendv.3     | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 217 insertions(+), 2 deletions(-)
 create mode 100644 man/sctp_recvv.3
 create mode 100644 man/sctp_sendv.3

diff --git a/man/Makefile.am b/man/Makefile.am
index 77dddba..eabfe6f 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -7,6 +7,6 @@ man7_MANS = sctp.7
 
 man3_MANS = sctp_bindx.3 sctp_getladdrs.3 sctp_getpaddrs.3 sctp_opt_info.3 \
 	sctp_peeloff.3 sctp_recvmsg.3 sctp_sendmsg.3 sctp_connectx.3 \
-	sctp_send.3
+	sctp_send.3 sctp_sendv.3 sctp_recvv.3
 
 EXTRA_DIST += $(man3_MANS) $(man7_MANS)
diff --git a/man/sctp.7 b/man/sctp.7
index dea242a..2238a7f 100644
--- a/man/sctp.7
+++ b/man/sctp.7
@@ -340,8 +340,10 @@ Sridhar Samudrala <sri@us.ibm.com>
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getladdrs (3),
 .BR sctp_getpaddrs (3),
diff --git a/man/sctp_bindx.3 b/man/sctp_bindx.3
index 61177d8..e1b151b 100644
--- a/man/sctp_bindx.3
+++ b/man/sctp_bindx.3
@@ -83,8 +83,10 @@ The address is protected, and the user is not the super-user.
 .SH "SEE ALSO"
 .BR sctp (7)
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
diff --git a/man/sctp_connectx.3 b/man/sctp_connectx.3
index 4ee7fc6..c75454c 100644
--- a/man/sctp_connectx.3
+++ b/man/sctp_connectx.3
@@ -134,8 +134,10 @@ firewall rule.
 .BR sctp (7)
 .BR sctp_bindx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
diff --git a/man/sctp_getladdrs.3 b/man/sctp_getladdrs.3
index 89c39ec..c5aad14 100644
--- a/man/sctp_getladdrs.3
+++ b/man/sctp_getladdrs.3
@@ -69,8 +69,10 @@ is undefined.
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_opt_info (3),
diff --git a/man/sctp_getpaddrs.3 b/man/sctp_getpaddrs.3
index 748b600..9167dfc 100644
--- a/man/sctp_getpaddrs.3
+++ b/man/sctp_getpaddrs.3
@@ -63,8 +63,10 @@ is undefined.
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getladdrs (3),
 .BR sctp_opt_info (3),
diff --git a/man/sctp_opt_info.3 b/man/sctp_opt_info.3
index 47a19c3..9d63c9c 100644
--- a/man/sctp_opt_info.3
+++ b/man/sctp_opt_info.3
@@ -47,8 +47,10 @@ error code.
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
diff --git a/man/sctp_peeloff.3 b/man/sctp_peeloff.3
index 6ad2cfd..7e66317 100644
--- a/man/sctp_peeloff.3
+++ b/man/sctp_peeloff.3
@@ -65,8 +65,10 @@ sctp_peeloff_flags is a linux specific variant of sctp_peeloff.  While it will c
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
 .BR sctp_opt_info (3),
diff --git a/man/sctp_recvmsg.3 b/man/sctp_recvmsg.3
index 91f3172..a7dede1 100644
--- a/man/sctp_recvmsg.3
+++ b/man/sctp_recvmsg.3
@@ -54,6 +54,7 @@ returns the number of bytes received or -1 if an error occurred.
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
 .BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
diff --git a/man/sctp_recvv.3 b/man/sctp_recvv.3
new file mode 100644
index 0000000..a41cb33
--- /dev/null
+++ b/man/sctp_recvv.3
@@ -0,0 +1,99 @@
+.\" (C) Copyright Xin Long REDHAT Corp. 2018.
+.\"
+.\" Permission is granted to distribute possibly modified copies
+.\" of this manual provided the header is included verbatim,
+.\" and in case of nontrivial modification author and date
+.\" of the modification is added to the header.
+.\"
+.TH SCTP_RECVV 3 2018-04-29 "Linux 4.16 "Linux Programmer's Manual"
+.SH NAME
+sctp_recvv \- Receive a message from a SCTP socket with an extensible way.
+.SH SYNOPSIS
+.nf
+.B #include <sys/types.h>
+.B #include <sys/socket.h>
+.B #include <netinet/sctp.h>
+.sp
+.BI "int sctp_recvv(int " sd ", const struct iovec * " iov ", int " iovlen ,
+.BI "               struct sockaddr * " from ", socklen_t * " fromlen ", void * " info ,
+.BI "               socklen_t * " infolen ", unsigned int * " infotype ", int * " flags );
+.fi
+.SH DESCRIPTION
+.BR sctp_recvv
+provides an extensible way for the SCTP stack to pass up different SCTP
+attributes associated with a received message to an application.
+There are two types of attributes that can be returned by this call: the
+attribute of the received message and the attribute of the next message
+in the receive buffer.  The caller enables the SCTP_RECVRCVINFO and
+SCTP_RECVNXTINFO socket options, respectively, to receive these attributes.
+Attributes of the received message are returned in struct sctp_rcvinfo,
+and attributes of the next message are returned in struct sctp_nxtinfo.
+If both options are enabled, both attributes are returned using the
+following structure.
+
+   struct sctp_recvv_rn {
+     struct sctp_rcvinfo recvv_rcvinfo;
+     struct sctp_nxtinfo recvv_nxtinfo;
+   };
+
+.I sd
+is the socket descriptor.
+.I iov
+is the scatter buffer, and only one user message is returned in this buffer.
+.I iovlen
+is the number of elements in iov.
+.I from
+is a pointer to a buffer to be filled with the sender of the received message's
+address.
+.I fromlen
+is an in/out parameter describing the from length.
+.I info
+is a pointer to the buffer to hold the attributes of the received message, the
+structure type of info is determined by the info_type parameter.
+.I infolen
+is an in/out parameter describing the size of the info buffer.
+On return,
+.I infotype
+is set to the type of the info buffer, and the current defined
+values are as follows:
+.TP
+.B SCTP_RECVV_NOINFO
+If neither SCTP_RECVRCVINFO nor SCTP_RECVNXTINFO options are enabled, no
+attribute will be returned.  If only the SCTP_RECVNXTINFO option is enabled
+but there is no next message in the buffer, no attribute will be returned.
+In these cases, *info_type will be set to SCTP_RECVV_NOINFO.
+.TP
+.B SCTP_RECVV_RCVINFO
+The type of info is struct sctp_rcvinfo, and the attribute relates to the
+received message.
+.TP
+.B SCTP_RECVV_NXTINFO
+The type of info is struct sctp_nxtinfo, and the attribute relates to the
+next message in the receive buffer.  This is the case when only the
+SCTP_RECVNXTINFO option is enabled and there is a next message in the buffer.
+.TP
+.B SCTP_RECVV_RN
+The type of info is struct sctp_recvv_rn.  The recvv_rcvinfo field is the
+attribute of the received message, and the recvv_nxtinfo field is the attribute
+of the next message in the buffer.  This is the case when both SCTP_RECVRCVINFO
+and SCTP_RECVNXTINFO options are enabled and there is a next message in the
+receive buffer.
+.PP
+.I flags
+is pointer to an integer to be filled with any message flags (e.g.,
+MSG_NOTIFICATION).
+.SH "RETURN VALUE"
+On success,
+.BR sctp_recvv
+returns the number of bytes received or -1 if an error occurred.
+.SH "SEE ALSO"
+.BR sctp (7)
+.BR sctp_bindx (3),
+.BR sctp_connectx (3),
+.BR sctp_sendmsg (3),
+.BR sctp_sendv (3),
+.BR sctp_send (3),
+.BR sctp_peeloff (3),
+.BR sctp_getpaddrs (3),
+.BR sctp_getladdrs (3),
+.BR sctp_opt_info (3)
diff --git a/man/sctp_send.3 b/man/sctp_send.3
index 9b0b3eb..ba66ecd 100644
--- a/man/sctp_send.3
+++ b/man/sctp_send.3
@@ -41,8 +41,10 @@ returns the number of bytes sent or -1 if an error occurred.
 .BR sctp (7)
 .BR sctp_bindx (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
 .BR sctp_opt_info (3),
-.BR sctp_sendmsg (3)
+.BR sctp_sendmsg (3),
+.BR sctp_sendv (3)
diff --git a/man/sctp_sendmsg.3 b/man/sctp_sendmsg.3
index c5fe86d..51828fb 100644
--- a/man/sctp_sendmsg.3
+++ b/man/sctp_sendmsg.3
@@ -76,8 +76,10 @@ returns the number of bytes sent or -1 if an error occurred.
 .BR sctp (7)
 .BR sctp_bindx (3),
 .BR sctp_connectx (3),
+.BR sctp_sendv (3),
 .BR sctp_send (3),
 .BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
 .BR sctp_peeloff (3),
 .BR sctp_getpaddrs (3),
 .BR sctp_getladdrs (3),
diff --git a/man/sctp_sendv.3 b/man/sctp_sendv.3
new file mode 100644
index 0000000..03a2e44
--- /dev/null
+++ b/man/sctp_sendv.3
@@ -0,0 +1,97 @@
+.\" (C) Copyright Xin Long REDHAT Corp. 2018.
+.\"
+.\" Permission is granted to distribute possibly modified copies
+.\" of this manual provided the header is included verbatim,
+.\" and in case of nontrivial modification author and date
+.\" of the modification is added to the header.
+.\"
+.TH SCTP_SENDV 3 2018-04-29 "Linux 4.16 "Linux Programmer's Manual"
+.SH NAME
+sctp_sendv \- Send messages from a SCTP socket with an extensible way.
+.SH SYNOPSIS
+.nf
+.B #include <sys/types.h>
+.B #include <sys/socket.h>
+.B #include <netinet/sctp.h>
+.sp
+.BI "int sctp_sendv(int " sd ", const struct iovec * " iov ", int " iovcnt ,
+.BI "               struct sockaddr *" addrs ", int " addrcnt ", void * " info ,
+.BI "               socklen_t " infolen ", unsigned int " infotype ", int " flags );
+.fi
+.SH DESCRIPTION
+.BR sctp_sendv
+provides an extensible way for an application to communicate different send
+attributes to the SCTP stack when sending a message. There are three types
+of attributes that can be used to describe a message to be sent. They are
+struct sctp_sndinfo, struct sctp_prinfo, and struct sctp_authinfo. The
+following structure, sctp_sendv_spa, is defined to be used when more than
+one of the above attributes are needed to describe a message to be sent.
+
+   struct sctp_sendv_spa {
+     uint32_t sendv_flags;
+     struct sctp_sndinfo sendv_sndinfo;
+     struct sctp_prinfo sendv_prinfo;
+     struct sctp_authinfo sendv_authinfo;
+   };
+
+The sendv_flags field holds a bitwise OR of SCTP_SEND_SNDINFO_VALID,
+SCTP_SEND_PRINFO_VALID, and SCTP_SEND_AUTHINFO_VALID indicating if
+the sendv_sndinfo/sendv_prinfo/sendv_authinfo fields contain valid
+information.
+
+.I sd
+is the socket descriptor.
+.I iov
+is the gather buffer,  the data in the buffer is treated as a single
+user message.
+.I iovcnt
+is the number of elements in iov.
+.I addrs
+is an array of addresses to be used to set up an association or
+a single address to be used to send the message, and  NULL is passed
+in if the caller neither wants to set up an association nor wants
+to send the message to a specific address.
+.I addrcnt
+is the number of addresses in the addrs array.
+.I info
+is a pointer to the buffer containing the attribute associated with the
+message to be sent,  and the type is indicated by the info_type parameter.
+.I infolen
+is the length of info, in bytes.
+.I infotype
+identifies the type of the information provided in info ,and the current
+defined values are as follows:
+.TP
+.B SCTP_SENDV_NOINFO
+No information is provided.  The parameter info is a NULL pointer, and
+infolen is 0.
+.TP
+.B SCTP_SENDV_SNDINFO
+The parameter info is pointing to a struct sctp_sndinfo.
+.TP
+.B SCTP_SENDV_PRINFO
+The parameter info is pointing to a struct sctp_prinfo.
+.TP
+.B SCTP_SENDV_AUTHINFO
+The parameter info is pointing to a struct sctp_authinfo.
+.TP
+.B SCTP_SENDV_SPA
+The parameter info is pointing to a struct sctp_sendv_spa.
+.PP
+.I flags
+The same flags as used by the sendmsg() call flags (e.g., MSG_DONTROUTE).
+.SH "RETURN VALUE"
+On success,
+.BR sctp_sendv
+returns the number of bytes sent or -1 if an error occurred.
+.SH "SEE ALSO"
+.BR sctp (7)
+.BR sctp_bindx (3),
+.BR sctp_connectx (3),
+.BR sctp_send (3),
+.BR sctp_recvmsg (3),
+.BR sctp_recvv (3),
+.BR sctp_peeloff (3),
+.BR sctp_getpaddrs (3),
+.BR sctp_getladdrs (3),
+.BR sctp_opt_info (3),
-- 
2.1.0

