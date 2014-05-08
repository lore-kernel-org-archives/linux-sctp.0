From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 08 May 2014 13:45:04 +0000
Subject: Re: [net-next 0/2] sctp: fix kfree static array pointer in sctp_sysctl_net_unregister
Message-Id: <20140508134504.GF9696@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, dborkman@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Thu, May 08, 2014 at 08:55:00PM +0800, Wang Weidong wrote:
> patch #1 revert the efb842c45("sctp: optimize the sctp_sysctl_net_register")
> patch #2 add a checking for sctp_sysctl_net_register
> 
> Wang Weidong (2):
>   Revert "sctp: optimize the sctp_sysctl_net_register"
>   sctp: add a checking for sctp_sysctl_net_register
> 
>  net/sctp/sysctl.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> -- 
> 1.7.12
> 
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
