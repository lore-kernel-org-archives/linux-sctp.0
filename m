From: David Miller <davem@davemloft.net>
Date: Wed, 11 Dec 2013 20:39:59 +0000
Subject: Re: [PATCH net-next] sctp: remove redundant null check on asoc
Message-Id: <20131211.153959.2037422735738904875.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52A82566.1050601@huawei.com>
In-Reply-To: <52A82566.1050601@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 11 Dec 2013 16:42:14 +0800

> In sctp_err_lookup, goto out while the asoc is not NULL, so remove the
> check NULL. Also, in sctp_err_finish which called by sctp_v4_err and
> sctp_v6_err, they pass asoc to sctp_err_finish while the asoc is not
> NULL, so remove the check.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thanks.
