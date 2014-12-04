From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 04 Dec 2014 13:41:48 +0000
Subject: Re: [PATCH net] net: sctp: use MAX_HEADER for headroom reserve in output path
Message-Id: <20141204134148.GC16249@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1417605238-9936-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1417605238-9936-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, robert@swiecki.net

On Wed, Dec 03, 2014 at 12:13:58PM +0100, Daniel Borkmann wrote:
> To accomodate for enough headroom for tunnels, use MAX_HEADER instead
> of LL_MAX_HEADER. Robert reported that he has hit after roughly 40hrs
> of trinity an skb_under_panic() via SCTP output path (see reference).
> I couldn't reproduce it from here, but not using MAX_HEADER as elsewhere
> in other protocols might be one possible cause for this.
> 
> In any case, it looks like accounting on chunks themself seems to look
> good as the skb already passed the SCTP output path and did not hit
> any skb_over_panic(). Given tunneling was enabled in his .config, the
> headroom would have been expanded by MAX_HEADER in this case.
> 
> Reported-by: Robert Święcki <robert@swiecki.net>
> Reference: https://lkml.org/lkml/2014/12/1/507
> Fixes: 594ccc14dfe4d ("[SCTP] Replace incorrect use of dev_alloc_skb with alloc_skb in sctp_packet_transmit().")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  net/sctp/output.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 42dffd4..fc5e45b 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -401,12 +401,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>  	sk = chunk->skb->sk;
>  
>  	/* Allocate the new skb.  */
> -	nskb = alloc_skb(packet->size + LL_MAX_HEADER, GFP_ATOMIC);
> +	nskb = alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
>  	if (!nskb)
>  		goto nomem;
>  
>  	/* Make sure the outbound skb has enough header room reserved. */
> -	skb_reserve(nskb, packet->overhead + LL_MAX_HEADER);
> +	skb_reserve(nskb, packet->overhead + MAX_HEADER);
>  
>  	/* Set the owning socket so that we know where to get the
>  	 * destination IP address.
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
