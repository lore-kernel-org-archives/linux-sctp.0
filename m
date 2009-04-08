From: Ivan Skytte =?iso-8859-1?q?J=F8rgensen?= <isj-sctp@i1.dk>
Date: Wed, 08 Apr 2009 16:29:47 +0000
Subject: Re: [Lksctp-developers] [PATCH next-2.6 2/3] [SCTP]: Support the new specification of sctp_connectx(
Message-Id: <200904081829.47896.isj-sctp@i1.dk>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="Boundary-00=_7DN3JFKbTKcM4uu"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

--Boundary-00=_7DN3JFKbTKcM4uu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(Attachment hopefully not stripped now)

On Tuesday 07 April 2009 23:56:18 Ivan Skytte J=F8rgensen wrote:
> On Monday 30 March 2009 19:46:11 Vlad Yasevich wrote:
> > Ivan Skytte J=F8rgensen wrote:
>
> ...
>
> > >>> So there is a need for the system call to return both a value and an
> > >>> error code at the same time.
> > >
> > > Having taken a closer look at the kernel side I think I can whip up a
> > > complete patch for this.
> >
> > OK.  Looks like it will need yet a third socket option that takes the
> > sctp_getaddrs structure.
> >
> > Looking forward to this code.
>
> Attached: patch for lksctp-1.0.10 and kernel 2.6.29.1
>
> Tested on kernel 2.6.27.19 on both 32bit and 64bit.
>
> Signed-off-by: Ivan Skytte J=F8rgensen <isj-sctp@i1.dk>
>
> * Support non-blocking sctp_connectx() calls returning the future
> association-id.
>
>
> Some notes on the user library part:
>
> 1: I decided to keep the previous "new" sctp_connectx() implementation,
> because a: it costs nothing, and b: some very recent programs may rely on
> the broken behaviour.
>
> 2: The new-new sctp_connectx() tries the new method first. If it fails due
> to ENOPROTOOPT (old kernel) then it falls back to the old method first, b=
ut
> only if it is safe to do so (blocking socket, or assoc_id not returned)
>
> 3: (note of users of this feature): If a non-blocking connect fails quick=
ly
> then a new call to sctp_connectx() may return an identical association id
> becaue the ID has been freed up already.
>
> Regards,
>   Ivan

--Boundary-00=_7DN3JFKbTKcM4uu
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="sctp_connectx3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sctp_connectx3.patch"

diff -U3 -p -r lksctp-tools-1.0.10/src/include/netinet/sctp.h lksctp-tools-1.0.11/src/include/netinet/sctp.h
--- lksctp-tools-1.0.10/src/include/netinet/sctp.h	2008-10-09 22:17:26.000000000 +0200
+++ lksctp-tools-1.0.11/src/include/netinet/sctp.h	2009-04-05 17:11:16.000000000 +0200
@@ -146,6 +146,8 @@ enum sctp_optname {
 #define SCTP_GET_LOCAL_ADDRS	SCTP_GET_LOCAL_ADDRS
 	SCTP_SOCKOPT_CONNECTX, /* CONNECTX requests. NEW implementation */
 #define SCTP_SOCKOPT_CONNECTX	SCTP_SOCKOPT_CONNECTX
+	SCTP_SOCKOPT_CONNECTX3, /* CONNECTX requests. NEW, NEW implementation */
+#define SCTP_SOCKOPT_CONNECTX3	SCTP_SOCKOPT_CONNECTX3
 };
 
 /*
diff -U3 -p -r lksctp-tools-1.0.10/src/lib/Versions.map lksctp-tools-1.0.11/src/lib/Versions.map
--- lksctp-tools-1.0.10/src/lib/Versions.map	2008-10-09 22:17:26.000000000 +0200
+++ lksctp-tools-1.0.11/src/lib/Versions.map	2009-04-05 16:57:47.000000000 +0200
@@ -20,3 +20,7 @@ VERS_1 {
 VERS_2 {
 	global:	sctp_connectx;
 } VERS_1;
+
+VERS_3 {
+	global:	sctp_connectx;
+} VERS_2;
diff -U3 -p -r lksctp-tools-1.0.10/src/lib/connectx.c lksctp-tools-1.0.11/src/lib/connectx.c
--- lksctp-tools-1.0.10/src/lib/connectx.c	2008-10-09 22:17:26.000000000 +0200
+++ lksctp-tools-1.0.11/src/lib/connectx.c	2009-04-07 20:31:37.000000000 +0200
@@ -23,7 +23,9 @@
 #include <netinet/in.h>
 #include <netinet/sctp.h> /* SCTP_SOCKOPT_CONNECTX_* */
 #include <errno.h>
-#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
 
 /* Support the sctp_connectx() interface.
  *
@@ -35,14 +37,14 @@
 static int __connectx_addrsize(const struct sockaddr *addrs,
 				     const int addrcnt)
 {
-	void *addrbuf;
-	struct sockaddr *sa_addr;
+	const void *addrbuf;
+	const struct sockaddr *sa_addr;
 	int addrs_size = 0;
 	int i;
 
 	addrbuf = addrs;
 	for (i = 0; i < addrcnt; i++) {
-		sa_addr = (struct sockaddr *)addrbuf;
+		sa_addr = (const struct sockaddr *)addrbuf;
 		switch (sa_addr->sa_family) {
 		case AF_INET:
 			addrs_size += sizeof(struct sockaddr_in);
@@ -106,6 +108,82 @@ int sctp_connectx_new(int fd, struct soc
 	return status;
 }
 
+int sctp_connectx3(int fd, struct sockaddr *addrs, int addrcnt,
+		      sctp_assoc_t *id)
+{
+	socklen_t addrs_size = __connectx_addrsize(addrs, addrcnt);
+	int status;
+	char *new_api_buffer;
+
+	if (addrs_size < 0)
+		return -1;
+
+	/* First try the new socket api */
+	/* Because the id is returned in the option buffer we have prepend
+	 * 32bit to it for the returned association id */
+	new_api_buffer = (char*)malloc(sizeof(uint32_t)+addrs_size);
+	if(new_api_buffer) {
+		socklen_t option_len = addrs_size+sizeof(uint32_t);
+		memset(new_api_buffer,0,sizeof(uint32_t));
+		memcpy(new_api_buffer+sizeof(uint32_t),addrs,addrs_size);
+		status = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX3,
+		                    new_api_buffer, &option_len);
+		if(status==0 ||
+		   errno==EINPROGRESS) {
+			/* Succeeded immediately, or initiated on non-blocking
+			 * socket */
+			if(id)
+				*id = *(uint32_t*)new_api_buffer;
+			free(new_api_buffer);
+			return status;
+		}
+		free(new_api_buffer);
+		if(errno != ENOPROTOOPT) {
+			/* No point in trying the fallbacks*/
+			return status;
+		}
+	}
+
+	/* Second, try the "new" api, which doesn't work for non-blocking sockets */
+	if(id) {
+		/* Program wants the association-id returned. We can only do
+		 * that if the socket is blocking */
+		status = fcntl(fd, F_GETFL);
+		if(status < 0)
+			return status;
+		if(status & O_NONBLOCK) {
+			/* Socket is non-blocking. Fail */
+			errno = ENOPROTOOPT;
+			return -1;
+		}
+	}
+	/* The id is not wanted, or the socket is blocking, so it is ok to
+	 * call use the fallback */
+	status =  setsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX, addrs,
+			     addrs_size);
+	if(status > 0) {
+		if(id)
+			*id = status;
+		return 0;
+	}
+	if(status < 0 && errno!=ENOPROTOOPT) {
+		/* Some other kind of error. No point in continuing */
+		return status;
+	}
+
+	/*Third, try the old, old API */
+	if(id) {
+		/* If the application wants the id then we cannot do it with
+		 * the old API */
+		errno = ENOPROTOOPT;
+		return -1;
+	}
+	
+	return setsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX_OLD,
+			  addrs, addrs_size);
+}
+
 __asm__(".symver __sctp_connectx, sctp_connectx@");
 __asm__(".symver sctp_connectx_orig, sctp_connectx@VERS_1");
