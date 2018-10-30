From: David Miller <davem@davemloft.net>
Date: Tue, 30 Oct 2018 03:51:43 +0000
Subject: Re: [PATCH net] sctp: check policy more carefully when getting pr status
Message-Id: <20181029.205143.1489562179173145610.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cadb9859cc2015b176433d4ac7bb1bc228f97574.1540825991.git.lucien.xin@gmail.com>
In-Reply-To: <cadb9859cc2015b176433d4ac7bb1bc228f97574.1540825991.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Oct 2018 23:13:11 +0800

> When getting pr_assocstatus and pr_streamstatus by sctp_getsockopt,
> it doesn't correctly process the case when policy is set with
> SCTP_PR_SCTP_ALL | SCTP_PR_SCTP_MASK. It even causes a
> slab-out-of-bounds in sctp_getsockopt_pr_streamstatus().
> 
> This patch fixes it by return -EINVAL for this case.
> 
> Fixes: 0ac1077e3a54 ("sctp: get pr_assoc and pr_stream all status with SCTP_PR_SCTP_ALL")
> Reported-by: syzbot+5da0d0a72a9e7d791748@syzkaller.appspotmail.com
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
