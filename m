From: David Miller <davem@davemloft.net>
Date: Wed, 28 Dec 2016 19:26:43 +0000
Subject: Re: [PATCH net-next] sctp: add pr_debug for tracking asocs not found
Message-Id: <20161228.142643.301838823990974094.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2e7482596bbf75efb56e313e33179f9e1c0e6996.1482924698.git.marcelo.leitner@gmail.com>
In-Reply-To: <2e7482596bbf75efb56e313e33179f9e1c0e6996.1482924698.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 28 Dec 2016 09:51:56 -0200

> This pr_debug may help identify why the system is generating some
> Aborts. It's not something a sysadmin would be expected to use.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