-__asm__(".symver sctp_connectx_new, sctp_connectx@@VERS_2");
+__asm__(".symver sctp_connectx_new, sctp_connectx@VERS_2");
+__asm__(".symver sctp_connectx3, sctp_connectx@@VERS_3");

--Boundary-00=_7DN3JFKbTKcM4uu
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="lksctp_connectx3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lksctp_connectx3.patch"

diff -U3 -r -p /usr/src/linux/include/net/sctp/user.h linux-2.6.27.19-3.2/include/net/sctp/user.h
--- /usr/src/linux/include/net/sctp/user.h	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27.19-3.2/include/net/sctp/user.h	2009-04-05 17:41:15.000000000 +0200
@@ -145,6 +145,8 @@ enum sctp_optname {
 #define SCTP_GET_LOCAL_ADDRS	SCTP_GET_LOCAL_ADDRS
 	SCTP_SOCKOPT_CONNECTX, /* CONNECTX requests. */
 #define SCTP_SOCKOPT_CONNECTX	SCTP_SOCKOPT_CONNECTX
+	SCTP_SOCKOPT_CONNECTX3, /* CONNECTX requests. (new implementation) */
+#define SCTP_SOCKOPT_CONNECTX3	SCTP_SOCKOPT_CONNECTX3
 };
 
 /*
diff -U3 -r -p /usr/src/linux/net/sctp/associola.c linux-2.6.27.19-3.2/net/sctp/associola.c
--- /usr/src/linux/net/sctp/associola.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27.19-3.2/net/sctp/associola.c	2009-04-07 20:30:47.000000000 +0200
@@ -1481,6 +1481,10 @@ int sctp_assoc_set_id(struct sctp_associ
 {
 	int assoc_id;
 	int error = 0;
+
+	/* If the id is already assigned, keep it. */
+	if (asoc->assoc_id)
+		return error;
 retry:
 	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
 		return -ENOMEM;
