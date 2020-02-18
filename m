From: David Miller <davem@davemloft.net>
Date: Tue, 18 Feb 2020 05:57:15 +0000
Subject: Re: [PATCHv2 net] sctp: move the format error check out of __sctp_sf_do_9_1_abort
Message-Id: <20200217.215715.632639629013006126.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
In-Reply-To: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, liuhangbin@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 18 Feb 2020 12:07:53 +0800

> When T2 timer is to be stopped, the asoc should also be deleted,
> otherwise, there will be no chance to call sctp_association_free
> and the asoc could last in memory forever.
> 
> However, in sctp_sf_shutdown_sent_abort(), after adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer, it may return error due to the
> format error from __sctp_sf_do_9_1_abort() and miss adding
> SCTP_CMD_ASSOC_FAILED where the asoc will be deleted.
> 
> This patch is to fix it by moving the format error check out of
> __sctp_sf_do_9_1_abort(), and do it before adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer.
> 
> Thanks Hangbin for reporting this issue by the fuzz testing.
> 
> v1->v2:
>   - improve the comment in the code as Marcelo's suggestion.
> 
> Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
