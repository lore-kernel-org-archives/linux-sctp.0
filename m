From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 26 Nov 2012 15:35:25 +0000
Subject: Re: how to use sctp_sendmsg to send ABORT chunk
Message-Id: <50B38C3D.5030307@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20844e51.131ec.13b30c4ebec.Coremail.elliehct@163.com>
In-Reply-To: <20844e51.131ec.13b30c4ebec.Coremail.elliehct@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 11/23/2012 11:55 PM, =D0=A1=BA=D8 wrote:
> dear  lksctp Project,
>    i met a problem about sending abort chunk. if you have time, please he=
lp me.       i'm using the lksctp to develop my function, which is for send=
ing Abort chunk.        platform of my development : Redhat centos 5.5 and =
verion  of linux kernel is 2.18.        according to "man sctp_sendmsg", ju=
st set flags to SCTP_ABORT.        my partial code.------------------------=
---------------------------------------------------------------------------=
-----------------------struct msghdr msg;struct cmsghdr cmsg; struct iovec =
iov;        static char error_code=3D 12;	iov.iov_base =3D &error_code;	iov=
.iov_len =3D 1;cmsg.cmsg_level =3D IPPROTO_SCTP;cmsg.cmsg_type =3D SCTP_SND=
RV;cmsg.cmsg_len =3D sizeof(struct cmsghdr);msg.msg_name =3D (SOCKADDR*)&se=
rAddr;	msg.msg_namelen =3D sizeof(serAddr);	msg.msg_iov =3D &iov;	msg.msg_i=
ovlen =3D 1;	msg.msg_control =3D &cmsg;	msg.msg_controllen =3D sizeof(cmsg)=
;        ret =3D sctp_sendmsg(sock_fd, (void*)&msg, sizeof(msg), (SOCKADDR*=
)&serAddr,                                   sizeo
f(serAddr),sri.sinfo_ppid, (SCTP_ABORT),                           sri.sinf=
o_stream, sri.sinfo_timetolive,sri.sinfo_context);-------------------------=
---------------------------------------------------------------------------=
----------------but the ret < 0 and the errno is 22 that is invalid agument=
.please tell which argument is error and how to set cause of abort chunk in=
to "struct msghdr" best regardsthank you fangmin.cao

First, the msg argument is just a buffer to send, not a msghdr.  Second=20
the SCTP_ABORT is set in the flags parameter of sctp_sendmsg().  Third,
SCTP_ABORT is not supported on a SOCK_STREAM socket.
That should get you what you want.

-vlad

