From: David Miller <davem@davemloft.net>
Date: Mon, 25 Aug 2008 22:17:05 +0000
Subject: Re: [PATCH] sctp: add verification checks to SCTP_AUTH_KEY option
Message-Id: <20080825.151705.193699685.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080825164440.GA504@kernel.sg>
	<12196959323990-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12196959323990-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, security@kernel.org, eteo@redhat.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 25 Aug 2008 16:25:32 -0400

> The structure used for SCTP_AUTH_KEY option contains a
> length that needs to be verfied to prevent buffer overflow
> conditions.  Spoted by Eugene Teo <eteo@redhat.com>.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied and queued up for -stable, thanks!
