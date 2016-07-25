From: David Miller <davem@davemloft.net>
Date: Mon, 25 Jul 2016 18:22:53 +0000
Subject: Re: [PATCH net] sctp: fix BH handling on socket backlog
Message-Id: <20160725.112253.483808630563071321.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a19b6088999a30defbfce748bc178935156a18a3.1469244527.git.marcelo.leitner@gmail.com>
In-Reply-To: <a19b6088999a30defbfce748bc178935156a18a3.1469244527.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 23 Jul 2016 00:32:48 -0300

> Now that the backlog processing is called with BH enabled, we have to
> disable BH before taking the socket lock via bh_lock_sock() otherwise
> it may dead lock:
 ...
> Fixes: 860fbbc343bf ("sctp: prepare for socket backlog behavior change")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
