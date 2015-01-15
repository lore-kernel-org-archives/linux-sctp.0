From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 15 Jan 2015 15:34:35 +0000
Subject: [PATCH net] net: sctp: fix race for one-to-many sockets in sendmsg's auto associate
Message-Id: <1421336075-25061-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net
Cc: vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

I.e. one-to-many sockets in SCTP are not required to explicitly
call into connect(2) or sctp_connectx(2) prior to data exchange.
Instead, they can directly invoke sendmsg(2) and the SCTP stack
will automatically trigger connection establishment through 4WHS
via sctp_primitive_ASSOCIATE(). However, this in its current
implementation is racy: INIT is being sent out immediately (as
it cannot be bundled anyway) and the rest of the DATA chunks are
queued up for later xmit when connection is established, meaning
sendmsg(2) will return successfully. This behaviour can result
in an undesired side-effect that the kernel made the application
think the data has already been transmitted, although none of it
has actually left the machine, worst case even after close(2)'ing
the socket.

Instead, when the association from client side has been shut down
e.g. first gracefully through SCTP_EOF and then close(2), the
client could afterwards still receive the server's INIT_ACK due
to a connection with higher latency. This INIT_ACK is then considered
out of the blue and hence responded with ABORT as there was no
alive assoc found anymore. This can be easily reproduced f.e.
with sctp_test application from lksctp. One way to fix this race
is to wait for the handshake to actually complete.

The fix defers waiting after sctp_primitive_ASSOCIATE() and
sctp_primitive_SEND() succeeded, so that DATA chunks cooked up
from sctp_sendmsg() have already been placed into the output
queue through the side-effect interpreter, and therefore can then
be bundeled together with COOKIE_ECHO control chunks.

strace from example application (shortened):

socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP) =3D 3
sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), sin_=
addr=3Dinet_addr("192.168.1.115")},
           msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0},=
 0) =3D 5
sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), sin_=
addr=3Dinet_addr("192.168.1.115")},
           msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0},=
 0) =3D 5
sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), sin_=
addr=3Dinet_addr("192.168.1.115")},
           msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0},=
 0) =3D 5
sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), sin_=
addr=3Dinet_addr("192.168.1.115")},
           msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0},=
 0) =3D 5
sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), sin_=
addr=3Dinet_addr("192.168.1.115")},
           msg_iov(0)=3D[], msg_controllenH, {cmsg_lenH, cmsg_level=3D0x84 =
/* SOL_??? */, cmsg_type=3D, ...},
           msg_flags=3D0}, 0) =3D 0 // graceful shutdown for SOCK_SEQPACKET=
 via SCTP_EOF
close(3) =3D 0

tcpdump before patch (fooling the application):

22:33:36.306142 IP 192.168.1.114.41462 > 192.168.1.115.8888: sctp (1) [INIT=
] [init tag: 3879023686] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN: 31=
39201684]
22:33:36.316619 IP 192.168.1.115.8888 > 192.168.1.114.41462: sctp (1) [INIT=
 ACK] [init tag: 3345394793] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN: 3=
380109591]
22:33:36.317600 IP 192.168.1.114.41462 > 192.168.1.115.8888: sctp (1) [ABOR=
T]

tcpdump after patch:

14:28:58.884116 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [INIT=
] [init tag: 438593213] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN: 309=
2969729]
14:28:58.888414 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [INIT=
 ACK] [init tag: 381429855] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN: 21=
41904492]
14:28:58.888638 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [COOK=
IE ECHO] , (2) [DATA] (B)(E) [TSN: 3092969729] [...]
14:28:58.893278 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [COOK=
IE ACK] , (2) [SACK] [cum ack 3092969729] [a_rwnd 106491] [#gap acks 0] [#d=
up tsns 0]
14:28:58.893591 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [DATA=
] (B)(E) [TSN: 3092969730] [...]
14:28:59.096963 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SACK=
] [cum ack 3092969730] [a_rwnd 106496] [#gap acks 0] [#dup tsns 0]
14:28:59.097086 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [DATA=
] (B)(E) [TSN: 3092969731] [...] , (2) [DATA] (B)(E) [TSN: 3092969732] [...]
14:28:59.103218 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SACK=
] [cum ack 3092969732] [a_rwnd 106486] [#gap acks 0] [#dup tsns 0]
14:28:59.103330 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [SHUT=
DOWN]
14:28:59.107793 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SHUT=
DOWN ACK]
14:28:59.107890 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [SHUT=
DOWN COMPLETE]

Looks like this bug is from the pre-git history museum. ;)

Fixes: 08707d5482df ("lksctp-2_5_31-0_5_1.patch")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/socket.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2625ecc..aafe94b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1603,7 +1603,7 @@ static int sctp_sendmsg(struct kiocb *iocb, struct so=
ck *sk,
 	sctp_assoc_t associd =3D 0;
 	sctp_cmsgs_t cmsgs =3D { NULL };
 	sctp_scope_t scope;
-	bool fill_sinfo_ttl =3D false;
+	bool fill_sinfo_ttl =3D false, wait_connect =3D false;
 	struct sctp_datamsg *datamsg;
 	int msg_flags =3D msg->msg_flags;
 	__u16 sinfo_flags =3D 0;
@@ -1943,6 +1943,7 @@ static int sctp_sendmsg(struct kiocb *iocb, struct so=
ck *sk,
 		if (err < 0)
 			goto out_free;
=20
+		wait_connect =3D true;
 		pr_debug("%s: we associated primitively\n", __func__);
 	}
=20
@@ -1980,6 +1981,11 @@ static int sctp_sendmsg(struct kiocb *iocb, struct s=
ock *sk,
 	sctp_datamsg_put(datamsg);
 	err =3D msg_len;
=20
+	if (unlikely(wait_connect)) {
+		timeo =3D sock_sndtimeo(sk, msg_flags & MSG_DONTWAIT);
+		sctp_wait_for_connect(asoc, &timeo);
+	}
+
 	/* If we are already past ASSOCIATE, the lower
 	 * layers are responsible for association cleanup.
 	 */
--=20
1.7.11.7

