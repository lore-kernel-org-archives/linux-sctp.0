From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 26 Feb 2010 03:18:28 +0000
Subject: [PATCH 2/3] sctp_test: add -B option and -C option for specifying
Message-Id: <4B873D84.3070109@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch add -B option and -C option for specifying addresses.
Copy from sctp_dran.

-B option add the specified address(es) as additional bind
addresses of the local socket. Multiple addresses can be
specified by using this argument multiple times. For
example, '-B 10.0.0.1 -B 20.0.0.2'.

-C option use the specified address(es) for connection to the
peer socket. Multiple addresses can be specified by using this
argument multiple times. For example, '-C 10.0.0.1 -C 20.0.0.2'.
This option is incompatible with the -h option.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 src/apps/sctp_test.c |  264 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 260 insertions(+), 4 deletions(-)

diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index d7c8e5f..127f50e 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -166,6 +166,11 @@ int repeat = REPEAT;
 int msg_cnt = MSG_CNT;
 int drain = 0;
 int role = NOT_DEFINED;
+struct sockaddr *bindx_add_addrs = NULL;
+int bindx_add_count = 0;
+struct sockaddr *connectx_addrs = NULL;
+int connectx_count = 0;
+int if_index = 0;
 
 unsigned char msg[] = "012345678901234567890123456789012345678901234567890";
 
@@ -246,6 +251,15 @@ void usage(char *argv0)
 	fprintf(stderr, "\t-S num-ports (default value 0). Run the mixed mode\n");
 	fprintf(stderr, "\t-D drain. If in client mode do a read following send.\n");
 	fprintf(stderr, "\t-T use SOCK_STREAM tcp-style sockets.\n");
+	fprintf(stderr, "\t-B add the specified address(es) as additional bind\n");
+	fprintf(stderr, "\t   addresses of the local socket. Multiple addresses can\n");
+	fprintf(stderr, "\t   be specified by using this argument multiple times.\n");
+	fprintf(stderr, "\t   For example, '-B 10.0.0.1 -B 20.0.0.2'.\n");
+	fprintf(stderr, "\t-C use the specified address(es) for connection to the\n");
+	fprintf(stderr, "\t   peer socket. Multiple addresses can be specified by\n");
+	fprintf(stderr, "\t   using this argument multiple times.\n");
+	fprintf(stderr, "\t   For example, '-C 10.0.0.1 -C 20.0.0.2'.\n");
+	fprintf(stderr, "\t   This option is incompatible with the -h option.\n");
 	fprintf(stderr, "\n");
 	fflush(stderr);
 
@@ -467,6 +481,108 @@ print_message(const int sk, struct msghdr *msg, size_t msg_len) {
 
 } /* print_message() */
 
