From: David Miller <davem@davemloft.net>
Date: Tue, 04 Sep 2012 18:16:37 +0000
Subject: Re: [PATCH] sctp: use list_move_tail instead of list_del/list_add_tail
Message-Id: <20120904.141637.1002775415545971280.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPgLHd_w3-iAT66PW2i_jYyqmNrF-fKczcUEdBemPMvWX+fbOQ@mail.gmail.com>
In-Reply-To: <CAPgLHd_w3-iAT66PW2i_jYyqmNrF-fKczcUEdBemPMvWX+fbOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyj.lk@gmail.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, yongjun_wei@trendmicro.com.cn, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Tue, 4 Sep 2012 17:58:16 +0800

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to net-next, thank you.
