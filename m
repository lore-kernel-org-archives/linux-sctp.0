From: David Miller <davem@davemloft.net>
Date: Tue, 07 Feb 2017 17:55:54 +0000
Subject: Re: [PATCH net] sctp: avoid BUG_ON on sctp_wait_for_sndbuf
Message-Id: <20170207.125554.925905416124561370.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <90df61dca0e882ccc175bcec200b341b171b7406.1486411622.git.marcelo.leitner@gmail.com>
In-Reply-To: <90df61dca0e882ccc175bcec200b341b171b7406.1486411622.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, alex.popov@linux.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon,  6 Feb 2017 18:10:31 -0200

> Alexander Popov reported that an application may trigger a BUG_ON in
> sctp_wait_for_sndbuf if the socket tx buffer is full, a thread is
> waiting on it to queue more data and meanwhile another thread peels off
> the association being used by the first thread.
> 
> This patch replaces the BUG_ON call with a proper error handling. It
> will return -EPIPE to the original sendmsg call, similarly to what would
> have been done if the association wasn't found in the first place.
> 
> Acked-by: Alexander Popov <alex.popov@linux.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> Please consider this to -stable. Thanks

Applied and queued up for -stable, thanks a lot.
