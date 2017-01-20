From: David Miller <davem@davemloft.net>
Date: Fri, 20 Jan 2017 16:52:37 +0000
Subject: Re: [PATCH][V2] net: sctp: fix array overrun read on sctp_timer_tbl
Message-Id: <20170120.115237.842023646146863523.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170120134542.21104-1-colin.king@canonical.com>
        <20170120.113117.1592305434267734738.davem@davemloft.net>
        <20170120164820.GA669@localhost.localdomain>
In-Reply-To: <20170120164820.GA669@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: colin.king@canonical.com, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Jan 2017 14:48:20 -0200

> Seems you applied it on net tree, but commit that introduced the issue
> (7b9438de0cd4) is still only on net-next.

That explains everything.

> I build-tested it here before acking, it worked, on top of
> 4567d686f5c6d955e57a3afa1741944c1e7f4033.
> 
> Colin, please respin the patch.. add the Fixes tag, fix the missing 'o'
> in my name on the changelog :-) and tag the patch as net-next tree too.

Indeed, thanks.
