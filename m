From: David Miller <davem@davemloft.net>
Date: Mon, 12 Feb 2018 16:47:13 +0000
Subject: Re: [PATCH net] sctp: add SCTP_CID_I_DATA and SCTP_CID_I_FWD_TSN conversion in sctp_cname
Message-Id: <20180212.114713.1300025949093667584.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ca12376b0b3b73833878279f20183bf03128626.1518431391.git.lucien.xin@gmail.com>
In-Reply-To: <2ca12376b0b3b73833878279f20183bf03128626.1518431391.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Feb 2018 18:29:51 +0800

> After the support for SCTP_CID_I_DATA and SCTP_CID_I_FWD_TSN chunks,
> the corresp conversion in sctp_cname should also be added. Otherwise,
> in some places, pr_debug will print them as "unknown chunk".
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
