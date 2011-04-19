From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 19 Apr 2011 08:10:53 +0000
Subject: Re: [PATCH net-next-2.6 0/8] sctp: some cleanup and tiny fix for
Message-Id: <4DAD438D.8040506@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
In-Reply-To: <4DAD18AB.3040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

Hi Wei Yongjun,

do you plan to send other patches, like "sctp: make sctp over IPv6 work wit=
h=20
IPsec.", too?


Regards,
Nicolas

Le 19/04/2011 07:07, Wei Yongjun a =C3=A9crit :
> Series of 8 patches against net-next-2.6, include some cleanup
> and tiny fix for add/del ip, which have been waiting on vlad's
> lksctp-dev tree for long times.
>
> Shan Wei (5):
>        sctp: delete unused macro definition of sctp_chunk_is_control
>        sctp: fix the comment of sctp_sf_violation_paramlen()
>        sctp: use common head of addr parameter to access member in addr-u=
nrelated code
>        sctp: kill abandoned SCTP_CMD_TRANSMIT command
>        sctp: use memdup_user to copy data from userspace
>
> Vlad Yasevich (3):
>        sctp: teach CACC algorithm about removed transports
>        sctp: Allow bindx_del to accept 0 port.
>        sctp: Release all routes when processing acks ADD_IP or DEL_IP
>
>   include/net/sctp/command.h   |    1 -
>   include/net/sctp/constants.h |    1 -
>   net/sctp/input.c             |    2 +-
>   net/sctp/outqueue.c          |   11 ++++++++---
>   net/sctp/sm_make_chunk.c     |   18 +++++++-----------
>   net/sctp/sm_sideeffect.c     |    6 ------
>   net/sctp/sm_statefuns.c      |    5 +++--
>   net/sctp/socket.c            |   28 +++++++++++-----------------
>   8 files changed, 30 insertions(+), 42 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
