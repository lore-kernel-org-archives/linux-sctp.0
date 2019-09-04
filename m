From: David Miller <davem@davemloft.net>
Date: Wed, 04 Sep 2019 22:30:25 +0000
Subject: Re: [PATCH net] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Message-Id: <20190904.153025.189079402256558885.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
In-Reply-To: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  2 Sep 2019 23:24:21 +0800

> Transport should use its own pf_retrans to do the error_count
> check, instead of asoc's. Otherwise, it's meaningless to make
> pf_retrans per transport.
> 
> Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
