From: David Miller <davem@davemloft.net>
Date: Thu, 18 Oct 2018 05:13:46 +0000
Subject: Re: [PATCH net] sctp: not free the new asoc when sctp_wait_for_connect returns err
Message-Id: <20181017.221346.66171710193579614.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <6ee31cce8c2e36a7e189de11c13c257e8c45b42f.1539716772.git.lucien.xin@gmail.com>
In-Reply-To: <6ee31cce8c2e36a7e189de11c13c257e8c45b42f.1539716772.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 17 Oct 2018 03:06:12 +0800

> When sctp_wait_for_connect is called to wait for connect ready
> for sp->strm_interleave in sctp_sendmsg_to_asoc, a panic could
> be triggered if cpu is scheduled out and the new asoc is freed
> elsewhere, as it will return err and later the asoc gets freed
> again in sctp_sendmsg.
 ...
> This is a similar issue with the one fixed in Commit ca3af4dd28cf
> ("sctp: do not free asoc when it is already dead in sctp_sendmsg").
> But this one can't be fixed by returning -ESRCH for the dead asoc
> in sctp_wait_for_connect, as it will break sctp_connect's return
> value to users.
> 
> This patch is to simply set err to -ESRCH before it returns to
> sctp_sendmsg when any err is returned by sctp_wait_for_connect
> for sp->strm_interleave, so that no asoc would be freed due to
> this.
> 
> When users see this error, they will know the packet hasn't been
> sent. And it also makes sense to not free asoc because waiting
> connect fails, like the second call for sctp_wait_for_connect in
> sctp_sendmsg_to_asoc.
> 
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
