From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 12 May 2010 14:31:18 +0000
Subject: Re: [PATCH 2/3] sctp:check parameter value of length in HEARTBEAT
Message-Id: <4BEABBB6.2050909@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BEA7536.7080004@cn.fujitsu.com>
In-Reply-To: <4BEA7536.7080004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Shan Wei wrote:
> When an endpoint receives HEARTBEAT that parameter value is invalid,
> send an ABORT to peer with a Protocol Violation error code.
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_statefuns.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 3d3e36b..32e75ea 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1067,6 +1067,10 @@ sctp_disposition_t sctp_sf_beat_8_3(const struct sctp_endpoint *ep,
>  	 */
>  	chunk->subh.hb_hdr = (sctp_heartbeathdr_t *) chunk->skb->data;
>  	paylen = ntohs(chunk->chunk_hdr->length) - sizeof(sctp_chunkhdr_t);
> +
> +	if (ntohs(chunk->subh.hb_hdr->info.length) != paylen)
> +		sctp_sf_violation_paramvalue(ep, asoc, type, arg,
> +					     commands);

I don't think this is right as the parameter length doesn't account for the
padding, but the chunk length may.  Thus if such implementation sends us a HB,
we'll respond with an abort.

I don't see much point in this check.  HB parameters are opaque.  If someone
violates the protocol here, aborting the association is a very harsh treatment
since they are not really causing any overflows or any other conditions.

They may unnecessarily transmit horribly big HBs, but that's entirely up to them.

-vlad

>  	if (!pskb_pull(chunk->skb, paylen))
>  		goto nomem;
>  
