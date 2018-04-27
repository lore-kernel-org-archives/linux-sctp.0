From: David Miller <davem@davemloft.net>
Date: Fri, 27 Apr 2018 17:35:51 +0000
Subject: Re: [PATCH net] sctp: clear the new asoc's stream outcnt in sctp_stream_update
Message-Id: <20180427.133551.2008316162996427868.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a1180e29789ab0aa339ae8b456a100520ffcdc5.1524727304.git.lucien.xin@gmail.com>
In-Reply-To: <7a1180e29789ab0aa339ae8b456a100520ffcdc5.1524727304.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Apr 2018 15:21:44 +0800

> When processing a duplicate cookie-echo chunk, sctp moves the new
> temp asoc's stream out/in into the old asoc, and later frees this
> new temp asoc.
> 
> But now after this move, the new temp asoc's stream->outcnt is not
> cleared while stream->out is set to NULL, which would cause a same
> crash as the one fixed in Commit 79d0895140e9 ("sctp: fix error
> path in sctp_stream_init") when freeing this asoc later.
> 
> This fix is to clear this outcnt in sctp_stream_update.
> 
> Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
