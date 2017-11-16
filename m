From: David Miller <davem@davemloft.net>
Date: Thu, 16 Nov 2017 01:49:41 +0000
Subject: Re: [PATCHv2 net] sctp: do not free asoc when it is already dead in sctp_sendmsg
Message-Id: <20171116.104941.197762465622211317.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a374f3840d50382fa15a3e8909b38855aa133959.1510736154.git.lucien.xin@gmail.com>
In-Reply-To: <a374f3840d50382fa15a3e8909b38855aa133959.1510736154.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 15 Nov 2017 16:55:54 +0800

> Now in sctp_sendmsg sctp_wait_for_sndbuf could schedule out without
> holding sock sk. It means the current asoc can be freed elsewhere,
> like when receiving an abort packet.
> 
> If the asoc is just created in sctp_sendmsg and sctp_wait_for_sndbuf
> returns err, the asoc will be freed again due to new_asoc is not nil.
> An use-after-free issue would be triggered by this.
> 
> This patch is to fix it by setting new_asoc with nil if the asoc is
> already dead when cpu schedules back, so that it will not be freed
> again in sctp_sendmsg.
> 
> v1->v2:
>   set new_asoc as nil in sctp_sendmsg instead of sctp_wait_for_sndbuf.
> 
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
