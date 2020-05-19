From: David Miller <davem@davemloft.net>
Date: Tue, 19 May 2020 22:48:05 +0000
Subject: Re: [PATCH] sctp: Don't add the shutdown timer if its already been added
Message-Id: <20200519.154805.2002435538113436383.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200519200405.857632-1-nhorman@tuxdriver.com>
In-Reply-To: <20200519200405.857632-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, jere.leppanen@nokia.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 19 May 2020 16:04:05 -0400

> This BUG halt was reported a while back, but the patch somehow got
> missed:
> 
 ...
> It appears that the side effect that starts the shutdown timer was processed
> multiple times, which can happen as multiple paths can trigger it.  This of
> course leads to the BUG halt in add_timer getting called.
> 
> Fix seems pretty straightforward, just check before the timer is added if its
> already been started.  If it has mod the timer instead to min(current
> expiration, new expiration)
> 
> Its been tested but not confirmed to fix the problem, as the issue has only
> occured in production environments where test kernels are enjoined from being
> installed.  It appears to be a sane fix to me though.  Also, recentely,
> Jere found a reproducer posted on list to confirm that this resolves the
> issues
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied and queued up for -stable, thanks.
