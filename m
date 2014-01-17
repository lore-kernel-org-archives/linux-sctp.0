From: David Miller <davem@davemloft.net>
Date: Fri, 17 Jan 2014 01:37:46 +0000
Subject: Re: [PATCH net-next] sctp: remove the unnecessary assignment
Message-Id: <20140116.173746.1014767500836972443.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52D7976F.7070708@huawei.com>
In-Reply-To: <52D7976F.7070708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: nhorman@tuxdriver.com, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 16 Jan 2014 16:25:19 +0800

> When go the right path, the status is 0, no need to assign it again.
> So just remove the assignment.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thank you.