+struct sockaddr *
+append_addr(const char *parm, struct sockaddr *addrs, int *ret_count)
+{
+	struct sockaddr *new_addrs = NULL;
+	void *aptr;
+	struct sockaddr *sa_addr;
+	struct sockaddr_in *b4ap;
+	struct sockaddr_in6 *b6ap;
+	struct hostent *hst4 = NULL;
+	struct hostent *hst6 = NULL;
+	int i4 = 0;
+	int i6 = 0;
+	int j;
+	int orig_count = *ret_count;
+	int count = orig_count;
+
+	/* Get the entries for this host.  */
+	hst4 = gethostbyname(parm);
+	hst6 = gethostbyname2(parm, AF_INET6);
+
+	if ((NULL = hst4 || hst4->h_length < 1)
+	    && (NULL = hst6 || hst6->h_length < 1)) {
+		fprintf(stderr, "bad hostname: %s\n", parm);
+		goto finally;
+	}
+
+	/* Figure out the number of addresses.  */
+	if (NULL != hst4) {
+		for (i4 = 0; NULL != hst4->h_addr_list[i4]; ++i4) {
+			count++;
+		}
+	}
+	if (NULL != hst6) {
+		for (i6 = 0; NULL != hst6->h_addr_list[i6]; ++i6) {
+			count++;
+		}
+	}
+
+	/* Expand memory for the new addresses.  Assume all the addresses
+	 * are v6 addresses.
+	 */
+	new_addrs = (struct sockaddr *)
+		realloc(addrs, sizeof(struct sockaddr_in6) * count);
+
+	if (NULL = new_addrs) {
+		count = *ret_count;
+		goto finally;
+	}
+
+	/* Skip the existing addresses. */
+	aptr = new_addrs;
+	for (j = 0; j < orig_count; j++) {
+		sa_addr = (struct sockaddr *)aptr;
+		switch(sa_addr->sa_family) {
+		case AF_INET:
+			aptr += sizeof(struct sockaddr_in);
+			break;
+		case AF_INET6:
+			aptr += sizeof(struct sockaddr_in6);
+			break;
+		default:
+			count = orig_count;
+			goto finally;
+		}
+	}
+
+	/* Put the new addresses away.  */
+	if (NULL != hst4) {
+		for (j = 0; j < i4; ++j) {
+			b4ap = (struct sockaddr_in *)aptr;
+			bzero(b4ap, sizeof(*b4ap));
+			b4ap->sin_family = AF_INET;
+			b4ap->sin_port = htons(local_port);
+			bcopy(hst4->h_addr_list[j], &b4ap->sin_addr,
+			      hst4->h_length);
+
+			aptr += sizeof(struct sockaddr_in);
+		} /* for (loop through the new v4 addresses) */
+	}
+
+	if (NULL != hst6) {
+		for (j = 0; j < i6; ++j) {
+			b6ap = (struct sockaddr_in6 *)aptr;
+			bzero(b6ap, sizeof(*b6ap));
+			b6ap->sin6_family = AF_INET6;
+			b6ap->sin6_port =  htons(local_port);
+			b6ap->sin6_scope_id = if_index;
+			bcopy(hst6->h_addr_list[j], &b6ap->sin6_addr,
+			      hst6->h_length);
+
+			aptr += sizeof(struct sockaddr_in6);
+		} /* for (loop through the new v6 addresses) */
+	}
+
+ finally:
+
+	*ret_count = count;
+
+	return new_addrs;
+
+} /* append_addr() */
+
 int socket_r(void)
 {
 	struct sctp_event_subscribe subscribe;
@@ -556,6 +672,47 @@ int bind_r(int sk, struct sockaddr_storage *saddr)
 
 } /* bind_r() */
 
+int
+bindx_r(int sk, struct sockaddr *addrs, int count, int flag)
+{
+	int error;
+	int i;
+	struct sockaddr *sa_addr;
+	void *aptr;
+
+	/* Set the port in every address.  */
+	aptr = addrs;
+	for (i = 0; i < count; i++) {
+		sa_addr = (struct sockaddr *)aptr;
+
+		switch(sa_addr->sa_family) {
+		case AF_INET:
+			((struct sockaddr_in *)sa_addr)->sin_port +				htons(local_port);
+			aptr += sizeof(struct sockaddr_in);
+			break;
+		case AF_INET6:
+			((struct sockaddr_in6 *)sa_addr)->sin6_port +				htons(local_port);
+			aptr += sizeof(struct sockaddr_in6);
+			break;
+		default:
+			fprintf(stderr, "Invalid address family\n");
+			exit(1);
+		}
+	}
+
+	error = sctp_bindx(sk, addrs, count, flag);
+	if (error != 0) {
+		fprintf(stderr, "\n\n\t\t***bindx_r: error adding addrs:"
+			" %s. ***\n", strerror(errno));
+		exit(1);
+	}
+
+	return 0;
+
+} /* bindx_r() */
+
 int listen_r(int sk, int listen_count)
 {
 	int error = 0;
@@ -612,6 +769,46 @@ int connect_r(int sk, const struct sockaddr *serv_addr, socklen_t addrlen)
 
 } /* connect_r() */
 
