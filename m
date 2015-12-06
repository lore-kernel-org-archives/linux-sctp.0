From: David Miller <davem@davemloft.net>
Date: Sun, 06 Dec 2015 18:25:50 +0000
Subject: Re: [PATCH net] sctp: hold the chunks only after the chunk is enqueued in outq
Message-Id: <20151206.132550.1712594759452545432.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b2131d0e9ac5a34aea93d6770fcf68c4496d1d7d.1449299717.git.lucien.xin@gmail.com>
In-Reply-To: <b2131d0e9ac5a34aea93d6770fcf68c4496d1d7d.1449299717.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevic@redhat.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  5 Dec 2015 15:15:17 +0800

> When a msg is sent, sctp will hold the chunks of this msg and then try
> to enqueue them. But if the chunks are not enqueued in sctp_outq_tail()
> because of the invalid state, sctp_cmd_interpreter() may still return
> success to sctp_sendmsg() after calling sctp_outq_flush(), these chunks
> will become orphans and will leak.
> 
> So we fix them by moving sctp_chunk_hold() to sctp_outq_tail(), where we
> are sure that the chunk is going to get queued.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
