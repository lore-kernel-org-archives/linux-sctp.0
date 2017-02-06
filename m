From: David Miller <davem@davemloft.net>
Date: Mon, 06 Feb 2017 16:57:29 +0000
Subject: Re: [PATCH net-next] sctp: process fwd tsn chunk only when prsctp is enabled
Message-Id: <20170206.115729.1722855528495817146.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <16dcae6a3bff4b7e4c6d37bfa7dba217d5ca34b7.1486114626.git.lucien.xin@gmail.com>
In-Reply-To: <16dcae6a3bff4b7e4c6d37bfa7dba217d5ca34b7.1486114626.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri,  3 Feb 2017 17:37:06 +0800

> This patch is to check if asoc->peer.prsctp_capable is set before
> processing fwd tsn chunk, if not, it will return an ERROR to the
> peer, just as rfc3758 section 3.3.1 demands.
> 
> Reported-by: Julian Cordes <julian.cordes@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
