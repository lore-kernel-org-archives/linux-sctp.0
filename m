From: David Miller <davem@davemloft.net>
Date: Fri, 26 Feb 2016 20:19:51 +0000
Subject: Re: [PATCH 0/4] Convert network timestamps to be y2038 safe
Message-Id: <20160226.151951.1085088134048947212.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1456384031-29244-1-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1456384031-29244-1-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: deepa.kernel@gmail.com
Cc: netdev@vger.kernel.org, y2038@lists.linaro.org, arnd@arndb.de, vyasevich@gmail.com, nhorman@tuxdriver.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, john.stultz@linaro.org, tglx@linutronix.de, linux-sctp@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Wed, 24 Feb 2016 23:07:07 -0800

> Introduction:
> 
> The series is aimed at transitioning network timestamps to being
> y2038 safe.
> All patches can be reviewed and merged independently, except for
> the [PATCH 2/4], which is dependent on the [PATCH 1/4].
> 
> Socket timestamps and ioctl calls will be handled separately.
> 
> Thanks to Arnd Bergmann for discussing solution options with me.
> 
> Solution:
> 
> Data type struct timespec is not y2038 safe.
> Replace timespec with struct timespec64 which is y2038 safe.

Please respin this, moving the helper into net/ipv4/af_inet.c as per
the feedback given.

Thanks.
