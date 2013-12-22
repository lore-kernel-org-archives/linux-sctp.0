From: David Miller <davem@davemloft.net>
Date: Sun, 22 Dec 2013 23:57:10 +0000
Subject: Re: [PATCH net-next v2] sctp: remove the never used 'return' and redundant 'break'
Message-Id: <20131222.185710.599956561344900588.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B168E0.1060108@huawei.com>
	<52B253C2.8070407@huawei.com>
In-Reply-To: <52B253C2.8070407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 19 Dec 2013 10:02:42 +0800

> In switch() had do return, and never use the 'return NULL'. The
> 'break' after return or goto has no effect. Remove it.
> 
> v2: make it more readable as suggested by Neil.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thanks.
