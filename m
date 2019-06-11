From: David Miller <davem@davemloft.net>
Date: Tue, 11 Jun 2019 20:08:56 +0000
Subject: Re: [PATCH v3] [sctp] Free cookie before we memdup a new one
Message-Id: <20190611.130856.1857826051148231972.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190611192245.9110-1-nhorman@tuxdriver.com>
In-Reply-To: <20190611192245.9110-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com, marcelo.leitner@gmail.com, lucien.xin@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 11 Jun 2019 15:22:45 -0400

> v2->v3
> net->sctp
> also free peer_chunks

Neil this isn't the first time you're submitting sctp patches right? ;-)

Subject: "[PATCH v3 net] sctp: Free cookie before we memdup a new one"

It's "subsystem_prefix: " and I even stated this explicitly yesterday.
