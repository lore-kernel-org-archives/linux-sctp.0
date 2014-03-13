From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 13 Mar 2014 08:54:48 +0000
Subject: Re: 1.0.16 sctp_connectx() in 32 bit
Message-Id: <53217258.1030603@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5321185A.8050700@gmail.com>
In-Reply-To: <5321185A.8050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 03/13/2014 03:30 AM, Dong Liu wrote:
> Hi,
>
> I think I found a problem in the new sctp_connectx() code.
>
> in sctp_connectx3() there are,
>
>      struct sctp_getaddrs_old param;
>      socklen_t opt_len =3D sizeof(param);
>      status getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX3, &param, &opt=
_len);
>
> And in kernel net/sctp/socket.c sctp_getsockopt_connectx3(), there is a c=
heck,
>
>              if (len < sizeof(param)) |
>                  return -EINVAL;                                         =
                |
>
> But struct sctp_getaddrs_old contains a pointer . When compiled in 32 bit=
 or 64 bit,
 > the size of sctp_getaddrs_old is different. So if the kernel is in 64 bi=
t mode but
 > the libsctp is in 32 bit mode. sctp_connectx() will fail with EINVAL.

Kernel issue already fixed in:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=FFd5939381c609056b33b7585fb05a77b4c695f3

> Thanks,
>
> Dong
