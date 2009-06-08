From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 16:26:56 +0000
Subject: Re: [PATCH 5/5] sunrpc/auth_gss: Call rcu_barrier() on module
Message-Id: <20090608162656.GF6961@linux.vnet.ibm.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090608130959.10052.54590.stgit@localhost> <20090608131148.10052.39869.stgit@localhost>
In-Reply-To: <20090608131148.10052.39869.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <hawk@comx.dk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de, wg@grandegger.com, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:11:48PM +0200, Jesper Dangaard Brouer wrote:
> As the module uses rcu_call() we should make sure that all
> rcu callback has been completed before removing the code.

Good improvement!!!  Assuming that gss_svc_shutdown() and
rpcauth_unregister() prevent any future RCU callbacks to be registered,
this patch will fix things up.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> ---
> 
>  net/sunrpc/auth_gss/auth_gss.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index e630b38..66d458f 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -1548,6 +1548,7 @@ static void __exit exit_rpcsec_gss(void)
>  {
>  	gss_svc_shutdown();
>  	rpcauth_unregister(&authgss_ops);
> +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
>  }
> 
>  MODULE_LICENSE("GPL");
> 
