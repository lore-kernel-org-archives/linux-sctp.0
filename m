From: Marcelo <marcelo.leitner@gmail.com>
Date: Thu, 15 Sep 2016 17:34:28 +0000
Subject: Re: [PATCH] sctp: Remove some redundant code
Message-Id: <20160915173428.GA3200@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1472981893-8608-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1472981893-8608-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sun, Sep 04, 2016 at 11:38:13AM +0200, Christophe JAILLET wrote:
> In commit 311b21774f13 ("sctp: simplify sk_receive_queue locking"), a call
> to 'skb_queue_splice_tail_init()' has been made explicit. Previously it was
> hidden in 'sctp_skb_list_tail()'
> 
> Now, the code around it looks redundant. The '_init()' part of
> 'skb_queue_splice_tail_init()' should alreday do the same.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

I just noticed you didn't include netdev@ in the destinations.

Is your patch going to be tracked somewhere else? It's not showing up in
http://patchwork.ozlabs.org/project/netdev/list/?submitterf309&state=*&q=&archive=&delegate

