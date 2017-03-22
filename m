From: David Miller <davem@davemloft.net>
Date: Wed, 22 Mar 2017 01:32:05 +0000
Subject: Re: [PATCH net] sctp: define dst_pending_confirm as a bit in sctp_transport
Message-Id: <20170321.183205.928220300578692007.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b4390881b14adce583817529e5d58599acb5a8ee.1489836443.git.lucien.xin@gmail.com>
In-Reply-To: <b4390881b14adce583817529e5d58599acb5a8ee.1489836443.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, ja@ssi.bg

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Mar 2017 19:27:23 +0800

> As tp->dst_pending_confirm's value can only be set 0 or 1, this
> patch is to change to define it as a bit instead of __u32.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
