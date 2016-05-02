From: David Miller <davem@davemloft.net>
Date: Mon, 02 May 2016 01:06:28 +0000
Subject: Re: [PATCH] sctp: signal sk_data_ready earlier on data chunks reception
Message-Id: <20160501.210628.858260753518974978.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <271eaec3c8fad125a48b5acce192dd1080c26528.1461949899.git.marcelo.leitner@gmail.com>
In-Reply-To: <271eaec3c8fad125a48b5acce192dd1080c26528.1461949899.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Apr 2016 14:17:08 -0300

> Dave Miller pointed out that fb586f25300f ("sctp: delay calls to
> sk_data_ready() as much as possible") may insert latency specially if
> the receiving application is running on another CPU and that it would be
> better if we signalled as early as possible.
> 
> This patch thus basically inverts the logic on fb586f25300f and signals
> it as early as possible, similar to what we had before.
> 
> Fixes: fb586f25300f ("sctp: delay calls to sk_data_ready() as much as possible")
> Reported-by: Dave Miller <davem@davemloft.net>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thanks Marcelo.
