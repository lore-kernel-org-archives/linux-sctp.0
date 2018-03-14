From: David Miller <davem@davemloft.net>
Date: Wed, 14 Mar 2018 17:49:17 +0000
Subject: Re: [PATCH net-next 0/5] sctp: add support for some sctp auth APIs from RFC6458
Message-Id: <20180314.134917.40518319508243086.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 14 Mar 2018 19:05:29 +0800

> This patchset mainly adds support for SCTP AUTH Information for sendmsg,
> described in RFC6458:
> 
>     5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)
> 
> and also adds a sockopt described in RFC6458:
> 
>     8.3.4.  Deactivate a Shared Key (SCTP_AUTH_DEACTIVATE_KEY)
> 
> and two types of events for AUTHENTICATION_EVENT described in RFC6458:
> 
>     6.1.8.  SCTP_AUTHENTICATION_EVENT:
>              - SCTP_AUTH_NO_AUTH
>              - SCTP_AUTH_FREE_KEY
> 
> After this patchset, we have fully support for sctp_sendv in kernel.
> 
> Note that this patchset won't touch that sctp options merge conflict.

Series applied, thanks Xin.
