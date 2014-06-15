From: David Miller <davem@davemloft.net>
Date: Sun, 15 Jun 2014 08:18:30 +0000
Subject: Re: [PATCH net] net: sctp: fix permissions for rto_alpha and rto_beta knobs
Message-Id: <20140615.011830.1834645975843111936.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1402786754-16807-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1402786754-16807-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Sun, 15 Jun 2014 00:59:14 +0200

> Commit 3fd091e73b81 ("[SCTP]: Remove multiple levels of msecs
> to jiffies conversions.") has silently changed permissions for
> rto_alpha and rto_beta knobs from 0644 to 0444. The purpose of
> this was to discourage users from tweaking rto_alpha and
> rto_beta knobs in production environments since they are key
> to correctly compute rtt/srtt.
> 
> RFC4960 under section 6.3.1. RTO Calculation says regarding
> rto_alpha and rto_beta under rule C3 and C4:
 ...
> While it is discouraged to adjust rto_alpha and rto_beta
> and not further specified how to adjust them, the RFC also
> doesn't explicitly forbid it, but rather gives a RECOMMENDED
> default value (rto_alpha=3, rto_beta=2). We have a couple
> of users relying on the old permissions before they got
> changed. That said, if someone really has the urge to adjust
> them, we could allow it with a warning in the log.
> 
> Fixes: 3fd091e73b81 ("[SCTP]: Remove multiple levels of msecs to jiffies conversions.")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

This permission change seemed unintentional, and doesn't make
much sense anyways to me.

So I'm applying this, thanks Daniel.
