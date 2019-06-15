From: David Miller <davem@davemloft.net>
Date: Sat, 15 Jun 2019 02:27:59 +0000
Subject: Re: [PATCH v5 net] sctp: Free cookie before we memdup a new one
Message-Id: <20190614.192759.352171429890636844.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190613103559.2603-1-nhorman@tuxdriver.com>
In-Reply-To: <20190613103559.2603-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com, marcelo.leitner@gmail.com, lucien.xin@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 13 Jun 2019 06:35:59 -0400

> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)
> 
> v2->v3
> net->sctp
> also free peer_chunks
> 
> v3->v4
> fix subject tags
> 
> v4->v5
> remove cut line
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com

Applied, thanks.
