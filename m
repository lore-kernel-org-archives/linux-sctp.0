From: David Miller <davem@davemloft.net>
Date: Thu, 19 Jun 2008 23:09:27 +0000
Subject: Re: [PATCH net-next] sctp: new functionality
Message-Id: <20080619.160927.250828465.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <12139142813418-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12139142813418-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 19 Jun 2008 18:24:39 -0400

> The following 2 patch implement aspects of the SCTP spec that have been
> missing.
> 
> The first one implements the recomendation of validating Verifiation
> TAGs carried inside of ICMP messages.
> 
> The second implements a security recomendation that prevents some flooding
> attacks by only respoding with a single packet.

Both patches applied and pushed out to net-next-2.6

Please send me a patch to fix the following new warning these changes
introduced:

net/sctp/associola.c:1024: warning: unused variable 'outq'

Thanks.
