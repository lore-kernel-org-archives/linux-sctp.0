From: David Miller <davem@davemloft.net>
Date: Tue, 17 Jun 2008 00:01:19 +0000
Subject: Re: [PATCH 2/2 v2] sctp: Correclty set changeover_active for
Message-Id: <20080616.170119.12283602.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1213365531-10049-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1213365531-10049-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, lksctp-developers@lists.sourceforge.net, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Jun 2008 09:58:51 -0400

> Not sure why the spacing got garbled in this patch, but here it
> again and looking much better.
> 
> --
> 
> Right now, any time we set a primary transport we set
> the changeover_active flag.  As a result, we invoke SFR-CACC
> even when there has been no changeover events.
> 
> Only set changeover_active, when there is a true changeover
> event, i.e. we had a primary path and we are changing to
> another transport.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-2.6, thanks!
