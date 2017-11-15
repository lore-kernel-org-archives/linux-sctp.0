From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Nov 2017 12:42:37 +0000
Subject: Re: [PATCHv2 net] sctp: do not free asoc when it is already dead in sctp_sendmsg
Message-Id: <20171115124237.GB10083@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <a374f3840d50382fa15a3e8909b38855aa133959.1510736154.git.lucien.xin@gmail.com>
In-Reply-To: <a374f3840d50382fa15a3e8909b38855aa133959.1510736154.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller@googlegroups.com

On Wed, Nov 15, 2017 at 04:55:54PM +0800, Xin Long wrote:
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
Acked-by: Neil Horman <nhorman@tuxdriver.com>

