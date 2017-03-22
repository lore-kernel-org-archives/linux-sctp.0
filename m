From: David Miller <davem@davemloft.net>
Date: Wed, 22 Mar 2017 17:58:03 +0000
Subject: Re: [PATCH net] sctp: declare struct sctp_stream before using it
Message-Id: <20170322.105803.1230372240078516082.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1a16b414118d0876373774654d86e2a2a936b9d1.1490003187.git.lucien.xin@gmail.com>
In-Reply-To: <1a16b414118d0876373774654d86e2a2a936b9d1.1490003187.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 20 Mar 2017 17:46:27 +0800

> sctp_stream_free uses struct sctp_stream as a param, but struct sctp_stream
> is defined after it's declaration.
> 
> This patch is to declare struct sctp_stream before sctp_stream_free.
> 
> Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
