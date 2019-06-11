From: David Miller <davem@davemloft.net>
Date: Tue, 11 Jun 2019 16:06:23 +0000
Subject: Re: [PATCH v2] [net] Free cookie before we memdup a new one
Message-Id: <20190611.090623.1410739893357351709.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190611112128.27057-1-nhorman@tuxdriver.com>
In-Reply-To: <20190611112128.27057-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 11 Jun 2019 07:21:28 -0400

> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> ---
> Change notes
> v1->v2
> update subsystem tag in subject (davem)

Subsystem tag is "sctp: " which still isn't there :-)
