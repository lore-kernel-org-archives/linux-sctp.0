From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 29 Nov 2018 20:51:44 +0000
Subject: Re: [PATCHv2 net] sctp: hold transport before accessing its asoc in sctp_epaddr_lookup_transport
Message-Id: <20181129205144.GC14550@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
In-Reply-To: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Nov 29, 2018 at 02:44:07PM +0800, Xin Long wrote:
> Without holding transport to dereference its asoc, a use after
> free panic can be caused in sctp_epaddr_lookup_transport. Note
> that a sock lock can't protect these transports that belong to
> other socks.
> 
> A similar fix as Commit bab1be79a516 ("sctp: hold transport
> before accessing its asoc in sctp_transport_get_next") is
> needed to hold the transport before accessing its asoc in
> sctp_epaddr_lookup_transport.
> 
> Note that this extra atomic operation is on the datapath,
> but as rhlist keeps the lists to a small size, it won't
> see a noticeable performance hurt.
> 
> v1->v2:
>   - improve the changelog.
> 
> Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/input.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 5c36a99..ce7351c 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -967,9 +967,15 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
>  	list = rhltable_lookup(&sctp_transport_hashtable, &arg,
>  			       sctp_hash_params);
>  
> -	rhl_for_each_entry_rcu(t, tmp, list, node)
> -		if (ep = t->asoc->ep)
> +	rhl_for_each_entry_rcu(t, tmp, list, node) {
> +		if (!sctp_transport_hold(t))
> +			continue;
> +		if (ep = t->asoc->ep) {
> +			sctp_transport_put(t);
>  			return t;
> +		}
> +		sctp_transport_put(t);
> +	}
>  
>  	return NULL;
>  }

Wait a second, what if we just added an rcu_head to the association structure
and changed the kfree call in sctp_association_destroy to a kfree_rcu call
instead?  That would force the actual freeing of the association to pass through
a grace period, during which any in flight list traversal in
sctp_epaddr_lookup_transport could complete safely.  Its another two pointers
worth of space in the association, but I think that would be a worthwhile
tradeoff for not having to do N atomic adds/puts every time you wanted to
receive or send a frame.

Neil

> -- 
> 2.1.0
> 
> 
