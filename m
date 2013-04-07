From: David Miller <davem@davemloft.net>
Date: Sun, 07 Apr 2013 21:04:39 +0000
Subject: Re: [PATCH -next] sctp: fix error return code in __sctp_connect()
Message-Id: <20130407.170439.70609816272776228.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPgLHd-X5Qw64BnaSMr2ny6==jXGpRAYC7_1MGhP2v_GcVeApQ@mail.gmail.com>
In-Reply-To: <CAPgLHd-X5Qw64BnaSMr2ny6==jXGpRAYC7_1MGhP2v_GcVeApQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyj.lk@gmail.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, nhorman@tuxdriver.com, yongjun_wei@trendmicro.com.cn, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Wed, 3 Apr 2013 21:02:28 +0800

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied.
