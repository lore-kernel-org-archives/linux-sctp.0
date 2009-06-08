From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 16:05:22 +0000
Subject: Re: [PATCH 2/5] nfnetlink_queue: Use rcu_barrier() on module
Message-Id: <20090608160522.GC6961@linux.vnet.ibm.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090608130959.10052.54590.stgit@localhost> <20090608131133.10052.40836.stgit@localhost>
In-Reply-To: <20090608131133.10052.40836.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <hawk-4UpuNZONu4c@public.gmane.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, oliver.hartkopp-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, wg-5Yr1BZd7O62+XT7JhA+gdA@public.gmane.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:11:33PM +0200, Jesper Dangaard Brouer wrote:
> This module uses rcu_call() thus it should use rcu_barrier() on module unload.
> 
> Also fixed a trivial typo 'nfetlink' -> 'nfnetlink' in comment.

Assuming that netlink_unregister_notifier(), nfnetlink_subsys_unregister(),
and so on prevent any subsequent calls to call_rcu(), looks good!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> ---
> 
>  net/netfilter/nfnetlink_queue.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 8c86011..71daa09 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1,6 +1,6 @@
>  /*
>   * This is a module which is used for queueing packets and communicating with
> - * userspace via nfetlink.
> + * userspace via nfnetlink.
>   *
>   * (C) 2005 by Harald Welte <laforge@netfilter.org>
>   * (C) 2007 by Patrick McHardy <kaber@trash.net>
> @@ -932,6 +932,8 @@ static void __exit nfnetlink_queue_fini(void)
>  #endif
>  	nfnetlink_subsys_unregister(&nfqnl_subsys);
>  	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
> +
> +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
>  }
> 
>  MODULE_DESCRIPTION("netfilter packet queue handler");
> 
