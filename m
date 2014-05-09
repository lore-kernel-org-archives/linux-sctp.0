From: David Miller <davem@davemloft.net>
Date: Fri, 09 May 2014 20:41:43 +0000
Subject: Re: [net-next 0/2] sctp: fix kfree static array pointer in sctp_sysctl_net_unregister
Message-Id: <20140509.164143.1972373677615840350.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, dborkman@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 8 May 2014 20:55:00 +0800

> patch #1 revert the efb842c45("sctp: optimize the sctp_sysctl_net_register")
> patch #2 add a checking for sctp_sysctl_net_register

Series applied, thanks.
