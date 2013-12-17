From: David Miller <davem@davemloft.net>
Date: Tue, 17 Dec 2013 19:32:56 +0000
Subject: Re: [PATCH] sctp: Reorder 'struc association' members to reduce its size
Message-Id: <20131217.143256.233394040400199988.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AAA048.2040704@huawei.com>
In-Reply-To: <52AAA048.2040704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 13 Dec 2013 13:51:04 +0800

> Members of 'struct association' are not in appropriate order to
> reuse compiler added padding on 64bit architectures. In this patch
> we reorder those struct members and help reduce the size of the
> structure from 2776 bytes to 2720 bytes on 64 bit architectures.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thanks.
