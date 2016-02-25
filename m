From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 25 Feb 2016 14:56:53 +0000
Subject: Re: [Y2038] [PATCH 4/4] net: sctp: Convert log timestamps to be y2038 safe
Message-Id: <3414163.AdCiyYLy4g@wuerfel>
List-Id: <linux-sctp.vger.kernel.org>
References: <1456384031-29244-1-git-send-email-deepa.kernel@gmail.com> <1456384031-29244-5-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1456384031-29244-5-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: y2038@lists.linaro.org
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>

On Wednesday 24 February 2016 23:07:11 Deepa Dinamani wrote:
> SCTP probe log timestamps use struct timespec which is
> not y2038 safe.
> Use struct timespec64 which is 2038 safe instead.
> 
> Use monotonic time instead of real time as only time
> differences are logged.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
