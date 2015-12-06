From: David Miller <davem@davemloft.net>
Date: Sun, 06 Dec 2015 18:26:03 +0000
Subject: Re: [PATCH net] sctp: only drop the reference on the datamsg after sending a msg
Message-Id: <20151206.132603.1391902857457071088.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b2b92ed429c3f617f5a22df8b232cf58ab7a0fb5.1449299967.git.lucien.xin@gmail.com>
In-Reply-To: <b2b92ed429c3f617f5a22df8b232cf58ab7a0fb5.1449299967.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevic@redhat.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  5 Dec 2015 15:19:27 +0800

> If the chunks are enqueued successfully but sctp_cmd_interpreter()
> return err to sctp_sendmsg() (mainly because of no mem), the chunks will
> get re-queued, but we are dropping the reference and freeing them.
> 
> The fix is to just drop the reference on the datamsg just as it had
> succeeded, as:
>  - if the chunks weren't queued, this is enough to get them freed.
>  - if they were queued, they will get freed when they finally get out or
>  discarded.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
