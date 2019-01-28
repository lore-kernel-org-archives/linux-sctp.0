From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 28 Jan 2019 17:04:34 +0000
Subject: Re: [PATCH AUTOSEL 4.19 034/258] sctp: Fix SKB list traversal in sctp_intl_store_reasm().
Message-Id: <20190128170434.GA10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
 <20190128155924.51521-34-sashal@kernel.org>
In-Reply-To: <20190128155924.51521-34-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Mon, Jan 28, 2019 at 10:55:40AM -0500, Sasha Levin wrote:
> From: "David S. Miller" <davem@davemloft.net>
> 
> [ Upstream commit 348bbc25c40844c5efa083a3842c7f53d70a815e ]
> 
> To be fully correct, an iterator has an undefined value when something
> like skb_queue_walk() naturally terminates.
> 
> This will actually matter when SKB queues are converted over to
> list_head.
> 
> Formalize what this code ends up doing with the current
> implementation.

I don't think this patch is really needed for -stable without the SKB
queue convertion, but okay.

  Marcelo
