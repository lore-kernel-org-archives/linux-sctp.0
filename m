From: David Miller <davem@davemloft.net>
Date: Fri, 13 Sep 2019 20:06:55 +0000
Subject: Re: [PATCH v2 net 0/3] fix memory leak for sctp_do_bind
Message-Id: <20190913.210655.1982553055937864765.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
        <20190912040219.67517-1-maowenan@huawei.com>
In-Reply-To: <20190912040219.67517-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: maowenan@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 12 Sep 2019 12:02:16 +0800

> First two patches are to do cleanup, remove redundant assignment,
> and change return type of sctp_get_port_local.
> Third patch is to fix memory leak for sctp_do_bind if failed
> to bind address.
> 
> ---
>  v2: add one patch to change return type of sctp_get_port_local.

Series applied with Fixes: tag removed from patch #1.

Thanks.
