From: David Miller <davem@davemloft.net>
Date: Fri, 06 Dec 2013 01:56:24 +0000
Subject: Re: [PATCH v2] sctp: disable max_burst when the max_burst is 0
Message-Id: <20131205.205624.1643659823573912858.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <529C2E01.3090005@huawei.com>
	<529EF6B7.7000501@huawei.com>
In-Reply-To: <529EF6B7.7000501@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wangweidong1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dborkman@redhat.com

From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 4 Dec 2013 17:32:39 +0800

> As Michael pointed out that when max_burst is 0, it just disable
> max_burst. It declared in rfc6458#section-8.1.24. so add the check
> in sctp_transport_burst_limited, when it 0, just do nothing.
> 
> Reviewed-by: Daniel Borkmann <dborkman@redhat.com>
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
> Suggested-by: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Applied, thank you.
