From: David Miller <davem@davemloft.net>
Date: Thu, 12 Oct 2017 03:18:41 +0000
Subject: Re: [PATCH][next] sctp: make array sctp_sched_ops static
Message-Id: <20171011.201841.213739155323701188.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171011101757.18825-1-colin.king@canonical.com>
In-Reply-To: <20171011101757.18825-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: colin.king@canonical.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 11 Oct 2017 11:17:57 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The array sctp_sched_ops  is local to the source and
> does not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> symbol 'sctp_sched_ops' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
