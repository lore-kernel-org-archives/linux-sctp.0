From: David Miller <davem@davemloft.net>
Date: Wed, 07 Mar 2018 15:56:49 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add support for some msg_control options from RFC6458
Message-Id: <20180307.105649.131608395647956746.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1520253539.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1520253539.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  5 Mar 2018 20:44:17 +0800

> This patchset is to add support for 3 msg_control options described
> in RFC6458:
> 
>     5.3.7.  SCTP PR-SCTP Information Structure (SCTP_PRINFO)
>     5.3.9.  SCTP Destination IPv4 Address Structure (SCTP_DSTADDRV4)
>     5.3.10. SCTP Destination IPv6 Address Structure (SCTP_DSTADDRV6)
> 
> one send flag described in RFC6458:
> 
>     SCTP_SENDALL:  This flag, if set, will cause a one-to-many
>     style socket to send the message to all associations that
>     are currently established on this socket.  For the one-to-
>     one style socket, this flag has no effect.
> 
> Note there is another msg_control option:
> 
>     5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)
> 
> It's a little complicated, I will post it in another patchset after
> this.

Series applied, thanks Xin.
