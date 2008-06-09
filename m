From: David Miller <davem@davemloft.net>
Date: Mon, 09 Jun 2008 22:45:51 +0000
Subject: Re: [PATCH net-next] sctp: Fix problems with the new
Message-Id: <20080609.154551.202822490.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212807007-24379-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212807007-24379-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri,  6 Jun 2008 22:50:07 -0400

> The default sack frequency should be 2.  Also fix copy/paste
> error when updating all transports.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-next-2.6, thanks Vlad.
