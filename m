From: David Miller <davem@davemloft.net>
Date: Wed, 05 Apr 2017 14:20:18 +0000
Subject: Re: [PATCH net] sctp: get sock from transport in sctp_transport_update_pmtu
Message-Id: <20170405.072018.442632537243215600.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <c3e6d7cac1bc8d426be814c17c87dd9a7d4f3df9.1491284395.git.lucien.xin@gmail.com>
In-Reply-To: <c3e6d7cac1bc8d426be814c17c87dd9a7d4f3df9.1491284395.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  4 Apr 2017 13:39:55 +0800

> This patch is almost to revert commit 02f3d4ce9e81 ("sctp: Adjust PMTU
> updates to accomodate route invalidation."). As t->asoc can't be NULL
> in sctp_transport_update_pmtu, it could get sk from asoc, and no need
> to pass sk into that function.
> 
> It is also to remove some duplicated codes from that function.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
