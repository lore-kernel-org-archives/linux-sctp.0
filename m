From: David Miller <davem@davemloft.net>
Date: Thu, 19 Jun 2014 00:03:41 +0000
Subject: Re: [PATCH net] net: sctp: propagate sysctl errors from proc_do* properly
Message-Id: <20140618.170341.270139335969927828.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403134290-23765-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1403134290-23765-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 19 Jun 2014 01:31:30 +0200

> sysctl handler proc_sctp_do_hmac_alg(), proc_sctp_do_rto_min() and
> proc_sctp_do_rto_max() do not properly reflect some error cases
> when writing values via sysctl from internal proc functions such
> as proc_dointvec() and proc_dostring().
> 
> In all these cases we pass the test for write != 0 and partially
> do additional work just to notice that additional sanity checks
> fail and we return with hard-coded -EINVAL while proc_do*
> functions might also return different errors. So fix this up by
> simply testing a successful return of proc_do* right after
> calling it.
> 
> This also allows to propagate its return value onwards to the user.
> While touching this, also fix up some minor style issues.
> 
> Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
> Fixes: 3c68198e7511 ("sctp: Make hmac algorithm selection for cookie generation dynamic")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks Daniel
