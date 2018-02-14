From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Feb 2018 13:00:43 +0000
Subject: Re: [PATCH 3/3] docs: segmentation-offloads.txt: add SCTP info
Message-Id: <20180214130043.GA4625@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180214070533.28377-1-dja@axtens.net>
 <20180214070533.28377-4-dja@axtens.net>
In-Reply-To: <20180214070533.28377-4-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Axtens <dja@axtens.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Wed, Feb 14, 2018 at 06:05:33PM +1100, Daniel Axtens wrote:
> Most of this is extracted from 90017accff61 ("sctp: Add GSO support"),
> with some extra text about GSO_BY_FRAGS and the need to check for it.
> 
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  Documentation/networking/segmentation-offloads.txt | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/networking/segmentation-offloads.txt b/Documentation/networking/segmentation-offloads.txt
> index b247471a183c..d47480b61ac6 100644
> --- a/Documentation/networking/segmentation-offloads.txt
> +++ b/Documentation/networking/segmentation-offloads.txt
> @@ -13,6 +13,7 @@ The following technologies are described:
>   * Generic Segmentation Offload - GSO
>   * Generic Receive Offload - GRO
>   * Partial Generic Segmentation Offload - GSO_PARTIAL
> + * SCTP accelleration with GSO - GSO_BY_FRAGS
>  
>  TCP Segmentation Offload
>  ============
> @@ -132,3 +133,28 @@ values for if the header was simply duplicated.  The one exception to this
>  is the outer IPv4 ID field.  It is up to the device drivers to guarantee
>  that the IPv4 ID field is incremented in the case that a given header does
>  not have the DF bit set.
> +
> +SCTP accelleration with GSO
> +=============> +
> +SCTP - despite the lack of hardware support - can still take advantage of
> +GSO to pass one large packet through the network stack, rather than
> +multiple small packets.
> +
> +This requires a different approach to other offloads, as SCTP packets
> +cannot be just segmented to (P)MTU. Rather, the chunks must be contained in
> +IP segments, padding respected. So unlike regular GSO, SCTP can't just
> +generate a big skb, set gso_size to the fragmentation point and deliver it
> +to IP layer.
> +
> +Instead, the SCTP protocol layer builds an skb with the segments correctly
> +padded and stored as chained skbs, and skb_segment() splits based on those.
> +To signal this, gso_size is set to the special value GSO_BY_FRAGS.
> +
> +Therefore, any code in the core networking stack must be aware of the
> +possibility that gso_size will be GSO_BY_FRAGS and handle that case
> +appropriately. (For size checks, the skb_gso_validate_*_len family of
> +helpers do this automatically.)
> +
> +This also affects drivers with the NETIF_F_FRAGLIST & NETIF_F_GSO_SCTP bits
> +set. Note also that NETIF_F_GSO_SCTP is included in NETIF_F_GSO_SOFTWARE.
> -- 
> 2.14.1
> 
