From: David Miller <davem@davemloft.net>
Date: Mon, 27 Aug 2018 22:13:52 +0000
Subject: Re: [PATCH net] sctp: hold transport before accessing its asoc in sctp_transport_get_next
Message-Id: <20180827.151352.1790869499011600822.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <607dd2950d09fc83404d670a73099523087d4963.1535366311.git.lucien.xin@gmail.com>
In-Reply-To: <607dd2950d09fc83404d670a73099523087d4963.1535366311.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 27 Aug 2018 18:38:31 +0800

> As Marcelo noticed, in sctp_transport_get_next, it is iterating over
> transports but then also accessing the association directly, without
> checking any refcnts before that, which can cause an use-after-free
> Read.
> 
> So fix it by holding transport before accessing the association. With
> that, sctp_transport_hold calls can be removed in the later places.
> 
> Fixes: 626d16f50f39 ("sctp: export some apis or variables for sctp_diag and reuse some for proc")
> Reported-by: syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
