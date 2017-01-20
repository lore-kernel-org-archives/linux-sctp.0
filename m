From: David Miller <davem@davemloft.net>
Date: Fri, 20 Jan 2017 16:26:26 +0000
Subject: Re: [PATCH] net: sctp: fix array overrun read on sctp_timer_tbl
Message-Id: <20170120.112626.159194842548687734.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170120130157.20034-1-colin.king@canonical.com>
In-Reply-To: <20170120130157.20034-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: colin.king@canonical.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 20 Jan 2017 13:01:57 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison on the timeout can lead to an array overrun
> read on sctp_timer_tbl because of an off-by-one error. Fix
> this by using < instead of <= and also compare to the array
> size rather than SCTP_EVENT_TIMEOUT_MAX.
> 
> Fixes CoverityScan CID#1397639 ("Out-of-bounds read")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
