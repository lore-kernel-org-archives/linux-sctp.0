From: David Miller <davem@davemloft.net>
Date: Wed, 08 Oct 2008 21:19:14 +0000
Subject: Re: [PATCH net-next 2/2] sctp: shrink sctp_tsnmap some more by
Message-Id: <20081008.141914.109425275.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223497670-519-1-git-send-email-vladislav.yasevich@hp.com>
	<1223497670-519-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223497670-519-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  8 Oct 2008 16:27:50 -0400

> The gabs array in the sctp_tsnmap structure is only used
> in one place, sctp_make_sack().  As such, carrying the
> array around in the sctp_tsnmap and thus directly in
> the sctp_association is rather pointless since most
> of the time it's just taking up space.  Now, let
> sctp_make_sack create and populate it and then throw
> it away when it's done.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
