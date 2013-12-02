From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 02 Dec 2013 01:33:26 +0000
Subject: Re: [PATCH] sctp: check the rto_min and rto_max
Message-Id: <529BE366.2060504@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5299BCB8.6070409@huawei.com> <20131130.160847.361995350346508364.davem@davemloft.net>
In-Reply-To: <20131130.160847.361995350346508364.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dingtianhong@huawei.com

On 2013/12/1 5:08, David Miller wrote:
> From: wangweidong <wangweidong1@huawei.com>
> Date: Sat, 30 Nov 2013 18:23:52 +0800
> 
>> rto_min should be smaller than rto_max while rto_max should be larger
>> than rto_min. so just add the check.
>>
>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> 
> Please fix your submission process such that your real full name
> appears in the "From: " field of your patch emails, instead of
> just "wangweidong", which is your username not your real full
> name.
> 
> I'm not applying your patches until you correct this and submit
> the patch properly, thanks.
> 

Ok, I will fix it in v2.
Thanks.

> 


