From: David Miller <davem@davemloft.net>
Date: Fri, 09 May 2008 22:15:09 +0000
Subject: Re: [PATCH next-2.6 2/3] [SCTP]: Support the new specification of
Message-Id: <20080509.151509.02016793.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360481-16599-1-git-send-email-vladislav.yasevich@hp.com>
	<1210360566-16661-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1210360566-16661-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri,  9 May 2008 15:16:05 -0400

> The specification of sctp_connectx() has been changed to return
> an association id.  We've added a new socket option that will
> return the association id as the return value from the setsockopt()
> call.  The library that implements sctp_connectx() interface will
> implement both socket options.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