+int connectx_r(int sk, struct sockaddr *addrs, int count)
+{
+	int error;
+	int i;
+	struct sockaddr *sa_addr;
+	void *aptr;
+
+	/* Set the port in every address.  */
+	aptr = addrs;
+	for (i = 0; i < count; i++) {
+		sa_addr = (struct sockaddr *)aptr;
+
+		switch(sa_addr->sa_family) {
+		case AF_INET:
+			((struct sockaddr_in *)sa_addr)->sin_port +				htons(remote_port);
+			aptr += sizeof(struct sockaddr_in);
+			break;
+		case AF_INET6:
+			((struct sockaddr_in6 *)sa_addr)->sin6_port +				htons(remote_port);
+			aptr += sizeof(struct sockaddr_in6);
+			break;
+		default:
+			fprintf(stderr, "Invalid address family\n");
+			exit(1);
+		}
+	}
+
+	error = sctp_connectx(sk, addrs, count, NULL);
+	if (error != 0) {
+		fprintf(stderr, "\n\n\t\t*** connectx_r: error connecting"
+			" to addrs: %s ***\n", strerror(errno));
+		exit(1);
+	}
+
+	return 0;
+
+} /* connectx_r() */
+
 int receive_r(int sk, int once)
 {
 	int recvsk = sk, i = 0, error = 0;
@@ -1172,10 +1369,19 @@ void start_test(int role)
 	sk = socket_r();
 	bind_r(sk, &s_loc);
 
+	/* Do we need to do bindx() to add any additional addresses? */
+	if (bindx_add_addrs)
+		bindx_r(sk, bindx_add_addrs, bindx_add_count,
+			   SCTP_BINDX_ADD_ADDR);
+
 	if (role = SERVER) {
 		listen_r(sk, 100);
-	} else if (socket_type = SOCK_STREAM) {
-		connect_r(sk, (struct sockaddr *)&s_rem, r_len);
+	} else {
+		if (socket_type = SOCK_STREAM && connectx_count = 0)
+			connect_r(sk, (struct sockaddr *)&s_rem, r_len);
+
+		if (connectx_count != 0)
+			connectx_r(sk, connectx_addrs, connectx_count);
 	}
 
 	if (!debug_level) {
@@ -1209,9 +1415,10 @@ main(int argc, char *argv[])
 	char *interface = NULL;
 	struct sockaddr_in *t_addr;
 	struct sockaddr_in6 *t_addr6;
+	struct sockaddr *tmp_addrs = NULL;
 	
         /* Parse the arguments.  */
-        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:T")) >= 0 ) {
+        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:TB:C:")) >= 0 ) {
 
                 switch (c) {
 		case 'H':
@@ -1342,10 +1549,35 @@ main(int argc, char *argv[])
 			break;
 		case 'i':
 			interface = optarg;
+			if_index = if_nametoindex(interface);
+			if (!if_index) {
+				printf("Interface %s unknown\n", interface);
+				exit(1);
+			}
 			break;
 		case 'T':
 			socket_type = SOCK_STREAM;
 			break;
+		case 'B':
+			tmp_addrs = append_addr(optarg, bindx_add_addrs,
+						&bindx_add_count);
+			if (NULL = tmp_addrs) {
+				fprintf(stderr, "No memory to add ");
+				fprintf(stderr, "%s\n", optarg);
+				exit(1);
+			}
+			bindx_add_addrs = tmp_addrs;
+			break;
+		case 'C':
+			tmp_addrs = append_addr(optarg, connectx_addrs,
+						&connectx_count);
+			if (NULL = tmp_addrs) {
+				fprintf(stderr, "No memory to add ");
+				fprintf(stderr, "%s\n", optarg);
+				exit(1);
+			}
+			connectx_addrs = tmp_addrs;
+			break;
 		case '?':
 		default:
 			usage(argv[0]);
@@ -1365,7 +1597,7 @@ main(int argc, char *argv[])
 		usage(argv[0]);
 		exit(1);
 	}
-	if (CLIENT = role && NULL = remote_host) {
+	if (CLIENT = role && NULL = remote_host && connectx_count = 0) {
 		fprintf (stderr, "%s: Client needs at least remote address "
 			 "& port\n", argv[0]);
 		usage(argv[0]);
@@ -1397,6 +1629,13 @@ main(int argc, char *argv[])
                 exit(1);
 	}
 
+	if (remote_host != NULL && connectx_count != 0) {
+		fprintf(stderr, "%s: You can not provide both -h and -C options.\n",
+			argv[0]);
+		usage(argv[0]);
+		exit(1);
+	}
+
 	if (remote_host != NULL && remote_port != 0) {
 		struct addrinfo *res;
 		int error;
@@ -1460,6 +1699,23 @@ main(int argc, char *argv[])
 			    host_s, serv_s, res->ai_family);
         }
 
+	if (connectx_count != 0) {
+		switch (connectx_addrs->sa_family) {
+		case AF_INET:
+			t_addr = (struct sockaddr_in *)&s_rem;
+			r_len = sizeof(struct sockaddr_in);
+			memcpy(t_addr, connectx_addrs, r_len);
+			t_addr->sin_port = htons(remote_port);
+			break;
+		case AF_INET6:
+			t_addr6 = (struct sockaddr_in6 *)&s_rem;
+			r_len = sizeof(struct sockaddr_in6);
+			memcpy(t_addr6, connectx_addrs, r_len);
+			t_addr6->sin6_port = htons(remote_port);
+			break;
+		}
+	}
+
 	if (local_host != NULL) {
 		struct addrinfo *res;
 		int error;
-- 
1.6.5.2


