From: Julian Anastasov <ja@ssi.bg>
Date: Tue, 31 Jan 2017 21:53:17 +0000
Subject: Re: [PATCHv2 RFC net-next 0/7] net: dst_confirm replacement
Message-Id: <alpine.LFD.2.11.1701312350110.2064@ja.home.ssi.bg>
List-Id: <linux-sctp.vger.kernel.org>
References: <1485613578-19973-1-git-send-email-ja@ssi.bg> <20170130.101339.2050288140097606206.davem@davemloft.net>
In-Reply-To: <20170130.101339.2050288140097606206.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yuehaibing@huawei.com


	Hello,

On Mon, 30 Jan 2017, David Miller wrote:

> From: Julian Anastasov <ja@ssi.bg>
> > 
> > 	So, the following solution is to avoid using
> > dst->pending_confirm.
> 
> For the most part this series looks good to me, nice work.

	OK, I'm posting v3 after removing the RFC tag from v2,
I just added the Acked-by tags.

Regards

--
Julian Anastasov <ja@ssi.bg>
