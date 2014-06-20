From: David Miller <davem@davemloft.net>
Date: Fri, 20 Jun 2014 04:31:37 +0000
Subject: Re: [PATCH net] net: sctp: check proc_dointvec result in proc_sctp_do_auth
Message-Id: <20140619.213137.2272589325097681936.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403127991-18114-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1403127991-18114-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 18 Jun 2014 23:46:31 +0200

> When writing to the sysctl field net.sctp.auth_enable, it can well
> be that the user buffer we handed over to proc_dointvec() via
> proc_sctp_do_auth() handler contains something other than integers.
> 
> In that case, we would set an uninitialized 4-byte value from the
> stack to net->sctp.auth_enable that can be leaked back when reading
> the sysctl variable, and it can unintentionally turn auth_enable
> on/off based on the stack content since auth_enable is interpreted
> as a boolean.
> 
> Fix it up by making sure proc_dointvec() returned sucessfully.
> 
> Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
> Reported-by: Florian Westphal <fwestpha@redhat.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks Daniel.
