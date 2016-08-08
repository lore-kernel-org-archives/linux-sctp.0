From: David Miller <davem@davemloft.net>
Date: Mon, 08 Aug 2016 21:34:01 +0000
Subject: Re: [PATCH net] sctp: use event->chunk when it's valid
Message-Id: <20160808.143401.1489906176772169295.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b2a38bf9d9d9b9b10a3243149badd56fbb971c4e.1470550513.git.lucien.xin@gmail.com>
In-Reply-To: <b2a38bf9d9d9b9b10a3243149badd56fbb971c4e.1470550513.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  7 Aug 2016 14:15:13 +0800

> Commit 52253db924d1 ("sctp: also point GSO head_skb to the sk when
> it's available") used event->chunk->head_skb to get the head_skb in
> sctp_ulpevent_set_owner().
> 
> But at that moment, the event->chunk was NULL, as it cloned the skb
> in sctp_ulpevent_make_rcvmsg(). Therefore, that patch didn't really
> work.
> 
> This patch is to move the event->chunk initialization before calling
> sctp_ulpevent_receive_data() so that it uses event->chunk when it's
> valid.
> 
> Fixes: 52253db924d1 ("sctp: also point GSO head_skb to the sk when it's available")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you.
