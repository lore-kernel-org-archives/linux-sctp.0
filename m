From: David Miller <davem@davemloft.net>
Date: Thu, 13 Oct 2016 13:44:50 +0000
Subject: Re: [PATCH net-next] sctp: reuse sent_count to avoid retransmitted chunks for RTT measurements
Message-Id: <20161013.094450.2198759604771922325.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b68194a4735a1ea5a652c13540df5d68e3c4b305.1475897765.git.lucien.xin@gmail.com>
In-Reply-To: <b68194a4735a1ea5a652c13540df5d68e3c4b305.1475897765.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  8 Oct 2016 11:36:05 +0800

> Now sctp uses chunk->resent to record if a chunk is retransmitted, for
> RTT measurements with retransmitted DATA chunks. chunk->sent_count was
> introduced to record how many times one chunk has been sent for prsctp
> RTX policy before. We actually can know if one chunk is retransmitted
> by checking chunk->sent_count is greater than 1.
> 
> This patch is to remove resent from sctp_chunk and reuse sent_count
> to avoid retransmitted chunks for RTT measurements.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
