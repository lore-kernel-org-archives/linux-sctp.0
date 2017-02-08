From: Julian Anastasov <ja@ssi.bg>
Date: Wed, 08 Feb 2017 21:05:36 +0000
Subject: Re: [PATCHv4 net-next 0/7] net: dst_confirm replacement
Message-Id: <alpine.LFD.2.11.1702082245270.2608@ja.home.ssi.bg>
List-Id: <linux-sctp.vger.kernel.org>
References: <1486415657-14714-1-git-send-email-ja@ssi.bg> <20170207.131134.567606043153504044.davem@davemloft.net>
In-Reply-To: <20170207.131134.567606043153504044.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


	Hello,

On Tue, 7 Feb 2017, David Miller wrote:

> From: Julian Anastasov <ja@ssi.bg>
> Date: Mon,  6 Feb 2017 23:14:10 +0200
> 
> > - I failed to understand the CXGB* code, I see dst_confirm()
> > calls but I'm not sure dst_neigh_output() was called. For now
> > I just removed the dst->pending_confirm flag and left all
> > dst_confirm() calls there. Any better idea?
> 
> As I said, it is trying to confirm neighbours based upon traffic
> occurring in the chips TCP offload stack.  The 'cm' in "iwch_cm.c"
> means "connection manager".
> 
> We can probably get to the neigh that will end up being used
> since there should be a flow key somewhere that we can use to
> determine the nexthop address for neigh lookup.

	I was reluctant to add slow neigh lookup there,
I was not sure if there is a saved address somewhere, for
the all places that call dst_confirm.

> > - Now may be old function neigh_output() should be restored
> > instead of dst_neigh_output?
> 
> Please elaborate.

	As dst_neigh_output does not use the dst arg anymore,
my idea was to rename dst_neigh_output to neigh_output, i.e.
just like it was before commit 5110effee8fd ("net: Do delayed neigh 
confirmation."

Regards

--
Julian Anastasov <ja@ssi.bg>
