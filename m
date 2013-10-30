From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 30 Oct 2013 15:24:08 +0000
Subject: Re: [lksctp-developers] sctp_status: Got sendmsg: Invalid argument when set max_stream larger than 1
Message-Id: <52712498.8010601@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPwn2JQRx3j3GieoZaFh4wO7MPGmZPNY9W2U7hsQJ0xUULX3MA@mail.gmail.com>
In-Reply-To: <CAPwn2JQRx3j3GieoZaFh4wO7MPGmZPNY9W2U7hsQJ0xUULX3MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 10/27/2013 04:11 AM, Hangbin Liu wrote:
> Hi Daniel,
>
> When I run sctp_status test and set max_stream >=3D 10, the client will
> fail with "sendmsg: Invalid argument". Would you like to help have a
> look at this?
>
> # ./sctp_status -H 127.0.0.1 -P 9998 -h 127.0.0.1 -p 9999 -s -d 2 -M 20
> remote:addr=127.0.0.1, port=3Ddistinct, family=3D2
> local:addr=127.0.0.1, port=3Ddistinct32, family=3D2
>
> Starting tests...
>          socket(SOCK_STREAM, IPPROTO_SCTP)  ->  sk=3D3
>          bind(sk=3D3, [a:127.0.0.1,p:distinct32])  --  attempt 1/10
>          connect(sk=3D3)
> Client: Sending packets.(1/10)
>          sendmsg(sk=3D3, assoc=3D0) 17768 bytes.
>            SNDRCV(stream=3D1 flags=3D0x1 ppid=846930886)
>          sendmsg(sk=3D3, assoc=3D0) 6250 bytes.
>            SNDRCV(stream=3D2 flags=3D0x1 ppid=1714636915)
>          sendmsg(sk=3D3, assoc=3D0) 23634 bytes.
>            SNDRCV(stream=3D3 flags=3D0x1 ppidB4238335)
>          sendmsg(sk=3D3, assoc=3D0) 5195 bytes.
>            SNDRCV(stream=3D4 flags=3D0x1 ppid=1649760492)
>          sendmsg(sk=3D3, assoc=3D0) 7978 bytes.
>            SNDRCV(stream=3D5 flags=3D0x1 ppid=1189641421)
>          sendmsg(sk=3D3, assoc=3D0) 22715 bytes.
>            SNDRCV(stream=3D6 flags=3D0x1 ppid=1350490027)
>          sendmsg(sk=3D3, assoc=3D0) 16883 bytes.
>            SNDRCV(stream=3D7 flags=3D0x1 ppid=1102520059)
>          sendmsg(sk=3D3, assoc=3D0) 10724 bytes.
>            SNDRCV(stream=3D8 flags=3D0x1 ppid=1967513926)
>          sendmsg(sk=3D3, assoc=3D0)  125 bytes.
>            SNDRCV(stream=3D9 flags=3D0x1 ppid=1540383426)
>          sendmsg(sk=3D3, assoc=3D0) 2133 bytes.
>            SNDRCV(stream=10 flags=3D0x1 ppid=1303455736)
>
>                  *** sendmsg: Invalid argument ***

Hangbin, the below fix should do it (it worked for you up to that point as
that is the default number of streams) ... will push that _at latest_ on
Sunday night as I'll be mostly on travel the next days.

Well, looking at the code, at some point in time these tools need a fresh
start in general; those were probably just quickly clobbered together from
the very early days of lksctp. :)

diff --git a/src/apps/sctp_status.c b/src/apps/sctp_status.c
index 3a05dc4..5bb48ef 100644
--- a/src/apps/sctp_status.c
+++ b/src/apps/sctp_status.c
@@ -675,11 +675,11 @@ int next_stream(int state, int pattern)
  {
  	switch (pattern){
  	case STREAM_PATTERN_RANDOM:
-		state =3D rand() % (max_stream + 1);
+		state =3D rand() % max_stream;
  		break;
  	case STREAM_PATTERN_SEQUENTIAL:
  		state =3D state + 1;
-		if (state > max_stream)
+		if (state >=3D max_stream)
  			state =3D 0;
  		break;
  	}
@@ -723,7 +723,7 @@ void client(int sk) {
  } /* client() */

  void start_test(int role) {
-	int sk, pid;
+	int sk, pid, ret;
  	int i =3D 0;

  	DEBUG_PRINT(DEBUG_NONE, "\nStarting tests...\n");
@@ -745,6 +745,22 @@ void start_test(int role) {
  		listen_r(sk, 1);
  		accept_r(sk);
  	} else {
+		if (max_stream > 0) {
+			struct sctp_initmsg initmsg;
+
+			memset(&initmsg, 0, sizeof(initmsg));
+			initmsg.sinit_num_ostreams =3D max_stream;
+			initmsg.sinit_max_instreams =3D max_stream;
+			initmsg.sinit_max_attempts =3D 3;
+
+			ret =3D setsockopt(sk, IPPROTO_SCTP, SCTP_INITMSG,
+					 &initmsg, sizeof(initmsg));
+			if (ret < 0) {
+				perror("setsockopt(SCTP_INITMSG)");
+				exit(0);
+			}
+		}
+
  		connect_r(sk, (struct sockaddr *)&s_rem, r_len);
  	}

