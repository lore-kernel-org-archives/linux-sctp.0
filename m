From: David Miller <davem@davemloft.net>
Date: Thu, 12 Sep 2019 11:56:40 +0000
Subject: Re: [PATCH] sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
Message-Id: <20190912.135640.688251444357964226.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: christophe.jaillet@wanadoo.fr
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 11 Sep 2019 18:02:39 +0200

> The '.exit' functions from 'pernet_operations' structure should be marked
> as __net_exit, not __net_init.
> 
> Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied and queued up for -stable.
