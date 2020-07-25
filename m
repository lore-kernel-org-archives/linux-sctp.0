From: David Miller <davem@davemloft.net>
Date: Sat, 25 Jul 2020 00:10:35 +0000
Subject: Re: [PATCH][V2] sctp: remove redundant initialization of variable status
Message-Id: <20200724.171035.1263967627297774729.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200724130919.18497-1-colin.king@canonical.com>
In-Reply-To: <20200724130919.18497-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: colin.king@canonical.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 24 Jul 2020 14:09:19 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable status is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.  Also put the variable declarations into
> reverse christmas tree order.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> V2: put variable declarations into reverse christmas tree order.

Applied to net-next, thanks.
