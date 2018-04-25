From: David Miller <davem@davemloft.net>
Date: Wed, 25 Apr 2018 18:12:28 +0000
Subject: Re: [PATCH net-next] sctp: remove the unused sctp_assoc_is_match function
Message-Id: <20180425.141228.1003896914050214765.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0acb8eaec9a5be9959d39bb5017d49bb31d0d5e5.1524649607.git.lucien.xin@gmail.com>
In-Reply-To: <0acb8eaec9a5be9959d39bb5017d49bb31d0d5e5.1524649607.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Apr 2018 17:46:47 +0800

> After Commit 4f0087812648 ("sctp: apply rhashtable api to send/recv
> path"), there's no place using sctp_assoc_is_match, so remove it.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
