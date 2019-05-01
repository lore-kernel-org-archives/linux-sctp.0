From: David Miller <davem@davemloft.net>
Date: Wed, 01 May 2019 13:19:48 +0000
Subject: Re: [PATCH net] sctp: avoid running the sctp state machine recursively
Message-Id: <20190501.091948.243588960568894414.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
In-Reply-To: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Apr 2019 14:16:19 +0800

> Ying triggered a call trace when doing an asconf testing:
 ...
> As it shows, the first sctp_do_sm() running under atomic context (NET_RX
> softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
> and this flag is supposed to be used in non-atomic context only. Besides,
> sctp_do_sm() was called recursively, which is not expected.
> 
> Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
> oops when sending queued ASCONF chunks") by introducing a new command
> SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
> used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
> be called in this command again.
> 
> To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
> not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
> sctp_do_sm() directly.
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
