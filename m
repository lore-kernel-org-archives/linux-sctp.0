From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 05 Mar 2018 23:52:26 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add support for some msg_control options from RFC6458
Message-Id: <20180305235226.GB27351@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1520253539.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1520253539.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Mon, Mar 05, 2018 at 08:44:17PM +0800, Xin Long wrote:
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

Other patches (than the 2nd one) LGTM.

  Marcelo
