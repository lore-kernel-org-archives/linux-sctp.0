From: David Miller <davem@davemloft.net>
Date: Wed, 26 Oct 2016 21:32:48 +0000
Subject: Re: [PATCH net] sctp: fix the panic caused by route update
Message-Id: <20161026.173248.247683142442678932.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a0659fd9a23fc95fe9a586be4b57c8032c8a6060.1477242069.git.lucien.xin@gmail.com>
In-Reply-To: <a0659fd9a23fc95fe9a586be4b57c8032c8a6060.1477242069.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 24 Oct 2016 01:01:09 +0800

> Commit 7303a1475008 ("sctp: identify chunks that need to be fragmented
> at IP level") made the chunk be fragmented at IP level in the next round
> if it's size exceed PMTU.
> 
> But there still is another case, PMTU can be updated if transport's dst
> expires and transport's pmtu_pending is set in sctp_packet_transmit. If
> the new PMTU is less than the chunk, the same issue with that commit can
> be triggered.
> 
> So we should drop this packet and let it retransmit in another round
> where it would be fragmented at IP level.
> 
> This patch is to fix it by checking the chunk size after PMTU may be
> updated and dropping this packet if it's size exceed PMTU.
> 
> Fixes: 90017accff61 ("sctp: Add GSO support")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, and queued up for -stable, thanks!
