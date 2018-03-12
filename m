From: David Miller <davem@davemloft.net>
Date: Mon, 12 Mar 2018 15:19:03 +0000
Subject: Re: [PATCH net-next] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <20180312.111903.1047457001442236332.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyongjun1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 12 Mar 2018 12:16:04 +0000

> Return error code -EINVAL in the address len check error handling
> case since 'err' can be overwrite to 0 by 'err = sctp_verify_addr()'
> in the for loop.
> 
> Fixes: 2c0dbaa0c43d ("sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Xin, I do not want to have a bug fix like this blocked because of that
SCTP options merge nightmare which is of no fault of our own.
