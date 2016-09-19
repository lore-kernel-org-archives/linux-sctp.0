From: David Miller <davem@davemloft.net>
Date: Mon, 19 Sep 2016 05:34:34 +0000
Subject: Re: [PATCH resend] sctp: Remove some redundant code
Message-Id: <20160919.013434.1910609314182367829.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1474059935-17343-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1474059935-17343-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: christophe.jaillet@wanadoo.fr
Cc: marcelo.leitner@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Fri, 16 Sep 2016 23:05:35 +0200

> In commit 311b21774f13 ("sctp: simplify sk_receive_queue locking"), a call
> to 'skb_queue_splice_tail_init()' has been made explicit. Previously it was
> hidden in 'sctp_skb_list_tail()'
> 
> Now, the code around it looks redundant. The '_init()' part of
> 'skb_queue_splice_tail_init()' should already do the same.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied to net-next.
