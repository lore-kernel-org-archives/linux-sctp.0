From: David Miller <davem@davemloft.net>
Date: Thu, 09 Oct 2008 21:33:08 +0000
Subject: Re: [PATCH net-next 2/3] sctp: Fix SNMP number of SCTP_MIB_ABORTED
Message-Id: <20081009.143308.205088695.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
	<1223558975-1550-4-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223558975-1550-4-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu,  9 Oct 2008 09:29:34 -0400

> If ABORT chunks require authentication and a protocol violation
> is triggered, we do not tear down the association.  Subsequently,
> we should not increment SCTP_MIB_ABORTED.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
