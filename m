From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 22 Nov 2012 13:23:16 +0000
Subject: [PATCH] sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall
Message-Id: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>, Tommi Rantala <tt.rantala@gmail.com>

Consider the following program, that sets the second argument to the
sendto() syscall incorrectly:

 #include <string.h>
 #include <arpa/inet.h>
 #include <sys/socket.h>

 int main(void)
 {
         int fd;
         struct sockaddr_in sa;

         fd =3D socket(AF_INET, SOCK_STREAM, 132 /*IPPROTO_SCTP*/);
         if (fd < 0)
                 return 1;

         memset(&sa, 0, sizeof(sa));
         sa.sin_family =3D AF_INET;
         sa.sin_addr.s_addr =3D inet_addr("127.0.0.1");
         sa.sin_port =3D htons(11111);

         sendto(fd, NULL, 1, 0, (struct sockaddr *)&sa, sizeof(sa));

         return 0;
 }

We get -ENOMEM:

 $ strace -e sendto ./demo
 sendto(3, NULL, 1, 0, {sa_family=AF_INET, sin_port=3Dhtons(11111), sin_add=
r=3Dinet_addr("127.0.0.1")}, 16) =3D -1 ENOMEM (Cannot allocate memory)

Propagate the error code from sctp_user_addto_chunk(), so that we will
tell user space what actually went wrong:

 $ strace -e sendto ./demo
 sendto(3, NULL, 1, 0, {sa_family=AF_INET, sin_port=3Dhtons(11111), sin_add=
r=3Dinet_addr("127.0.0.1")}, 16) =3D -1 EFAULT (Bad address)

Noticed while running Trinity (the syscall fuzzer).

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 net/sctp/chunk.c  |   13 +++++++++----
 net/sctp/socket.c |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index d241ef5..3952ca9 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -183,7 +183,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp=
_association *asoc,
=20
 	msg =3D sctp_datamsg_new(GFP_KERNEL);
 	if (!msg)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	/* Note: Calculate this outside of the loop, so that all fragments
 	 * have the same expiration.
@@ -280,8 +280,11 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sct=
p_association *asoc,
=20
 		chunk =3D sctp_make_datafrag_empty(asoc, sinfo, len, frag, 0);
=20
-		if (!chunk)
+		if (!chunk) {
+			err =3D -ENOMEM;
 			goto errout;
+		}
+
 		err =3D sctp_user_addto_chunk(chunk, offset, len, msgh->msg_iov);
 		if (err < 0)
 			goto errout_chunk_put;
@@ -315,8 +318,10 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sct=
p_association *asoc,
=20
 		chunk =3D sctp_make_datafrag_empty(asoc, sinfo, over, frag, 0);
=20
-		if (!chunk)
+		if (!chunk) {
+			err =3D -ENOMEM;
 			goto errout;
+		}
=20
 		err =3D sctp_user_addto_chunk(chunk, offset, over,msgh->msg_iov);
=20
@@ -342,7 +347,7 @@ errout:
 		sctp_chunk_free(chunk);
 	}
 	sctp_datamsg_put(msg);
-	return NULL;
+	return ERR_PTR(err);
 }
=20
 /* Check whether this message has expired. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a60d1f8..406d957 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1915,8 +1915,8 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, stru=
ct sock *sk,
=20
 	/* Break the message into multiple chunks of maximum size. */
 	datamsg =3D sctp_datamsg_from_user(asoc, sinfo, msg, msg_len);
-	if (!datamsg) {
-		err =3D -ENOMEM;
+	if (IS_ERR(datamsg)) {
+		err =3D PTR_ERR(datamsg);
 		goto out_free;
 	}
=20
--=20
1.7.9.5

