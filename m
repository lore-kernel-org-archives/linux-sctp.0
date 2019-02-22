From: David Miller <davem@davemloft.net>
Date: Fri, 22 Feb 2019 19:22:22 +0000
Subject: Re: [PATCH] sctp: don't compare hb_timer expire date before starting it
Message-Id: <20190222.112222.1641489327512557605.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190222084526.8214-1-maciej.kwiecien@nokia.com>
In-Reply-To: <20190222084526.8214-1-maciej.kwiecien@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kwiecienmaciek@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, alexander.sverdlin@nokia.com, maciej.kwiecien@nokia.com

From: kwiecienmaciek@gmail.com
Date: Fri, 22 Feb 2019 09:45:26 +0100

> From: Maciej Kwiecien <maciej.kwiecien@nokia.com>
> 
> hb_timer might not start at all for a particular transport because its
> start is conditional. In a result a node is not sending heartbeats.
> 
> Function sctp_transport_reset_hb_timer has two roles:
>     - initial start of hb_timer for a given transport,
>     - update expire date of hb_timer for a given transport.
> The function is optimized to update timer's expire only if it is before
> a new calculated one but this comparison is invalid for a timer which
> has not yet started. Such a timer has expire = 0 and if a new expire
> value is bigger than (MAX_JIFFIES / 2 + 2) then "time_before" macro will
> fail and timer will not start resulting in no heartbeat packets send by
> the node.
> 
> This was found when association was initialized within first 5 mins
> after system boot due to jiffies init value which is near to MAX_JIFFIES.
> 
> Test kernel version: 4.9.154 (ARCH=arm)
> hb_timer.expire = 0;                //initialized, not started timer
> new_expire = MAX_JIFFIES / 2 + 2;   //or more
> time_before(hb_timer.expire, new_expire) = false
> 
> Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
> Reported-by: Marcin Stojek <marcin.stojek@nokia.com>
> Tested-by: Marcin Stojek <marcin.stojek@nokia.com>
> Signed-off-by: Maciej Kwiecien <maciej.kwiecien@nokia.com>

Applied and queued up for -stable, thank you.
