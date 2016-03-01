From: David Miller <davem@davemloft.net>
Date: Tue, 01 Mar 2016 22:19:03 +0000
Subject: Re: [PATCH v2 0/3] Convert network timestamps to be y2038 safe
Message-Id: <20160301.171903.834892722970175631.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1456561938-7653-1-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1456561938-7653-1-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: deepa.kernel@gmail.com
Cc: netdev@vger.kernel.org, y2038@lists.linaro.org, arnd@arndb.de, vyasevich@gmail.com, nhorman@tuxdriver.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-sctp@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat, 27 Feb 2016 00:32:14 -0800

> Introduction:
> 
> The series is aimed at transitioning network timestamps to being
> y2038 safe.
> All patches can be reviewed and merged independently.
> 
> Socket timestamps and ioctl calls will be handled separately.
> 
> Thanks to Arnd Bergmann for discussing solution options with me.
> 
> Solution:
> 
> Data type struct timespec is not y2038 safe.
> Replace timespec with struct timespec64 which is y2038 safe.
> 
> Changes v1 -> v2: 
>   Move and rename inet_current_time() as discussed
>   Squash patches 1 and 2
>   Reword commit text for patch 2/3
>   Carry over review tags

Series applied to net-next, thanks.
