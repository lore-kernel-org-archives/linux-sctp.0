From: David Miller <davem@davemloft.net>
Date: Sun, 17 Jul 2016 05:02:30 +0000
Subject: Re: [PATCH net-next] sctp: recvmsg should be able to run even if sock is in closing state
Message-Id: <20160716.220230.1568654523682522363.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0250eb38e3e6f219ac353fa64dc8438d91740a31.1468609937.git.marcelo.leitner@gmail.com>
In-Reply-To: <0250eb38e3e6f219ac353fa64dc8438d91740a31.1468609937.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 15 Jul 2016 16:38:19 -0300

> Commit d46e416c11c8 missed to update some other places which checked for
> the socket being TCP-style AND Established state, as Closing state has
> some overlapping with the previous understanding of Established.
> 
> Without this fix, one of the effects is that some already queued rx
> messages may not be readable anymore depending on how the association
> teared down, and sending may also not be possible if peer initiated the
> shutdown.
> 
> Also merge two if() blocks into one condition on sctp_sendmsg().
> 
> Cc: Xin Long <lucien.xin@gmail.com>
> Fixes: d46e416c11c8 ("sctp: sctp should change socket state when shutdown is received")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
