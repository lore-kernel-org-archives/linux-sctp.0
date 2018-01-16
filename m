From: David Miller <davem@davemloft.net>
Date: Tue, 16 Jan 2018 19:25:07 +0000
Subject: Re: [PATCH net] sctp: return error if the asoc has been peeled off in sctp_wait_for_sndbuf
Message-Id: <20180116.142507.1091619802487211287.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3c7ffecf19e5b08ed1df58e5359617e9513f77ef.1516006896.git.lucien.xin@gmail.com>
In-Reply-To: <3c7ffecf19e5b08ed1df58e5359617e9513f77ef.1516006896.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Jan 2018 17:01:36 +0800

> After commit cea0cc80a677 ("sctp: use the right sk after waking up from
> wait_buf sleep"), it may change to lock another sk if the asoc has been
> peeled off in sctp_wait_for_sndbuf.
> 
> However, the asoc's new sk could be already closed elsewhere, as it's in
> the sendmsg context of the old sk that can't avoid the new sk's closing.
> If the sk's last one refcnt is held by this asoc, later on after putting
> this asoc, the new sk will be freed, while under it's own lock.
> 
> This patch is to revert that commit, but fix the old issue by returning
> error under the old sk's lock.
> 
> Fixes: cea0cc80a677 ("sctp: use the right sk after waking up from wait_buf sleep")
> Reported-by: syzbot+ac6ea7baa4432811eb50@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
