From: David Miller <davem@davemloft.net>
Date: Wed, 20 Apr 2011 08:55:49 +0000
Subject: Re: [PATCH net-next-2.6 0/9] SCTP updates for net-next-2.6
Message-Id: <20110420.015549.229758929.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAE8A27.3040007@cn.fujitsu.com>
In-Reply-To: <4DAE8A27.3040007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 15:24:23 +0800

> Here is a set of SCTP patches for net-next-2.6, also from vlad's
> lksctp-dev tree.  Please apply.
> 
> Shan Wei (4):
>       sctp: check parameter value of length in ERROR chunk
>       sctp: check invalid value of length parameter in error cause
>       sctp: remove redundant check when walking through a list of TLV parameters
>       sctp: handle ootb packet in chunk order as defined
> 
> Vlad Yasevich (2):
>       sctp: remove completely unsed EMPTY state
>       sctp: bail from sctp_endpoint_lookup_assoc() if not bound.
> 
> Wei Yongjun (3):
>       sctp: fix to check the source address of COOKIE-ECHO chunk
>       sctp: make heartbeat information in sctp_make_heartbeat()
>       sctp: move chunk from retransmit queue to abandoned list

Applied, thanks for doing these backports from Vlad's tree.
