From: David Miller <davem@davemloft.net>
Date: Thu, 30 Mar 2017 18:08:56 +0000
Subject: Re: [PATCH net] sctp: alloc stream info when initializing asoc
Message-Id: <20170330.110856.2114381422765103895.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <06d5884ac36a3ad5f5bceaf0088aede14870088b.1490806853.git.lucien.xin@gmail.com>
In-Reply-To: <06d5884ac36a3ad5f5bceaf0088aede14870088b.1490806853.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 30 Mar 2017 01:00:53 +0800

> When sending a msg without asoc established, sctp will send INIT packet
> first and then enqueue chunks.
> 
> Before receiving INIT_ACK, stream info is not yet alloced. But enqueuing
> chunks needs to access stream info, like out stream state and out stream
> cnt.
> 
> This patch is to fix it by allocing out stream info when initializing an
> asoc, allocing in stream and re-allocing out stream when processing init.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
