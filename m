From: Ivan Skytte =?iso-8859-1?q?J=F8rgensen?= <isj-sctp@i1.dk>
Date: Wed, 08 Apr 2009 16:26:53 +0000
Subject: Re: [Lksctp-developers] 64bit compiler warning fixes in test suite
Message-Id: <200904081826.53739.isj-sctp@i1.dk>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="Boundary-00=_NBN3Jf3Ex+yG3ZL"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

--Boundary-00=_NBN3Jf3Ex+yG3ZL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 08 April 2009 16:41:22 Vlad Yasevich wrote:
> Ivan Skytte J=F8rgensen wrote:
> > Many places in the test suites %d is used as format specifier for size_t
> > arguments. This is not correct on 64bit.
> >
> > Attached patch changes the formats to use %zd
>
> The mailing list stripped off you patch. It probably didn't know
> which MIME type it was.
>
> Can you resend to linux-sctp@vger.kernel.org.

Attached.

--Boundary-00=_NBN3Jf3Ex+yG3ZL
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="sctp_64bitwarnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sctp_64bitwarnings.patch"

diff -U3 -p -r lksctp-tools-1.0.10/src/apps/bindx_test.c lksctp-tools-1.0.11/src/apps/bindx_test.c
--- lksctp-tools-1.0.10/src/apps/bindx_test.c	2005-10-21 21:24:20.000000000 +0200
+++ lksctp-tools-1.0.11/src/apps/bindx_test.c	2009-03-29 01:48:55.000000000 +0100
@@ -66,13 +66,13 @@ int main (int argc, char **argv)
 	cnt = 2;    /* argument iterator */
 	buf_ptr = addr_buf;
 	while (cnt < argc) {
-		printf("bindx_test: INFO: Arg %d: %s", cnt, argv[cnt]);
+		printf("bindx_test: INFO: Arg %zd: %s", cnt, argv[cnt]);
 		fflush(stderr);
 		if (strchr(argv[cnt], ':')) {
 			struct sockaddr_in6 *sa6; 
 
 			sa6 = (struct sockaddr_in6 *)buf_ptr;
-			printf(" IPv6 address number %d", addrs);
+			printf(" IPv6 address number %zd", addrs);
 			sa6->sin6_family = AF_INET6;
 			sa6->sin6_port = port;
 			if (inet_pton(AF_INET6, argv[cnt], &sa6->sin6_addr)) {
@@ -85,7 +85,7 @@ int main (int argc, char **argv)
 			struct sockaddr_in *sa; 
 
 			sa = (struct sockaddr_in *)buf_ptr;
-			printf (" IPv4 address number %d", addrs);
+			printf (" IPv4 address number %zd", addrs);
 			sa->sin_family = AF_INET;
 			sa->sin_port = port;
 			if (inet_pton (AF_INET, argv[cnt], &sa->sin_addr)) {
@@ -100,7 +100,7 @@ int main (int argc, char **argv)
 		cnt++;
 	}
 
-	printf ("bindx_test: INFO: Got %d addrs\n", addrs);
+	printf ("bindx_test: INFO: Got %zd addrs\n", addrs);
   
 	/* Create the socket */
 	sd = socket(PF_INET6, SOCK_SEQPACKET, IPPROTO_SCTP);
diff -U3 -p -r lksctp-tools-1.0.10/src/apps/peel_client.c lksctp-tools-1.0.11/src/apps/peel_client.c
--- lksctp-tools-1.0.10/src/apps/peel_client.c	2008-08-05 22:13:06.000000000 +0200
+++ lksctp-tools-1.0.11/src/apps/peel_client.c	2009-03-29 01:49:34.000000000 +0100
@@ -453,7 +453,7 @@ my_sctpReadInput(int fd)
 	errno = 0;
 	sz = recvmsg(fd,&msg,0);
 	if(sz <= 0){
-		printf("Read returns %d errno:%d control len is %d msgflg:%x\n",
+		printf("Read returns %d errno:%d control len is %zd msgflg:%x\n",
 		       sz,errno,
 		       msg.msg_controllen,msg.msg_flags);
 	}
diff -U3 -p -r lksctp-tools-1.0.10/src/apps/peel_server.c lksctp-tools-1.0.11/src/apps/peel_server.c
--- lksctp-tools-1.0.10/src/apps/peel_server.c	2008-08-05 22:13:06.000000000 +0200
+++ lksctp-tools-1.0.11/src/apps/peel_server.c	2009-03-29 01:49:19.000000000 +0100
@@ -436,7 +436,7 @@ my_sctpReadInput(int fd,int maxread)
 	msg.msg_controllen = sizeof(controlVector);
 	errno = 0;
 	sz = recvmsg(fd,&msg,0);
-	printf("Read fd:%d returns %d errno:%d control len is %d msgflg:%x\n",
+	printf("Read fd:%d returns %d errno:%d control len is %zd msgflg:%x\n",
 	       fd,
 	       sz,errno,
 	       msg.msg_controllen,
diff -U3 -p -r lksctp-tools-1.0.10/src/apps/sctp_darn.c lksctp-tools-1.0.11/src/apps/sctp_darn.c
--- lksctp-tools-1.0.10/src/apps/sctp_darn.c	2009-02-25 21:07:18.000000000 +0100
+++ lksctp-tools-1.0.11/src/apps/sctp_darn.c	2009-04-08 16:20:53.000000000 +0200
@@ -1375,7 +1375,7 @@ user_test_check_message(struct msghdr *m
 
 	if (msg->msg_controllen != controllen) {
 		fprintf(stderr,
-			"Got control structure of length %d, not %d\n",
+			"Got control structure of length %zd, not %d\n",
 			msg->msg_controllen, controllen);
 		exit(1);
 	}
diff -U3 -p -r lksctp-tools-1.0.10/src/func_tests/test_1_to_1_threads.c lksctp-tools-1.0.11/src/func_tests/test_1_to_1_threads.c
--- lksctp-tools-1.0.10/src/func_tests/test_1_to_1_threads.c	2008-08-05 22:13:06.000000000 +0200
+++ lksctp-tools-1.0.11/src/func_tests/test_1_to_1_threads.c	2009-03-29 01:52:30.000000000 +0100
@@ -174,7 +174,7 @@ main(void)
 	for ( i = 0; i < THREAD_SND_RCV_LOOPS; i++ ) {
 		for (cnt = 1; cnt < THREADS; cnt++) {
 			status = pthread_create(&thread[cnt], &attr,
-						(void *)relay, (void*)cnt);
+						(void *)relay, (void*)(intptr_t)cnt);
 			if (status)
 				tst_brkm(TBROK, tst_exit, "pthread_create "
                          		 "failed status:%d, errno:%d", status,

--Boundary-00=_NBN3Jf3Ex+yG3ZL--