diff -U3 -r -p /usr/src/linux/net/sctp/socket.c linux-2.6.27.19-3.2/net/sctp/socket.c
--- /usr/src/linux/net/sctp/socket.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27.19-3.2/net/sctp/socket.c	2009-04-07 20:30:38.000000000 +0200
@@ -1100,6 +1100,15 @@ static int __sctp_connect(struct sock* s
 		goto out_free;
 	}
 
+	/* In case the user of sctp_connectx() wants an association
+	 * id back, assign one now.
+	 */
+	if (assoc_id) {
+		err = sctp_assoc_set_id(asoc, GFP_KERNEL);
+		if (err < 0)
+			goto out_free;
+	}
+
 	err = sctp_primitive_ASSOCIATE(asoc, NULL);
 	if (err < 0) {
 		goto out_free;
@@ -1120,7 +1129,7 @@ static int __sctp_connect(struct sock* s
 	timeo = sock_sndtimeo(sk, f_flags & O_NONBLOCK);
 
 	err = sctp_wait_for_connect(asoc, &timeo);
-	if (!err && assoc_id)
+	if ((err == 0 || err == -EINPROGRESS) && assoc_id)
 		*assoc_id = asoc->assoc_id;
 
 	/* Don't free association on exit. */
@@ -1264,6 +1273,32 @@ SCTP_STATIC int sctp_setsockopt_connectx
 		return assoc_id;
 }
 
+/*
+ * New (hopefully final) interface for the API.  The option buffer is used
+ * both for the returned association id and the addresses.
+ */
+SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
+					 char __user *optval,
+					 int __user *optlen)
+{
+	sctp_assoc_t assoc_id = 0;
+	int err = 0;
+
+	if(len < 4)
+		return -EINVAL;
+
+	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)(optval+4), len-4, &assoc_id);
+
+	if (err >= 0 || err==-EINPROGRESS) {
+		if (put_user(assoc_id, optval))
+			return -EFAULT;
+		if (put_user(4, optlen))
+			return -EFAULT;
+	}
+
+	return err;
+}
+
 /* API 3.1.4 close() - UDP Style Syntax
  * Applications use close() to perform graceful shutdown (as described in
  * Section 10.1 of [SCTP]) on ALL the associations currently represented
@@ -5447,6 +5482,9 @@ SCTP_STATIC int sctp_getsockopt(struct s
 		retval = sctp_getsockopt_local_addrs(sk, len, optval,
 						     optlen);
 		break;
+	case SCTP_SOCKOPT_CONNECTX3:
+		retval = sctp_getsockopt_connectx3(sk, len, optval, optlen);
+		break;
 	case SCTP_DEFAULT_SEND_PARAM:
 		retval = sctp_getsockopt_default_send_param(sk, len,
 							    optval, optlen);

--Boundary-00=_7DN3JFKbTKcM4uu--
