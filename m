From: David Miller <davem@davemloft.net>
Date: Thu, 22 Jan 2009 22:53:37 +0000
Subject: Re: [PATCH] sctp: regression bug fixes
Message-Id: <20090122.145337.257123667.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1232663768-4028-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1232663768-4028-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 22 Jan 2009 17:36:04 -0500

> This is a set of bug fixes that address various regressions reported to
> the sctp list as well and to me privately.
> 
> Here is the list:
>     1) SCTP checksum produced wrong result on big endian arch.
>     2) Sometimes SCTP connection would hang withtout transmitting anything.
>        Sometimes it would fail to retrnasmit after the second loss.
>     3) The accept code raced with input processing resulting in locking the
>        wrong socket.
> 
> Please apply and push to stable.

All applied and queued up for -stable, thanks Vlad.
