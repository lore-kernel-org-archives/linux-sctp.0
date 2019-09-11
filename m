From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Sep 2019 16:23:59 +0000
Subject: Re: [PATCH] sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
Message-Id: <20190911162359.GJ3431@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Sep 11, 2019 at 06:02:39PM +0200, Christophe JAILLET wrote:
> The '.exit' functions from 'pernet_operations' structure should be marked
> as __net_exit, not __net_init.
> 
> Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
