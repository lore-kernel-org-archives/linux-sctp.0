From: David Miller <davem@davemloft.net>
Date: Thu, 18 Sep 2008 23:29:48 +0000
Subject: Re: [PATCH 2/2] sctp: Fix oops when INIT-ACK indicates that peer
Message-Id: <20080918.162948.150019388.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com>
	<1221773464-28845-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1221773464-28845-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, netdev@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 18 Sep 2008 17:31:04 -0400

> If INIT-ACK is received with SupportedExtensions parameter which
> indicates that the peer does not support AUTH, the packet will be
> silently ignore, and sctp_process_init() do cleanup all of the
> transports in the association.
> When T1-Init timer is expires, OOPS happen while we try to choose
> a different init transport.
> 
> The solution is to only clean up the non-active transports, i.e
> the ones that the peer added.  However, that introduces a problem
> with sctp_connectx(), because we don't mark the proper state for
> the transports provided by the user.  So, we'll simply mark
> user-provided transports as ACTIVE.  That will allow INIT
> retransmissions to work properly in the sctp_connectx() context
> and prevent the crash.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
