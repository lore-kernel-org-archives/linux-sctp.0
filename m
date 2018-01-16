From: David Miller <davem@davemloft.net>
Date: Tue, 16 Jan 2018 19:20:57 +0000
Subject: Re: [PATCH net] sctp: reinit stream if stream outcnt has been change by sinit in sendmsg
Message-Id: <20180116.142057.1449511465809553791.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1330acc7e606c50a26e7f972eb9875da82ad8ce9.1516006879.git.lucien.xin@gmail.com>
In-Reply-To: <1330acc7e606c50a26e7f972eb9875da82ad8ce9.1516006879.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Jan 2018 17:01:19 +0800

> After introducing sctp_stream structure, sctp uses stream->outcnt as the
> out stream nums instead of c.sinit_num_ostreams.
> 
> However when users use sinit in cmsg, it only updates c.sinit_num_ostreams
> in sctp_sendmsg. At that moment, stream->outcnt is still using previous
> value. If it's value is not updated, the sinit_num_ostreams of sinit could
> not really work.
> 
> This patch is to fix it by updating stream->outcnt and reiniting stream
> if stream outcnt has been change by sinit in sendmsg.
> 
> Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
