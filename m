From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 14 Aug 2019 03:53:32 +0000
Subject: Re: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Message-Id: <20190813205332.60b50d8b@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhengbin <zhengbin13@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, yi.zhang@huawei.com

On Tue, 13 Aug 2019 22:05:50 +0800, zhengbin wrote:
> If the stream outq is not empty, need to kfree nstr_list.
> 
> Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Applied, thank you!
