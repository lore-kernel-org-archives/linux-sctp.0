From: David Miller <davem@davemloft.net>
Date: Wed, 10 Jun 2009 08:11:55 +0000
Subject: Re: [PATCH 0/5] We must use rcu_barrier() on module unload
Message-Id: <20090610.011155.231596832.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090608130959.10052.54590.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hawk-4UpuNZONu4c@public.gmane.org
Cc: paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, oliver.hartkopp-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, wg-5Yr1BZd7O62+XT7JhA+gdA@public.gmane.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org

From: Jesper Dangaard Brouer <hawk@comx.dk>
Date: Mon, 08 Jun 2009 15:11:23 +0200

> If an unloadable module uses RCU callbacks, it need to use
> rcu_barrier() so that the module may be safely unloaded.
 ...
> The patchset is made on top of DaveM's net-next-2.6 tree (starting on
> top of commit a1c1db392090). As this is my usual development tree,
> even though this patchset is bugfixes. (Just tested it applied cleanly
> on Linus'es tree ...)

All 5 patches applied, thanks!
