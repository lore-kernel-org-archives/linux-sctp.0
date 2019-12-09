From: David Miller <davem@davemloft.net>
Date: Mon, 09 Dec 2019 18:17:38 +0000
Subject: Re: [PATCH net] sctp: fully initialize v4 addr in some functions
Message-Id: <20191209.101738.1448001980997003591.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <dfabc15c8718ae26d93f4ed1b023baee81eb5c34.1575870354.git.lucien.xin@gmail.com>
In-Reply-To: <dfabc15c8718ae26d93f4ed1b023baee81eb5c34.1575870354.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Dec 2019 13:45:54 +0800

> Syzbot found a crash:
 ...
> The issue was caused by transport->ipaddr set with uninit addr param, which
> was passed by:
> 
>   sctp_transport_init net/sctp/transport.c:47 [inline]
>   sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
>   sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
>   sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]
> 
> where 'addr' is set by sctp_v4_from_addr_param(), and it doesn't initialize
> the padding of addr->v4.
> 
> Later when calling sctp_make_heartbeat(), hbinfo.daddr(=transport->ipaddr)
> will become the part of skb, and the issue occurs.
> 
> This patch is to fix it by initializing the padding of addr->v4 in
> sctp_v4_from_addr_param(), as well as other functions that do the similar
> thing, and these functions shouldn't trust that the caller initializes the
> memory, as Marcelo suggested.
> 
> Reported-by: syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
