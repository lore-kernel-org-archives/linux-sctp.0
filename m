From: David Miller <davem@davemloft.net>
Date: Wed, 15 Jun 2016 06:46:00 +0000
Subject: Re: [PATCH -next] sctp: fix error return code in sctp_init()
Message-Id: <20160614.234600.2262103276628303309.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyj_lk@163.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, yongjun_wei@trendmicro.com.cn, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: weiyj_lk@163.com
Date: Mon, 13 Jun 2016 23:08:26 +0800

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied.
