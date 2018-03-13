From: David Miller <davem@davemloft.net>
Date: Tue, 13 Mar 2018 14:45:31 +0000
Subject: Re: [PATCH net-next v2] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <20180313.104531.1477288497157051834.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
        <1520910210-147500-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1520910210-147500-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyongjun1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 13 Mar 2018 03:03:30 +0000

> Return error code -EINVAL in the address len check error handling
> case since 'err' can be overwrite to 0 by 'err = sctp_verify_addr()'
> in the for loop.
> 
> Fixes: 2c0dbaa0c43d ("sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
> v1 -> v2: remove the 'err' initialization

Applied, thank you.
