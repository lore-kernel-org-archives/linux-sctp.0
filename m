From: David Miller <davem@davemloft.net>
Date: Wed, 02 May 2018 15:16:55 +0000
Subject: Re: [PATCH net] sctp: fix the issue that the cookie-ack with auth can't get processed
Message-Id: <20180502.111655.1192203550420460498.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <aec2a2b5bff80a4d8eb6a9db96a36a92e429e574.1525239912.git.lucien.xin@gmail.com>
In-Reply-To: <aec2a2b5bff80a4d8eb6a9db96a36a92e429e574.1525239912.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  2 May 2018 13:45:12 +0800

> When auth is enabled for cookie-ack chunk, in sctp_inq_pop, sctp
> processes auth chunk first, then continues to the next chunk in
> this packet if chunk_end + chunk_hdr size < skb_tail_pointer().
> Otherwise, it will go to the next packet or discard this chunk.
> 
> However, it missed the fact that cookie-ack chunk's size is equal
> to chunk_hdr size, which couldn't match that check, and thus this
> chunk would not get processed.
> 
> This patch fixes it by changing the check to chunk_end + chunk_hdr
> size <= skb_tail_pointer().
> 
> Fixes: 26b87c788100 ("net: sctp: fix remote memory pressure from excessive queueing")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
