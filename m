From: David Miller <davem@davemloft.net>
Date: Sat, 30 Nov 2013 21:08:47 +0000
Subject: Re: [PATCH] sctp: check the rto_min and rto_max
Message-Id: <20131130.160847.361995350346508364.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <5299BCB8.6070409@huawei.com>
In-Reply-To: <5299BCB8.6070409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dingtianhong@huawei.com

From: wangweidong <wangweidong1@huawei.com>
Date: Sat, 30 Nov 2013 18:23:52 +0800

> rto_min should be smaller than rto_max while rto_max should be larger
> than rto_min. so just add the check.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Please fix your submission process such that your real full name
appears in the "From: " field of your patch emails, instead of
just "wangweidong", which is your username not your real full
name.

I'm not applying your patches until you correct this and submit
the patch properly, thanks.
