From: David Miller <davem@davemloft.net>
Date: Tue, 09 Jul 2019 03:17:08 +0000
Subject: Re: [PATCH net-next 0/4] sctp: tidy up some ep and asoc feature flags
Message-Id: <20190708.201708.1951328081226207691.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  9 Jul 2019 00:57:03 +0800

> This patchset is to remove some unnecessary feature flags from
> sctp_assocation and move some others to the right places.

Since I'm trying to close up the net-next tree first thing tomorrow morning
I've taken the liberty of reviewing this the best that I can and it looks
good.

Series applied, thanks Xin.
