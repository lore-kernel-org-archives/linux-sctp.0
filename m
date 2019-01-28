From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 28 Jan 2019 18:09:47 +0000
Subject: Re: [PATCH AUTOSEL 4.19 033/258] sctp: Fix SKB list traversal in sctp_intl_store_ordered().
Message-Id: <20190128180947.GB10665@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
 <20190128155924.51521-33-sashal@kernel.org>
In-Reply-To: <20190128155924.51521-33-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Mon, Jan 28, 2019 at 10:55:39AM -0500, Sasha Levin wrote:
> From: "David S. Miller" <davem@davemloft.net>
> 
> [ Upstream commit e15e067d0656625c77c52b4e5f0cfbf0c0c3583f ]
> 
> Same change as made to sctp_intl_store_reasm().
> 
> To be fully correct, an iterator has an undefined value when something
> like skb_queue_walk() naturally terminates.
> 
> This will actually matter when SKB queues are converted over to
> list_head.
> 
> Formalize what this code ends up doing with the current
> implementation.

Hi Sasha,

This one too then.

Thanks,
Marcelo
