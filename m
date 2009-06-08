From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 08 Jun 2009 17:00:49 +0000
Subject: Re: [PATCH 5/5] sunrpc/auth_gss: Call rcu_barrier() on module
Message-Id: <1244480449.5040.4.camel@heimdal.trondhjem.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090608130959.10052.54590.stgit@localhost>
	 <20090608131148.10052.39869.stgit@localhost>
	 <20090608162656.GF6961@linux.vnet.ibm.com>
In-Reply-To: <20090608162656.GF6961@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paulmck@linux.vnet.ibm.com
Cc: Jesper Dangaard Brouer <hawk-4UpuNZONu4c@public.gmane.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, oliver.hartkopp-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, wg-5Yr1BZd7O62+XT7JhA+gdA@public.gmane.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org

On Mon, 2009-06-08 at 09:26 -0700, Paul E. McKenney wrote:
> On Mon, Jun 08, 2009 at 03:11:48PM +0200, Jesper Dangaard Brouer wrote:
> > As the module uses rcu_call() we should make sure that all
> > rcu callback has been completed before removing the code.
> 
> Good improvement!!!  Assuming that gss_svc_shutdown() and
> rpcauth_unregister() prevent any future RCU callbacks to be registered,
> this patch will fix things up.
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> > ---
> > 
> >  net/sunrpc/auth_gss/auth_gss.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> > index e630b38..66d458f 100644
> > --- a/net/sunrpc/auth_gss/auth_gss.c
> > +++ b/net/sunrpc/auth_gss/auth_gss.c
> > @@ -1548,6 +1548,7 @@ static void __exit exit_rpcsec_gss(void)
> >  {
> >  	gss_svc_shutdown();
> >  	rpcauth_unregister(&authgss_ops);
> > +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
> >  }
> > 
> >  MODULE_LICENSE("GPL");
> > 

Hmm... If this is about ensuring that all the call_rcu() callbacks
complete before we remove the module, then don't we also need similar
barriers in net/sunrpc/sunrpc_syms.c:cleanup_sunrpc() and in
fs/nfs/inode.c:exit_nfs_fs()?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
