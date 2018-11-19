From: David Miller <davem@davemloft.net>
Date: Mon, 19 Nov 2018 20:44:10 +0000
Subject: Re: [PATCH net] Revert "sctp: remove sctp_transport_pmtu_check"
Message-Id: <20181119.124410.2142300768746731115.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <722a49900dadb13e3a97a63d54561418db28e1cc.1542528887.git.lucien.xin@gmail.com>
In-Reply-To: <722a49900dadb13e3a97a63d54561418db28e1cc.1542528887.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 16:14:47 +0800

> This reverts commit 22d7be267eaa8114dcc28d66c1c347f667d7878a.
> 
> The dst's mtu in transport can be updated by a non sctp place like
> in xfrm where the MTU information didn't get synced between asoc,
> transport and dst, so it is still needed to do the pmtu check
> in sctp_packet_config.

Applied and queued up for -stable.

Please provide a proper signoff for reverts in the future.

Thanks.
