From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 16 Jan 2015 14:31:56 +0000
Subject: Re: [PATCH net] net: sctp: fix race for one-to-many sockets in sendmsg's auto associate
Message-Id: <54B920DC.5060209@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1421336075-25061-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1421336075-25061-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 01/15/2015 10:34 AM, Daniel Borkmann wrote:
> I.e. one-to-many sockets in SCTP are not required to explicitly
> call into connect(2) or sctp_connectx(2) prior to data exchange.
> Instead, they can directly invoke sendmsg(2) and the SCTP stack
> will automatically trigger connection establishment through 4WHS
> via sctp_primitive_ASSOCIATE(). However, this in its current
> implementation is racy: INIT is being sent out immediately (as
> it cannot be bundled anyway) and the rest of the DATA chunks are
> queued up for later xmit when connection is established, meaning
> sendmsg(2) will return successfully. This behaviour can result
> in an undesired side-effect that the kernel made the application
> think the data has already been transmitted, although none of it
> has actually left the machine, worst case even after close(2)'ing
> the socket.
>=20
> Instead, when the association from client side has been shut down
> e.g. first gracefully through SCTP_EOF and then close(2), the
> client could afterwards still receive the server's INIT_ACK due
> to a connection with higher latency. This INIT_ACK is then considered
> out of the blue and hence responded with ABORT as there was no
> alive assoc found anymore. This can be easily reproduced f.e.
> with sctp_test application from lksctp. One way to fix this race
> is to wait for the handshake to actually complete.
>=20
> The fix defers waiting after sctp_primitive_ASSOCIATE() and
> sctp_primitive_SEND() succeeded, so that DATA chunks cooked up
> from sctp_sendmsg() have already been placed into the output
> queue through the side-effect interpreter, and therefore can then
> be bundeled together with COOKIE_ECHO control chunks.
>=20
> strace from example application (shortened):
>=20
> socket(PF_INET, SOCK_SEQPACKET, IPPROTO_SCTP) =3D 3
> sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), si=
n_addr=3Dinet_addr("192.168.1.115")},
>            msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0=
}, 0) =3D 5
> sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), si=
n_addr=3Dinet_addr("192.168.1.115")},
>            msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0=
}, 0) =3D 5
> sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), si=
n_addr=3Dinet_addr("192.168.1.115")},
>            msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0=
}, 0) =3D 5
> sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), si=
n_addr=3Dinet_addr("192.168.1.115")},
>            msg_iov(1)=3D[{"hello", 5}], msg_controllen=3D0, msg_flags=3D0=
}, 0) =3D 5
> sendmsg(3, {msg_name(28)=3D{sa_family=AF_INET, sin_port=3Dhtons(8888), si=
n_addr=3Dinet_addr("192.168.1.115")},
>            msg_iov(0)=3D[], msg_controllenH, {cmsg_lenH, cmsg_level=3D0x8=
4 /* SOL_??? */, cmsg_type=3D, ...},
>            msg_flags=3D0}, 0) =3D 0 // graceful shutdown for SOCK_SEQPACK=
ET via SCTP_EOF
> close(3) =3D 0
>=20
> tcpdump before patch (fooling the application):
>=20
> 22:33:36.306142 IP 192.168.1.114.41462 > 192.168.1.115.8888: sctp (1) [IN=
IT] [init tag: 3879023686] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN: =
3139201684]
> 22:33:36.316619 IP 192.168.1.115.8888 > 192.168.1.114.41462: sctp (1) [IN=
IT ACK] [init tag: 3345394793] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN:=
 3380109591]
> 22:33:36.317600 IP 192.168.1.114.41462 > 192.168.1.115.8888: sctp (1) [AB=
ORT]
>=20
> tcpdump after patch:
>=20
> 14:28:58.884116 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [IN=
IT] [init tag: 438593213] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN: 3=
092969729]
> 14:28:58.888414 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [IN=
IT ACK] [init tag: 381429855] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN: =
2141904492]
> 14:28:58.888638 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [CO=
OKIE ECHO] , (2) [DATA] (B)(E) [TSN: 3092969729] [...]
> 14:28:58.893278 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [CO=
OKIE ACK] , (2) [SACK] [cum ack 3092969729] [a_rwnd 106491] [#gap acks 0] [=
#dup tsns 0]
> 14:28:58.893591 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [DA=
TA] (B)(E) [TSN: 3092969730] [...]
> 14:28:59.096963 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SA=
CK] [cum ack 3092969730] [a_rwnd 106496] [#gap acks 0] [#dup tsns 0]
> 14:28:59.097086 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [DA=
TA] (B)(E) [TSN: 3092969731] [...] , (2) [DATA] (B)(E) [TSN: 3092969732] [.=
..]
> 14:28:59.103218 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SA=
CK] [cum ack 3092969732] [a_rwnd 106486] [#gap acks 0] [#dup tsns 0]
> 14:28:59.103330 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [SH=
UTDOWN]
> 14:28:59.107793 IP 192.168.1.115.8888 > 192.168.1.114.35846: sctp (1) [SH=
UTDOWN ACK]
> 14:28:59.107890 IP 192.168.1.114.35846 > 192.168.1.115.8888: sctp (1) [SH=
UTDOWN COMPLETE]
>=20
> Looks like this bug is from the pre-git history museum. ;)
>=20
> Fixes: 08707d5482df ("lksctp-2_5_31-0_5_1.patch")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

We also need to be remember that the same scenario can be reproduced withou=
t an
implicit connect by simply using non-blocking socket on a high rtt link.  I=
've made this
comment privately to Daniel, but want to mention this on the list.  Daniel =
and I will be
working on additional patches to address that issue.

-vlad

> ---
>  net/sctp/socket.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 2625ecc..aafe94b 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1603,7 +1603,7 @@ static int sctp_sendmsg(struct kiocb *iocb, struct =
sock *sk,
>  	sctp_assoc_t associd =3D 0;
>  	sctp_cmsgs_t cmsgs =3D { NULL };
>  	sctp_scope_t scope;
> -	bool fill_sinfo_ttl =3D false;
> +	bool fill_sinfo_ttl =3D false, wait_connect =3D false;
>  	struct sctp_datamsg *datamsg;
>  	int msg_flags =3D msg->msg_flags;
>  	__u16 sinfo_flags =3D 0;
> @@ -1943,6 +1943,7 @@ static int sctp_sendmsg(struct kiocb *iocb, struct =
sock *sk,
>  		if (err < 0)
>  			goto out_free;
> =20
> +		wait_connect =3D true;
>  		pr_debug("%s: we associated primitively\n", __func__);
>  	}
> =20
> @@ -1980,6 +1981,11 @@ static int sctp_sendmsg(struct kiocb *iocb, struct=
 sock *sk,
>  	sctp_datamsg_put(datamsg);
>  	err =3D msg_len;
> =20
> +	if (unlikely(wait_connect)) {
> +		timeo =3D sock_sndtimeo(sk, msg_flags & MSG_DONTWAIT);
> +		sctp_wait_for_connect(asoc, &timeo);
> +	}
> +
>  	/* If we are already past ASSOCIATE, the lower
>  	 * layers are responsible for association cleanup.
>  	 */
>=20

