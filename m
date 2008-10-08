From: David Miller <davem@davemloft.net>
Date: Wed, 08 Oct 2008 21:19:08 +0000
Subject: Re: [PATCH net-next 1/2] sctp: Rework the tsn map to use generic
Message-Id: <20081008.141908.230868244.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223497670-519-1-git-send-email-vladislav.yasevich@hp.com>
	<1223497670-519-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223497670-519-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  8 Oct 2008 16:27:49 -0400

> The tsn map currently use is 4K large and is stuck inside
> the sctp_association structure making memory references REALLY
> expensive.  What we really need is at most 4K worth of bits
> so the biggest map we would have is 512 bytes.   Also, the
> map is only really usefull when we have gaps to store and
> report.  As such, starting with minimal map of say 32 TSNs (bits)
> should be enough for normal low-loss operations.  We can grow
> the map by some multiple of 32 along with some extra room any
> time we receive the TSN which would put us outside of the map
> boundry.  As we close gaps, we can shift the map to rebase
> it on the latest TSN we've seen.  This saves 4088 bytes per
> association just in the map alone along savings from the now
> unnecessary structure members.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
