From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 09:18:55 +0000
Subject: Re: [PATCH 2/3] lksctp-tools: Add -T option to sctp_test
Message-Id: <496B0AFF.8040906@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4966E7AE.5070901@cn.fujitsu.com>
In-Reply-To: <4966E7AE.5070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad Yasevich:

Vlad Yasevich wrote:
> Hi Wei
>
> Just 2 questions...
>
> Wei Yongjun wrote:
>   
>> Add -T option to allow sctp_test use SOCK_STREAM tcp-style sockets.
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>> src/apps/sctp_test.c |   61
>> +++++++++++++++++++++++++++++++++++++++++++++-----
>> 1 files changed, 55 insertions(+), 6 deletions(-)
>>
>> diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
>> index 905a83e..fc93398 100644
>> --- a/src/apps/sctp_test.c
>> +++ b/src/apps/sctp_test.c
>> @@ -157,6 +157,7 @@ int max_stream = 0;
>> int seed = 0;
>> int max_msgsize = DEFAULT_MAX_WINDOW;
>> int assoc_pattern = ASSOC_PATTERN_SEQUENTIAL;
>> +int socket_type = SOCK_SEQPACKET;
>> int repeat_count = 0;
>> int listeners = 0;
>> int tosend = 0;
>> @@ -243,6 +244,7 @@ void usage(char *argv0)
>>     fprintf(stderr, "\t-L num-ports (default value 0). Run the mixed
>> mode\n");
>>     fprintf(stderr, "\t-S num-ports (default value 0). Run the mixed
>> mode\n");
>>     fprintf(stderr, "\t-D drain. If in client mode do a read following
>> send.\n");
>> +    fprintf(stderr, "\t-T use SOCK_STREAM tcp-style sockets.\n");
>>     fprintf(stderr, "\n");
>>     fflush(stderr);
>>
>> @@ -469,9 +471,10 @@ int socket_r(void)
>>     struct sctp_event_subscribe subscribe;
>>     int sk, error;
>>
>> -    DEBUG_PRINT(DEBUG_MIN, "\tsocket(SOCK_SEQPACKET, IPPROTO_SCTP)");
>> +    DEBUG_PRINT(DEBUG_MIN, "\tsocket(%s, IPPROTO_SCTP)",
>> +        (socket_type = SOCK_SEQPACKET) ? "SOCK_SEQPACKET" :
>> "SOCK_STREAM");
>>
>> -    if ((sk = socket(s_loc.ss_family, SOCK_SEQPACKET, IPPROTO_SCTP)) <
>> 0 ) {
>> +    if ((sk = socket(s_loc.ss_family, socket_type, IPPROTO_SCTP)) < 0 ) {
>>         if (do_exit) {
>>             fprintf(stderr, "\n\n\t\t*** socket: failed to create"
>>                 " socket:  %s ***\n",
>> @@ -573,6 +576,41 @@ int listen_r(int sk, int listen_count)
>>
>> } /* listen_r() */
>>
>> +int accept_r(int sk){
>> +    socklen_t len = 0;
>> +    int subsk;
>> +
>> +    DEBUG_PRINT(DEBUG_MIN, "\taccept(sk=%d)\n", sk);
>> +
>> +    subsk = accept(sk, NULL, &len);
>> +    if (subsk < 0) {
>> +        fprintf(stderr, "\n\n\t\t*** accept:  %s ***\n\n\n",
>> strerror(errno));
>> +        exit(1);
>> +    }
>> +
>> +    return subsk;
>> +} /* accept_r() */
>> +
>> +int connect_r(int sk, const struct sockaddr *serv_addr, socklen_t addrlen)
>> +{
>> +    int error = 0;
>> +
>> +    DEBUG_PRINT(DEBUG_MIN, "\tconnect(sk=%d)\n", sk);
>> +
>> +    /* Mark sk as being able to accept new associations */
>> +    error = connect(sk, serv_addr, addrlen);
>> +    if (error != 0) {
>> +        if (do_exit) {
>> +            fprintf(stderr, "\n\n\t\t*** connect:  %s ***\n\n\n",
>> +                strerror(errno));
>> +            exit(1);
>> +        }
>> +        else return -1;
>> +    }
>> +    return 0;
>> +
>> +} /* connect_r() */
>> +
>> int receive_r(int sk, int once)
>> {
>>     int i = 0, error = 0;
>> @@ -832,7 +870,7 @@ server(int sk)
>>         }    
>>     }
>>
>> -    receive_r(sk, 0);
>> +    receive_r(sk, (socket_type = SOCK_STREAM) ? 1 : 0);
>>
>>     
>
> Why only 1 message in the TCP case?  The client can send multiple messages.
>
>   
>> } /* server() */
>>
>> @@ -1095,7 +1133,7 @@ clean_up:
>>
>> void start_test(int role)
>> {
>> -    int sk;
>> +    int sk, subsk = -1;
>>     int i = 0;
>>     
>>     DEBUG_PRINT(DEBUG_NONE, "\nStarting tests...\n");
>> @@ -1114,6 +1152,12 @@ void start_test(int role)
>>
>>     if (role = SERVER) {
>>         listen_r(sk, 100);
>> +        if (socket_type = SOCK_STREAM)
>> +            subsk = accept_r(sk);
>> +        else
>> +            subsk = sk;
>> +    } else if (socket_type = SOCK_STREAM) {
>> +        connect_r(sk, (struct sockaddr *)&s_rem, r_len);
>>     }
>>
>>     
>
> Looks like in the TCP case, this code will only accept 1 connection and then
> end.  So multiple connections will fail to work.  Is that on purpose?  Should
> this be update to allow for multiple connections?
>   

Thanks for your comments. Patch has been changed to allow for multiple 
connections.

[PATCH 2/3] lksctp-tools: Add -T option to sctp_test

Add -T option to allow sctp_test use SOCK_STREAM tcp-style sockets.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 src/apps/sctp_test.c |   79 +++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 905a83e..d7c8e5f 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -157,6 +157,7 @@ int max_stream = 0;
 int seed = 0;
 int max_msgsize = DEFAULT_MAX_WINDOW;
 int assoc_pattern = ASSOC_PATTERN_SEQUENTIAL;
+int socket_type = SOCK_SEQPACKET;
 int repeat_count = 0;
 int listeners = 0;
 int tosend = 0;
@@ -164,6 +165,7 @@ _poll_sks poll_sks[MAX_POLL_SKS];
 int repeat = REPEAT;
 int msg_cnt = MSG_CNT;
 int drain = 0;
+int role = NOT_DEFINED;
 
 unsigned char msg[] = "012345678901234567890123456789012345678901234567890";
 
@@ -243,6 +245,7 @@ void usage(char *argv0)
 	fprintf(stderr, "\t-L num-ports (default value 0). Run the mixed mode\n");
 	fprintf(stderr, "\t-S num-ports (default value 0). Run the mixed mode\n");
 	fprintf(stderr, "\t-D drain. If in client mode do a read following send.\n");
+	fprintf(stderr, "\t-T use SOCK_STREAM tcp-style sockets.\n");
 	fprintf(stderr, "\n");
 	fflush(stderr);
 
@@ -469,9 +472,10 @@ int socket_r(void)
 	struct sctp_event_subscribe subscribe;
 	int sk, error;
 
-	DEBUG_PRINT(DEBUG_MIN, "\tsocket(SOCK_SEQPACKET, IPPROTO_SCTP)");
+	DEBUG_PRINT(DEBUG_MIN, "\tsocket(%s, IPPROTO_SCTP)",
+		(socket_type = SOCK_SEQPACKET) ? "SOCK_SEQPACKET" : "SOCK_STREAM");
 
-	if ((sk = socket(s_loc.ss_family, SOCK_SEQPACKET, IPPROTO_SCTP)) < 0 ) {
+	if ((sk = socket(s_loc.ss_family, socket_type, IPPROTO_SCTP)) < 0 ) {
 		if (do_exit) {
 			fprintf(stderr, "\n\n\t\t*** socket: failed to create"
 				" socket:  %s ***\n",
@@ -573,9 +577,44 @@ int listen_r(int sk, int listen_count)
 
 } /* listen_r() */
 
+int accept_r(int sk){
+	socklen_t len = 0;
+	int subsk;
+
+	DEBUG_PRINT(DEBUG_MIN, "\taccept(sk=%d)\n", sk);
+
+	subsk = accept(sk, NULL, &len);
+	if (subsk < 0) {
+		fprintf(stderr, "\n\n\t\t*** accept:  %s ***\n\n\n", strerror(errno));
+		exit(1);
+	}
+
+	return subsk;
+} /* accept_r() */
+
+int connect_r(int sk, const struct sockaddr *serv_addr, socklen_t addrlen)
+{
+	int error = 0;
+
+	DEBUG_PRINT(DEBUG_MIN, "\tconnect(sk=%d)\n", sk);
+
+	/* Mark sk as being able to accept new associations */
+	error = connect(sk, serv_addr, addrlen);
+	if (error != 0) {
+		if (do_exit) {
+			fprintf(stderr, "\n\n\t\t*** connect:  %s ***\n\n\n",
+				strerror(errno));
+			exit(1);
+		}
+		else return -1;
+	}
+	return 0;
+
+} /* connect_r() */
+
 int receive_r(int sk, int once)
 {
-	int i = 0, error = 0;
+	int recvsk = sk, i = 0, error = 0;
         char incmsg[CMSG_SPACE(sizeof(_sctp_cmsg_data_t))];
         struct iovec iov;
         struct msghdr inmessage;
@@ -596,10 +635,22 @@ int receive_r(int sk, int once)
 	/* Get the messages sent */
 	while (1) {
 
+		if (recvsk = sk && socket_type = SOCK_STREAM &&
+		    role = SERVER)
+			recvsk = accept_r(sk);
+
 		DEBUG_PRINT(DEBUG_MIN, "\trecvmsg(sk=%d) ", sk);
 
-		error = recvmsg(sk, &inmessage, MSG_WAITALL);
+		error = recvmsg(recvsk, &inmessage, MSG_WAITALL);
 		if (error < 0 && error != EAGAIN) {
+			if (errno = ENOTCONN && socket_type = SOCK_STREAM &&
+			    role = SERVER) {
+				printf("No association is present now!!\n");
+				close(recvsk);
+				recvsk = sk;
+				continue;
+			}
+
 			fprintf(stderr, "\n\t\t*** recvmsg: %s ***\n\n",
 					strerror(errno));
 			fflush(stdout);
@@ -607,11 +658,17 @@ int receive_r(int sk, int once)
 			else goto error_out;
 		}
 		else if (error = 0) {
+			if (socket_type = SOCK_STREAM && role = SERVER) {
+				printf("No association is present now!!\n");
+				close(recvsk);
+				recvsk = sk;
+				continue;
+			}
 			printf("\n\t\trecvmsg() returned 0 !!!!\n");
 			fflush(stdout);
 		}
 
-		if (print_message(sk, &inmessage, error) > 0)
+		if (print_message(recvsk, &inmessage, error) > 0)
 			continue; /* got a notification... */
 
 		inmessage.msg_control = incmsg;
@@ -622,6 +679,9 @@ int receive_r(int sk, int once)
 			break;
 	}
 
+	if (recvsk != sk)
+		close(recvsk);
+
 	free(iov.iov_base);
 	return 0;
 error_out:
@@ -1114,6 +1174,8 @@ void start_test(int role)
 
 	if (role = SERVER) {
 		listen_r(sk, 100);
+	} else if (socket_type = SOCK_STREAM) {
+		connect_r(sk, (struct sockaddr *)&s_rem, r_len);
 	}
 
 	if (!debug_level) {
@@ -1143,13 +1205,13 @@ void start_test(int role)
 int
 main(int argc, char *argv[])
 {
-	int c, role = NOT_DEFINED;
+	int c;
 	char *interface = NULL;
 	struct sockaddr_in *t_addr;
 	struct sockaddr_in6 *t_addr6;
 	
         /* Parse the arguments.  */
-        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:")) >= 0 ) {
+        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:T")) >= 0 ) {
 
                 switch (c) {
 		case 'H':
@@ -1281,6 +1343,9 @@ main(int argc, char *argv[])
 		case 'i':
 			interface = optarg;
 			break;
+		case 'T':
+			socket_type = SOCK_STREAM;
+			break;
 		case '?':
 		default:
 			usage(argv[0]);
-- 
1.5.3.8




