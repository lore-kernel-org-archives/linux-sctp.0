From: David Miller <davem@davemloft.net>
Date: Tue, 26 Jul 2016 00:44:51 +0000
Subject: Re: [PATCH] net/sctp: terminate rhashtable walk correctly
Message-Id: <20160725.174451.328776654071356819.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1469259755-18079-1-git-send-email-vegard.nossum@oracle.com>
In-Reply-To: <1469259755-18079-1-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vegard.nossum@oracle.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, lucien.xin@gmail.com, herbert@gondor.apana.org.au, stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>
Date: Sat, 23 Jul 2016 09:42:35 +0200

> I was seeing a lot of these:
 ...
> Apparently we always need to call rhashtable_walk_stop(), even when
> rhashtable_walk_start() fails:
> 
>  * rhashtable_walk_start - Start a hash table walk
>  * @iter:       Hash table iterator
>  *
>  * Start a hash table walk.  Note that we take the RCU lock in all
>  * cases including when we return an error.  So you must always call
>  * rhashtable_walk_stop to clean up.
> 
> otherwise we never call rcu_read_unlock() and we get the splat above.
> 
> See-also: 53fa1036 ("sctp: fix some rhashtable functions using in sctp proc/diag")
> See-also: f2dba9c6 ("rhashtable: Introduce rhashtable_walk_*")
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

Applied and queued up for -stable, thanks.
