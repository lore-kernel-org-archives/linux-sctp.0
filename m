From: David Miller <davem@davemloft.net>
Date: Mon, 18 Dec 2017 18:22:21 +0000
Subject: Re: [PATCH net] sctp: add SCTP_CID_RECONF conversion in sctp_cname
Message-Id: <20171218.132221.1003373326582459249.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
In-Reply-To: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Dec 2017 14:13:17 +0800

> Whenever a new type of chunk is added, the corresp conversion in
> sctp_cname should be added. Otherwise, in some places, pr_debug
> will print it as "unknown chunk".
> 
> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
