From: David Miller <davem@davemloft.net>
Date: Mon, 12 Feb 2018 16:47:27 +0000
Subject: Re: [PATCH net] sctp: remove the useless check in sctp_renege_events
Message-Id: <20180212.114727.1546226581735499348.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <8db12ad85c54e5b56bc871e977bd71a1f6ea2e99.1518431484.git.lucien.xin@gmail.com>
In-Reply-To: <8db12ad85c54e5b56bc871e977bd71a1f6ea2e99.1518431484.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Feb 2018 18:31:24 +0800

> Remove the 'if (chunk)' check in sctp_renege_events for idata process,
> as all renege commands are generated in sctp_eat_data and it can't be
> NULL.
> 
> The same thing we already did for common data in sctp_ulpq_renege.
> 
> Fixes: 94014e8d871a ("sctp: implement renege_events for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
