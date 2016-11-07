From: David Miller <davem@davemloft.net>
Date: Mon, 07 Nov 2016 18:19:25 +0000
Subject: Re: [PATCH net] sctp: assign assoc_id earlier in __sctp_connect
Message-Id: <20161107.131925.1448895624986454134.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <9df38dcd0323ad92386eb6851a60dc128dd00b4e.1478199530.git.marcelo.leitner@gmail.com>
In-Reply-To: <9df38dcd0323ad92386eb6851a60dc128dd00b4e.1478199530.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com, kcc@google.com, glider@google.com, edumazet@google.com, dvyukov@google.com, andreyknvl@google.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu,  3 Nov 2016 17:03:41 -0200

> sctp_wait_for_connect() currently already holds the asoc to keep it
> alive during the sleep, in case another thread release it. But Andrey
> Konovalov and Dmitry Vyukov reported an use-after-free in such
> situation.
> 
> Problem is that __sctp_connect() doesn't get a ref on the asoc and will
> do a read on the asoc after calling sctp_wait_for_connect(), but by then
> another thread may have closed it and the _put on sctp_wait_for_connect
> will actually release it, causing the use-after-free.
> 
> Fix is, instead of doing the read after waiting for the connect, do it
> before so, and avoid this issue as the socket is still locked by then.
> There should be no issue on returning the asoc id in case of failure as
> the application shouldn't trust on that number in such situations
> anyway.
> 
> This issue doesn't exist in sctp_sendmsg() path.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
