From: David Miller <davem@davemloft.net>
Date: Thu, 10 May 2018 21:49:08 +0000
Subject: Re: [PATCH net] sctp: remove sctp_chunk_put from fail_mark err path in sctp_ulpevent_make_rcvmsg
Message-Id: <20180510.174908.2166045029697003189.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <e4d7cf118c028ed05c9005951e30babc8bb300eb.1525944853.git.lucien.xin@gmail.com>
In-Reply-To: <e4d7cf118c028ed05c9005951e30babc8bb300eb.1525944853.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 10 May 2018 17:34:13 +0800

> In Commit 1f45f78f8e51 ("sctp: allow GSO frags to access the chunk too"),
> it held the chunk in sctp_ulpevent_make_rcvmsg to access it safely later
> in recvmsg. However, it also added sctp_chunk_put in fail_mark err path,
> which is only triggered before holding the chunk.
> 
> syzbot reported a use-after-free crash happened on this err path, where
> it shouldn't call sctp_chunk_put.
> 
> This patch simply removes this call.
> 
> Fixes: 1f45f78f8e51 ("sctp: allow GSO frags to access the chunk too")
> Reported-by: syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
