From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 31 Jul 2009 14:01:31 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet
Message-Id: <4A72F93B.1020408@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> The sender should create a SACK only if the size of the final SCTP
> packet does not exceed the current MTU. Base on RFC 4960:
> 
>   6.1.  Transmission of DATA Chunks
> 
>     Before an endpoint transmits a DATA chunk, if any received DATA
>     chunks have not been acknowledged (e.g., due to delayed ack), the
>     sender should create a SACK and bundle it with the outbound DATA
>     chunk, as long as the size of the final SCTP packet does not exceed
>     the current MTU.


I like this much better, but the one thing I don't like is that we end
up delaying the SACK if it doesn't fit in the chunk.

May be we can add some checking to see if there are more chunks that we'll
be sending and try to bundle it later.

Another question is whether we should really be sending an immediate SACK
back after receiving just one DATA?

I still think that this should really be handled by SACK immediately extension.
The extension can apply when we are single sub-MTU packets, essentially a
request-response scenario.  There is no reason that Immediate SACKs can't be
bundled in this manner.

-vlad


> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/output.c |   28 ++++++++++++++++------------
>  1 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 94c110d..21b9efd 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -222,6 +222,16 @@ static sctp_xmit_t sctp_packet_bundle_auth(struct sctp_packet *pkt,
>  	return retval;
>  }
>  
> +static int can_append_chunk(struct sctp_packet *pkt, size_t size)
> +{
> +	size_t psize = pkt->size;
> +	size_t pmtu = ((pkt->transport->asoc) ?
> +		       (pkt->transport->asoc->pathmtu) :
> +		       (pkt->transport->pathmtu));
> +
> +	return (psize + size <= pmtu);
> +}
> +
>  /* Try to bundle a SACK with the packet. */
>  static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  					   struct sctp_chunk *chunk)
> @@ -235,11 +245,15 @@ static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  	    !pkt->has_cookie_echo) {
>  		struct sctp_association *asoc;
>  		struct timer_list *timer;
> +		__u16 chunk_len;
> +
>  		asoc = pkt->transport->asoc;
>  		timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
> +		chunk_len = WORD_ROUND(ntohs(chunk->chunk_hdr->length)) +
> +			    sizeof(struct sctp_sack_chunk);
>  
>  		/* If the SACK timer is running, we have a pending SACK */
> -		if (timer_pending(timer)) {
> +		if (timer_pending(timer) && can_append_chunk(pkt, chunk_len)) {
>  			struct sctp_chunk *sack;
>  			asoc->a_rwnd = asoc->rwnd;
>  			sack = sctp_make_sack(asoc);
> @@ -262,9 +276,6 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
>  {
>  	sctp_xmit_t retval = SCTP_XMIT_OK;
>  	__u16 chunk_len = WORD_ROUND(ntohs(chunk->chunk_hdr->length));
> -	size_t psize;
> -	size_t pmtu;
> -	int too_big;
>  
>  	SCTP_DEBUG_PRINTK("%s: packet:%p chunk:%p\n", __func__, packet,
>  			  chunk);
> @@ -279,15 +290,8 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
>  	if (retval != SCTP_XMIT_OK)
>  		goto finish;
>  
> -	psize = packet->size;
> -	pmtu  = ((packet->transport->asoc) ?
> -		 (packet->transport->asoc->pathmtu) :
> -		 (packet->transport->pathmtu));
> -
> -	too_big = (psize + chunk_len > pmtu);
> -
>  	/* Decide if we need to fragment or resubmit later. */
> -	if (too_big) {
> +	if (!can_append_chunk(packet, chunk_len)) {
>  		/* It's OK to fragmet at IP level if any one of the following
>  		 * is true:
>  		 * 	1. The packet is empty (meaning this chunk is greater

